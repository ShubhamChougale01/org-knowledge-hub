"""
Neo4j connection service.
- Singleton driver: created once, shared across all requests
- run_query(): safe query executor with parameter binding
- load_schema(): pulls schema text used by the LLM in chatbot.py
- create_indexes(): performance indexes added at startup (idempotent)
- verify_connection(): fails fast at startup if Neo4j is unreachable
"""

from typing import Optional, Any
from datetime import date, datetime
from neo4j import GraphDatabase, Driver
from neo4j.exceptions import ServiceUnavailable, AuthError
from neo4j.time import Date as Neo4jDate, DateTime as Neo4jDateTime

from config import NEO4J_URI, NEO4J_USER, NEO4J_PASSWORD


def _convert_value(v: Any) -> Any:
    """Convert Neo4j temporal types to Python native types so Pydantic accepts them."""
    if isinstance(v, Neo4jDate):
        return date(v.year, v.month, v.day)
    if isinstance(v, Neo4jDateTime):
        return datetime(v.year, v.month, v.day, v.hour, v.minute, int(v.second))
    if isinstance(v, list):
        return [_convert_value(item) for item in v]
    if isinstance(v, dict):
        return {k: _convert_value(val) for k, val in v.items()}
    return v


def _convert_record(record: dict) -> dict:
    """Apply _convert_value to every field in a record."""
    return {k: _convert_value(v) for k, v in record.items()}


# ─── Singleton driver ───────────────────────────────────────────────────
_driver: Optional[Driver] = None


def get_driver() -> Driver:
    """Get or create the singleton Neo4j driver."""
    global _driver
    if _driver is None:
        _driver = GraphDatabase.driver(
            NEO4J_URI,
            auth=(NEO4J_USER, NEO4J_PASSWORD),
            max_connection_lifetime=3600,
            max_connection_pool_size=70,
        )
    return _driver


def close_driver() -> None:
    """Close the driver — called on app shutdown."""
    global _driver
    if _driver is not None:
        _driver.close()
        _driver = None


# ─── Connection verification ────────────────────────────────────────────
def verify_connection() -> bool:
    """Verify Neo4j is reachable. Raises on failure."""
    try:
        driver = get_driver()
        driver.verify_connectivity()
        return True
    except AuthError as e:
        raise RuntimeError(f"Neo4j auth failed — check NEO4J_USER/PASSWORD: {e}")
    except ServiceUnavailable as e:
        raise RuntimeError(
            f"Neo4j unreachable at {NEO4J_URI} — is Docker running? "
            f"Try: docker ps | grep neo4j\nError: {e}"
        )


# ─── Query execution ────────────────────────────────────────────────────
def run_query(cypher: str, params: dict | None = None) -> list[dict[str, Any]]:
    """
    Execute a Cypher query and return rows as a list of dicts.

    Args:
        cypher: The Cypher query string
        params: Parameters bound to query placeholders (safer than string interpolation)

    Returns:
        List of dicts, one per result row. Empty list if no results.
    """
    driver = get_driver()
    with driver.session() as session:
        result = session.run(cypher, params or {})
        return [_convert_record(dict(record)) for record in result]


def run_query_single(cypher: str, params: dict | None = None) -> dict[str, Any] | None:
    """Execute a query expected to return at most one row. Returns None if empty."""
    rows = run_query(cypher, params)
    return rows[0] if rows else None


# ─── Performance indexes (scale fix from plan) ──────────────────────────
STARTUP_INDEXES = [
    "CREATE INDEX employee_name_index IF NOT EXISTS FOR (e:Employee) ON (e.full_name)",
    "CREATE INDEX employee_email_index IF NOT EXISTS FOR (e:Employee) ON (e.email)",
    "CREATE INDEX employee_status_index IF NOT EXISTS FOR (e:Employee) ON (e.current_status)",
    "CREATE INDEX project_status_index IF NOT EXISTS FOR (p:Project) ON (p.status)",
    "CREATE INDEX project_name_index IF NOT EXISTS FOR (p:Project) ON (p.name)",
    "CREATE INDEX skill_name_index IF NOT EXISTS FOR (s:Skill) ON (s.name)",
    "CREATE INDEX dept_name_index IF NOT EXISTS FOR (d:Department) ON (d.name)",
    "CREATE INDEX client_name_index IF NOT EXISTS FOR (c:Client) ON (c.name)",
    "CREATE INDEX cert_name_index IF NOT EXISTS FOR (c:Certification) ON (c.name)",
    "CREATE INDEX sprint_id_index IF NOT EXISTS FOR (s:Sprint) ON (s.sprint_id)",
    "CREATE INDEX task_id_index IF NOT EXISTS FOR (t:Task) ON (t.task_id)",
]


def create_indexes() -> int:
    """
    Create performance indexes if they don't exist.
    Idempotent — safe to run on every startup.

    Returns: number of indexes ensured to exist.
    """
    driver = get_driver()
    count = 0
    with driver.session() as session:
        for stmt in STARTUP_INDEXES:
            session.run(stmt)
            count += 1
    return count


# ─── Schema loader (used by LLM in chatbot.py) ──────────────────────────
SCHEMA_TEXT = """
Neo4j Graph Schema for Coditas Org Knowledge Hub:

NODES:
- Employee {employee_id, full_name, email, phone, dob, gender, address,
            employment_type, joining_date, total_experience_years,
            org_experience_years, current_status, profile_photo_url}
- Department {dept_id, name}
            // name is one of: Tech, Delivery, Sales, Marketing, HR, Finance, Executive
- Role {role_id, title, level, department}
            // level is 2..7 where HIGHER = more senior.
            // 7 = C-Suite (CEO, CTO, CFO, CHO), 6 = Heads, 5 = Managers/PMs,
            // 4 = Senior IC, 3 = IC, 2 = Associate/Entry.
            // IMPORTANT: To find leaders/CEO/executives, prefer matching by TITLE
            // (e.g. r.title = 'CEO') NOT by level number, because titles are exact.
            // Exact titles available: 'CEO', 'CTO', 'Chief Financial Officer',
            // 'Chief Human Resources Officer', 'Tech Head', 'Delivery Head',
            // 'Sales Head', 'Marketing Head', 'HR Head', 'Finance Head',
            // 'Product Manager', 'Project Manager', 'Senior Engineer', 'Engineer',
            // 'Associate Engineer'
- Project {project_id, name, description, type, status, start_date, end_date,
           tech_stack, client_name, team_size}
            // type: Client / Internal
            // status: Active / Completed / On-hold
- Sprint {sprint_id, name, start_date, end_date, status}
            // status: Active / Completed
- Task {task_id, title, feature_area, status}
            // status: Completed / In-Progress / Not-Started
- Skill {skill_id, name, category}
            // category: Technical / Soft / Domain
- Certification {cert_id, name, issuer, issued_date, expiry_date}
- Client {client_id, name, industry, country}
- PromotionHistory {history_id, from_role, to_role, effective_date}

RELATIONSHIPS:
- (Employee)-[:BELONGS_TO {since}]->(Department)
- (Employee)-[:HAS_ROLE {since, is_current}]->(Role)
- (Employee)-[:REPORTS_TO {type, since, until}]->(Employee)
            // type: 'line' or 'project'
- (Employee)-[:ASSIGNED_TO {role_in_project, start_date, end_date, is_current}]->(Project)
- (Employee)-[:HAS_SKILL {proficiency, years}]->(Skill)
            // proficiency: 'beginner' / 'intermediate' / 'expert'
- (Employee)-[:HAS_CERTIFICATION {obtained_date}]->(Certification)
- (Employee)-[:PROMOTED_TO]->(PromotionHistory)
- (Employee)-[:MANAGES_PROJECT]->(Project)
- (Project)-[:FOR_CLIENT]->(Client)
- (Project)-[:HAS_SPRINT]->(Sprint)
- (Sprint)-[:HAS_TASK]->(Task)
- (Employee)-[:ASSIGNED_TASK {assigned_date}]->(Task)
- (Employee)-[:HAS_SPRINT_RATING {overall_stars, period}]->(Sprint)
- (Employee)-[:HAS_PROJECT_RATING {overall_stars, period, calculation_method}]->(Project)
- (PromotionHistory)-[:IN_DEPARTMENT]->(Department)

AVAILABLE VALUES:
- Departments: Tech, Delivery, Sales, Marketing, HR, Finance, Executive
- Clients: TechVentures Inc, SecureBank AG, RetailGlobal Ltd,
          MediCare Solutions, DataInsights Corp
- Project names: NeuraVault, SentinelAI, OrgPulse, DataBridge, MarketLens,
                TalentFlow, CipherSec
- Skill categories: Technical, Soft, Domain
- Common skills: Python, Java, Neo4j, LangChain, FastAPI, React, AWS,
                 Docker, Kubernetes, Leadership, Communication

CYPHER RULES:
- Use only MATCH, OPTIONAL MATCH, WHERE, WITH, RETURN, ORDER BY, LIMIT
- Never use DELETE, DROP, CREATE, SET, MERGE, REMOVE
- For list queries, always add LIMIT 70 (or as user specifies)
- For COUNT queries, no LIMIT needed
- For PII queries (phone, dob, address), the result will be filtered by RBAC
- Use OPTIONAL MATCH when relationships may not exist
- Use DISTINCT in aggregations to avoid duplicates across multi-hop paths
"""


def load_schema() -> str:
    """Return the schema text used as context for the LLM."""
    return SCHEMA_TEXT.strip()


# ─── Health check ───────────────────────────────────────────────────────
def health_check() -> dict[str, Any]:
    """Return basic health info about the Neo4j connection."""
    try:
        result = run_query_single("MATCH (n) RETURN count(n) AS node_count")
        return {
            "neo4j": True,
            "node_count": result["node_count"] if result else 0,
            "uri": NEO4J_URI,
        }
    except Exception as e:
        return {
            "neo4j": False,
            "error": str(e),
            "uri": NEO4J_URI,
        }
