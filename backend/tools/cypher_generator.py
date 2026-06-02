"""
Tool 1 — Cypher Generator

Converts a natural language question into a validated, safe Cypher query.

Steps:
  1. Send question + graph schema to Groq LLM
  2. Receive Cypher query
  3. Validate it (no DELETE/CREATE, must have RETURN, must parse with EXPLAIN)
  4. Enforce LIMIT on list queries (scale safety)
  5. If invalid → retry once with error feedback
  6. Return final Cypher

LangSmith automatically traces every LLM call here.
"""

import re
import logging
from langchain_groq import ChatGroq
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

from config import GROQ_API_KEY, GROQ_MODEL, CYPHER_DEFAULT_LIMIT, CYPHER_RETRY_ON_INVALID
from services.graph import load_schema, get_driver
from models.chat import CypherValidationResult

log = logging.getLogger(__name__)


# ─── LLM ────────────────────────────────────────────────────────────────
_llm = ChatGroq(
    model=GROQ_MODEL,
    api_key=GROQ_API_KEY,
    temperature=0.0,  # deterministic for query generation
    max_tokens=600,
)


# ─── Prompt template ────────────────────────────────────────────────────
_SYSTEM_PROMPT = """You are a Cypher query expert for a Neo4j knowledge graph.
Your only job is to convert natural language questions into valid Cypher queries.

{schema}

STRICT RULES — VIOLATIONS WILL BE REJECTED:
1. Use ONLY: MATCH, OPTIONAL MATCH, WHERE, WITH, RETURN, ORDER BY, LIMIT, UNION, COUNT, COLLECT, DISTINCT
2. NEVER use: DELETE, DROP, CREATE, SET, MERGE, REMOVE, DETACH, LOAD CSV
3. For list queries (returning multiple rows), ALWAYS add LIMIT {default_limit}
4. For COUNT queries, no LIMIT needed
5. For single-employee lookups by name/id, no LIMIT needed
6. Use OPTIONAL MATCH when a relationship may not exist
7. Use DISTINCT in COUNT when traversing multiple relationships
8. NAME MATCHING — be lenient since users often type partial names:
   - For Client names: use CONTAINS (e.g. `WHERE c.name CONTAINS 'TechVentures'`)
     because user may type 'TechVentures' but actual name is 'TechVentures Inc'
   - For Project names: use exact match only when name is fully written, otherwise CONTAINS
   - For Employee names: use exact `full_name` match when both first+last are given,
     otherwise use `toLower(e.full_name) CONTAINS toLower($name)`
   - Department names: always exact (Tech, Delivery, Sales, Marketing, HR, Finance, Executive)

OUTPUT FORMAT:
Return ONLY the Cypher query. No explanations, no markdown code fences, no commentary.

PRIORITY EXAMPLES — PERFORMANCE/RATING QUERIES:
These must be matched before other patterns to avoid falling back to ASSIGNED_TO.

Q: What is Ravi Shankar's performance on NeuraVault?
A: MATCH (e:Employee)-[r:HAS_PROJECT_RATING]->(p:Project {{name: 'NeuraVault'}})
   WHERE toLower(e.full_name) CONTAINS toLower('Ravi Shankar')
   RETURN e.full_name, r.stars, r.completion_pct, r.tasks_completed, r.tasks_total

Q: How many stars does Ashok Desai have?
A: MATCH (e:Employee)-[r:HAS_PROJECT_RATING]->(p:Project {{name: 'NeuraVault'}})
   WHERE toLower(e.full_name) CONTAINS toLower('Ashok Desai')
   RETURN e.full_name, r.stars, r.completion_pct, r.tasks_completed, r.tasks_total

Q: Who has 4 stars?
A: MATCH (e:Employee)-[r:HAS_PROJECT_RATING]->(p:Project {{name: 'NeuraVault'}})
   WHERE r.stars = 4
   RETURN e.full_name, r.stars, r.completion_pct, r.tasks_completed LIMIT {default_limit}

OTHER EXAMPLES:

Q: How many employees work in Tech?
A: MATCH (e:Employee)-[:BELONGS_TO]->(d:Department {{name: 'Tech'}}) RETURN count(e) AS headcount

Q: Who works on NeuraVault?
A: MATCH (e:Employee)-[:ASSIGNED_TO {{is_current: true}}]->(p:Project {{name: 'NeuraVault'}})
   RETURN e.full_name, e.employee_id LIMIT {default_limit}

Q: How many projects does TechVentures Inc have and who works on them?
A: MATCH (c:Client)<-[:FOR_CLIENT]-(p:Project)
   WHERE c.name CONTAINS 'TechVentures'
   OPTIONAL MATCH (e:Employee)-[:ASSIGNED_TO {{is_current: true}}]->(p)
   RETURN c.name, p.name, count(DISTINCT e) AS team_size,
          collect(DISTINCT e.full_name) AS employees LIMIT {default_limit}

Q: Who works on TechVentures?  (partial client name)
A: MATCH (e:Employee)-[:ASSIGNED_TO {{is_current: true}}]->(p:Project)-[:FOR_CLIENT]->(c:Client)
   WHERE c.name CONTAINS 'TechVentures'
   RETURN e.full_name, e.employee_id, p.name AS project LIMIT {default_limit}

Q: Who has AWS certification?
A: MATCH (e:Employee)-[:HAS_CERTIFICATION]->(c:Certification)
   WHERE c.name CONTAINS 'AWS'
   RETURN e.full_name, c.name, c.issued_date LIMIT {default_limit}

Q: Who does Shubham Chougale report to?
A: MATCH (e:Employee {{full_name: 'Shubham Chougale'}})-[:REPORTS_TO]->(m:Employee)
   RETURN m.full_name, m.email

Q: Who is the CEO? / List all CEOs / Who are the executives?
A: MATCH (e:Employee)-[:HAS_ROLE]->(r:Role {{title: 'CEO'}})
   RETURN e.full_name, e.employee_id, r.title LIMIT {default_limit}
   // ALWAYS match leadership roles by exact title, NEVER by level number.

Q: Who are all the department heads?
A: MATCH (e:Employee)-[:HAS_ROLE]->(r:Role)
   WHERE r.title CONTAINS 'Head' OR r.title CONTAINS 'Chief'
   RETURN e.full_name, r.title, r.department LIMIT {default_limit}

Q: What is Pooja Verma's Sprint 1 rating?
A: MATCH (e:Employee)-[r:HAS_SPRINT_RATING]->(s:Sprint {{name: 'Sprint 1'}})
   WHERE toLower(e.full_name) CONTAINS toLower('Pooja Verma')
   RETURN e.full_name, s.name, r.stars, r.completion_pct, r.tasks_completed, r.tasks_total

TASK QUERY EXAMPLES — use ASSIGNED_TASK relationship with completed property:

Q: Which tasks did Pooja Verma complete?
A: MATCH (e:Employee)-[a:ASSIGNED_TASK {{completed: true}}]->(t:Task)<-[:HAS_TASK]-(s:Sprint)<-[:HAS_SPRINT]-(p:Project {{name: 'NeuraVault'}})
   WHERE toLower(e.full_name) CONTAINS toLower('Pooja Verma')
   RETURN t.title AS task, t.feature_area AS feature_area, s.name AS sprint, a.completed_date AS completed_date
   ORDER BY s.name, t.title

Q: Which tasks has she completed? / What tasks did she finish?
A: (resolve "she" from conversation history, then use pattern above)

Q: Which tasks did Pooja Verma complete in Sprint 1?
A: MATCH (e:Employee)-[a:ASSIGNED_TASK {{completed: true}}]->(t:Task)<-[:HAS_TASK]-(s:Sprint {{name: 'Sprint 1'}})<-[:HAS_SPRINT]-(p:Project {{name: 'NeuraVault'}})
   WHERE toLower(e.full_name) CONTAINS toLower('Pooja Verma')
   RETURN t.title AS task, t.feature_area AS feature_area, a.completed_date AS completed_date
   ORDER BY t.title

Q: Which tasks are pending for Ravi Shankar?
A: MATCH (e:Employee)-[a:ASSIGNED_TASK {{completed: false}}]->(t:Task)<-[:HAS_TASK]-(s:Sprint)<-[:HAS_SPRINT]-(p:Project {{name: 'NeuraVault'}})
   WHERE toLower(e.full_name) CONTAINS toLower('Ravi Shankar')
   RETURN t.title AS task, t.feature_area AS feature_area, s.name AS sprint
   ORDER BY s.name, t.title

Q: How is the rating calculated? / On what basis is the rating given?
A: MATCH (e:Employee)-[a:ASSIGNED_TASK]->(t:Task)<-[:HAS_TASK]-(s:Sprint)<-[:HAS_SPRINT]-(p:Project {{name: 'NeuraVault'}})
   WITH e, s, count(t) AS total_tasks, sum(CASE WHEN a.completed THEN 1 ELSE 0 END) AS completed_tasks
   RETURN e.full_name, s.name AS sprint, completed_tasks, total_tasks,
          round(toFloat(completed_tasks)/total_tasks * 100, 1) AS completion_pct
   ORDER BY e.full_name, sprint
   LIMIT {default_limit}
"""

_USER_PROMPT = """{history_context}Question: {question}

Generate the Cypher query:"""

_RETRY_PROMPT = """The previous Cypher query was invalid:
{previous_cypher}

Error: {error}

Generate a corrected Cypher query for the question:
{question}

Return ONLY the corrected Cypher query."""


# ─── Validation ─────────────────────────────────────────────────────────
_BLOCKED_KEYWORDS = ["DELETE", "DROP", "CREATE ", "SET ", "MERGE", "REMOVE", "DETACH"]


def _strip_markdown(cypher: str) -> str:
    """Remove markdown code fences if LLM wrapped the query."""
    cypher = cypher.strip()
    # Remove ```cypher ... ``` or ```...```
    cypher = re.sub(r"^```(?:cypher)?\n?", "", cypher)
    cypher = re.sub(r"\n?```$", "", cypher)
    return cypher.strip()


def _enforce_limit(cypher: str, default: int = CYPHER_DEFAULT_LIMIT) -> str:
    """Add LIMIT if missing and query isn't a COUNT/aggregation."""
    upper = cypher.upper()
    if "LIMIT" in upper:
        return cypher
    # Don't add LIMIT to aggregations or single lookups
    if any(agg in upper for agg in ["COUNT(", "AVG(", "SUM(", "MIN(", "MAX("]):
        return cypher
    # Heuristic: if RETURN contains plural-looking patterns, add LIMIT
    if "RETURN" in upper:
        return cypher.rstrip(" ;\n") + f"\nLIMIT {default}"
    return cypher


def _validate(cypher: str, question: str = "") -> CypherValidationResult:
    """Validate a Cypher query against safety rules and syntax."""
    upper = cypher.upper()
    q_upper = question.upper()

    # SAFEGUARD: Rating queries must use HAS_PROJECT_RATING, not ASSIGNED_TO
    if any(word in q_upper for word in ["PERFORMANCE", "STARS", "RATING"]):
        if "ASSIGNED_TO" in upper and "HAS_PROJECT_RATING" not in upper:
            return CypherValidationResult(
                valid=False,
                cypher=cypher,
                reason="Performance/rating queries must use HAS_PROJECT_RATING relationship, not ASSIGNED_TO"
            )

    # SAFEGUARD: Task completion queries must use ASSIGNED_TASK relationship with completed property,
    # not Task.status node property (which is shared across employees and was removed in data model fix)
    if any(word in q_upper for word in ["TASK", "COMPLETED", "FINISH"]):
        if "T.STATUS" in upper or "TASK.STATUS" in upper:
            return CypherValidationResult(
                valid=False,
                cypher=cypher,
                reason="Task completion queries must use ASSIGNED_TASK {completed: true/false} relationship property, not Task.status node property"
            )

    # Check blocked keywords
    for kw in _BLOCKED_KEYWORDS:
        if kw in upper:
            return CypherValidationResult(
                valid=False,
                cypher=cypher,
                reason=f"Blocked keyword detected: {kw.strip()}"
            )

    # Must have RETURN
    if "RETURN" not in upper:
        return CypherValidationResult(
            valid=False,
            cypher=cypher,
            reason="Query must contain a RETURN clause"
        )

    # Syntax check using EXPLAIN (doesn't execute, just plans)
    try:
        driver = get_driver()
        with driver.session() as session:
            session.run(f"EXPLAIN {cypher}")
    except Exception as e:
        return CypherValidationResult(
            valid=False,
            cypher=cypher,
            reason=f"Syntax error: {str(e)[:200]}"
        )

    return CypherValidationResult(valid=True, cypher=cypher)


# ─── Chains ─────────────────────────────────────────────────────────────
_main_prompt = ChatPromptTemplate.from_messages([
    ("system", _SYSTEM_PROMPT),
    ("user", _USER_PROMPT),
])

_retry_prompt = ChatPromptTemplate.from_messages([
    ("system", _SYSTEM_PROMPT),
    ("user", _RETRY_PROMPT),
])

_main_chain = _main_prompt | _llm | StrOutputParser()
_retry_chain = _retry_prompt | _llm | StrOutputParser()


# ─── Rating query template matching (bypasses LLM for known patterns) ────
_RATING_KEYWORDS = ["performance", "star", "rating", "how many stars", "task completion"]
_TASK_KEYWORDS = ["which task", "what task", "tasks completed", "tasks she", "tasks he",
                  "tasks did", "tasks has", "completed task", "finish", "finished task",
                  "pending task", "incomplete task", "on what basis", "how is the rating",
                  "rating calculated", "rating based"]

def _extract_employee_name(question: str) -> str | None:
    """Extract employee name from a question using simple heuristics."""
    import re
    # "What is X's performance" / "How many stars does X have" / "X's rating"
    patterns = [
        r"(?:what is|what's)\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)'?s?\s+(?:performance|rating)",
        r"how many stars does\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)\s+have",
        r"([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)'?s?\s+(?:performance|rating|stars)",
        r"(?:performance|rating|stars)\s+(?:of|for)\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)",
    ]
    for pattern in patterns:
        m = re.search(pattern, question, re.IGNORECASE)
        if m:
            return m.group(1).strip()
    return None

def _extract_star_count(question: str) -> int | None:
    """Extract star count from 'who has N stars' questions."""
    import re
    m = re.search(r"(\d)\s+star", question, re.IGNORECASE)
    if m:
        return int(m.group(1))
    return None

def _match_rating_template(question: str) -> CypherValidationResult | None:
    """
    Detect rating/performance questions and return a pre-built Cypher query.
    Returns None if the question doesn't match a rating pattern.
    """
    q_lower = question.lower()
    if not any(kw in q_lower for kw in _RATING_KEYWORDS):
        return None

    # "Who has N stars on NeuraVault?"
    stars = _extract_star_count(question)
    if stars and "who" in q_lower:
        cypher = f"""MATCH (e:Employee)-[r:HAS_PROJECT_RATING]->(p:Project {{name: 'NeuraVault'}})
WHERE r.stars = {stars}
RETURN e.full_name AS full_name, r.stars AS stars, r.completion_pct AS completion_pct,
       r.tasks_completed AS tasks_completed, r.tasks_total AS tasks_total
LIMIT {CYPHER_DEFAULT_LIMIT}"""
        return CypherValidationResult(valid=True, cypher=cypher)

    # "What is X's performance / How many stars does X have?"
    name = _extract_employee_name(question)
    if name:
        cypher = f"""MATCH (e:Employee)-[r:HAS_PROJECT_RATING]->(p:Project {{name: 'NeuraVault'}})
WHERE toLower(e.full_name) CONTAINS toLower('{name}')
RETURN e.full_name AS full_name, r.stars AS stars, r.completion_pct AS completion_pct,
       r.tasks_completed AS tasks_completed, r.tasks_total AS tasks_total"""
        return CypherValidationResult(valid=True, cypher=cypher)

    # Generic "list all ratings / all performance"
    if any(w in q_lower for w in ["all", "list", "everyone", "everybody"]):
        cypher = f"""MATCH (e:Employee)-[r:HAS_PROJECT_RATING]->(p:Project {{name: 'NeuraVault'}})
RETURN e.full_name AS full_name, r.stars AS stars, r.completion_pct AS completion_pct,
       r.tasks_completed AS tasks_completed, r.tasks_total AS tasks_total
ORDER BY stars DESC
LIMIT {CYPHER_DEFAULT_LIMIT}"""
        return CypherValidationResult(valid=True, cypher=cypher)

    return None


def _extract_name_from_task_question(question: str, history: list[dict]) -> str | None:
    """Extract employee name from a task question, falling back to conversation history."""
    import re

    # Pronoun resolution first — "she", "her", "him", "he" → look up name from history
    pronoun_hints = ["she", "her", "he", "his", "him", "they", "same person", "same employee"]
    q_lower = question.lower()
    if any(p in q_lower for p in pronoun_hints) and history:
        # Pull the most recent capitalized two-word name from prior Q&A
        name_re = re.compile(r'\b([A-Z][a-z]+ [A-Z][a-z]+)\b')
        for entry in reversed(history):
            m = name_re.search(entry.get("question", "") + " " + entry.get("answer", ""))
            if m:
                return m.group(1)

    # Direct name in the question — no IGNORECASE so only real Capitalized Names match
    patterns = [
        r"(?:[Tt]asks?\s+(?:did|has|have|for))\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)",
        r"([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)\s+(?:complete|finish|complet)",
        r"(?:[Ww]hich|[Ww]hat)\s+[Tt]asks?\s+(?:did|has)\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)",
    ]
    for pattern in patterns:
        m = re.search(pattern, question)
        if m:
            return m.group(1).strip()

    return None


def _match_task_template(question: str, history: list[dict] = []) -> CypherValidationResult | None:
    """
    Detect task-related questions and return a pre-built Cypher query.
    Returns None if the question doesn't match a task pattern.
    """
    q_lower = question.lower()
    if not any(kw in q_lower for kw in _TASK_KEYWORDS):
        return None

    name = _extract_name_from_task_question(question, history)

    # Rating basis + specific employee tasks: "which tasks she completed and on task basis we are rating"
    # When a name (or pronoun-resolved name) is available, show that person's tasks + completion stats
    # When no name, show the overall completion breakdown
    is_rating_basis = any(kw in q_lower for kw in ["on what basis", "how is the rating", "rating calculated",
                                                     "rating based", "task basis", "on task basis",
                                                     "basis we are rating", "basis are we rating"])
    has_task_list = any(kw in q_lower for kw in ["which task", "what task", "tasks did", "tasks she",
                                                   "tasks he", "tasks completed"])

    if is_rating_basis and not has_task_list:
        # Pure "how is rating calculated" — show everyone's breakdown
        cypher = f"""MATCH (e:Employee)-[a:ASSIGNED_TASK]->(t:Task)<-[:HAS_TASK]-(s:Sprint)<-[:HAS_SPRINT]-(p:Project {{name: 'NeuraVault'}})
WITH e, s, count(t) AS total_tasks,
     size([x IN collect(a) WHERE x.completed = true]) AS completed_tasks
RETURN e.full_name AS full_name, s.name AS sprint, completed_tasks, total_tasks,
       round(toFloat(completed_tasks) / total_tasks * 100, 1) AS completion_pct
ORDER BY e.full_name, sprint
LIMIT {CYPHER_DEFAULT_LIMIT}"""
        return CypherValidationResult(valid=True, cypher=cypher)

    is_pending = any(w in q_lower for w in ["pending", "incomplete", "not completed", "not finish", "remaining"])
    completed_flag = "false" if is_pending else "true"

    # Sprint-specific task query
    import re
    sprint_match = re.search(r"sprint\s+(\d+)", q_lower)
    sprint_filter = ""
    if sprint_match:
        sprint_name = f"Sprint {sprint_match.group(1)}"
        sprint_filter = f"{{name: '{sprint_name}'}}"

    if name:
        cypher = f"""MATCH (e:Employee)-[a:ASSIGNED_TASK {{completed: {completed_flag}}}]->(t:Task)<-[:HAS_TASK]-(s:Sprint{sprint_filter})<-[:HAS_SPRINT]-(p:Project {{name: 'NeuraVault'}})
WHERE toLower(e.full_name) CONTAINS toLower('{name}')
RETURN e.full_name AS full_name, t.title AS task, t.feature_area AS feature_area,
       s.name AS sprint, a.completed_date AS completed_date
ORDER BY s.name, t.title"""
        return CypherValidationResult(valid=True, cypher=cypher)

    # Name could not be resolved — return a generic all-employee task breakdown so the
    # answer formatter can still give a useful response rather than 0 rows
    cypher = f"""MATCH (e:Employee)-[a:ASSIGNED_TASK]->(t:Task)<-[:HAS_TASK]-(s:Sprint{sprint_filter})<-[:HAS_SPRINT]-(p:Project {{name: 'NeuraVault'}})
WITH e, s, count(t) AS total_tasks,
     size([x IN collect(a) WHERE x.completed = true]) AS completed_tasks
RETURN e.full_name AS full_name, s.name AS sprint, completed_tasks, total_tasks,
       round(toFloat(completed_tasks) / total_tasks * 100, 1) AS completion_pct
ORDER BY e.full_name, sprint
LIMIT {CYPHER_DEFAULT_LIMIT}"""
    return CypherValidationResult(valid=True, cypher=cypher)


# ─── Public entry point ─────────────────────────────────────────────────
async def generate_cypher(question: str, history: list[dict] = []) -> CypherValidationResult:
    """
    Generate a validated Cypher query for the given natural-language question.

    Args:
        question: natural language question from the user
        history: last 2 Q&A pairs for resolving pronouns like "her", "same project"

    Returns:
        CypherValidationResult with .valid=True and .cypher containing the query
        OR .valid=False and .reason containing the error.
    """
    # Short-circuit for task questions — no LLM needed
    task_result = _match_task_template(question, history)
    if task_result:
        log.info(f"Task template matched for question: {question[:60]}")
        return task_result

    # Short-circuit for rating/performance questions — no LLM needed
    template_result = _match_rating_template(question)
    if template_result:
        log.info(f"Rating template matched for question: {question[:60]}")
        return template_result

    schema = load_schema()

    # Build history context to help resolve pronouns ("her", "same employee", etc.)
    history_context = ""
    if history:
        lines = ["Previous Q&A (use this to resolve pronouns like 'her', 'him', 'same project'):"]
        for entry in history:
            lines.append(f"Q: {entry['question']}")
            lines.append(f"A: {entry['answer'][:200]}")
        lines.append("")
        history_context = "\n".join(lines) + "\n"

    # First attempt
    raw = await _main_chain.ainvoke({
        "schema": schema,
        "default_limit": CYPHER_DEFAULT_LIMIT,
        "question": question,
        "history_context": history_context,
    })
    cypher = _strip_markdown(raw)
    cypher = _enforce_limit(cypher)

    result = _validate(cypher, question)
    if result.valid:
        return result

    # Retry once with error feedback
    if CYPHER_RETRY_ON_INVALID:
        log.info(f"Retrying Cypher generation. First attempt failed: {result.reason}")
        raw_retry = await _retry_chain.ainvoke({
            "schema": schema,
            "default_limit": CYPHER_DEFAULT_LIMIT,
            "question": question,
            "history_context": history_context,
            "previous_cypher": cypher,
            "error": result.reason or "unknown",
        })
        cypher_retry = _strip_markdown(raw_retry)
        cypher_retry = _enforce_limit(cypher_retry)
        result_retry = _validate(cypher_retry, question)
        if result_retry.valid:
            return result_retry

    return result  # return first failure with reason
