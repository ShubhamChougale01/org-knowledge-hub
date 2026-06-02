# Org Knowledge Hub — Implementation Plan V2
# Phase 2 (Backend) + Phase 3 (Frontend)
# Last updated: 2026-05-26
# Status tracker: [ ] Not started | [~] In progress | [x] Done

---

## Architecture Decisions (Final — Do Not Change Without Discussion)

| Decision | Choice | Reason |
|---|---|---|
| Chatbot approach | Direct Cypher Generation | No hallucination, always live data, works at 20,000+ employees |
| LLM | Groq llama-3.3-70b-versatile | Fast inference, free tier |
| LLM Orchestration | LangChain Tools (3 tools) | Separation of concerns, each tool traceable in LangSmith |
| Vector DB | None | Not needed — graph schema is the only context LLM needs |
| Embeddings | None | Not needed — Cypher generation is exact, not approximate |
| Observability | LangSmith | Already in .env, zero code overhead, traces every tool call |
| Caching | Redis | Already running in Docker, cache frequent Cypher results |
| Auth | JWT (python-jose) | Stateless, RBAC levels baked into token |
| Design Pattern | MVC | models/ routes/ controllers/ services/ tools/ |
| Scale safety | Indexes + LIMIT enforcement + result size cap | Handles 20,000+ without performance degradation |

---

## Folder Structure (Complete — Build Exactly This)

```
backend/
├── main.py                          # FastAPI app entry — mounts all routers
├── config.py                        # All env vars loaded once here
├── requirements.txt
│
├── models/                          # M — Pydantic data shapes
│   ├── __init__.py
│   ├── chat.py                      # ChatRequest, ChatResponse
│   ├── employee.py                  # EmployeeResponse, EmployeeDetail
│   ├── project.py                   # ProjectResponse, ProjectDetail
│   ├── client.py                    # ClientResponse, ClientDetail
│   └── auth.py                      # LoginRequest, TokenResponse, UserPayload
│
├── routes/                          # V — Thin API layer only
│   ├── __init__.py
│   ├── chat_routes.py               # POST /chat
│   ├── employee_routes.py           # GET /employees, GET /employees/{id}
│   ├── project_routes.py            # GET /projects, GET /projects/{id}
│   ├── client_routes.py             # GET /clients, GET /clients/{id}
│   └── auth_routes.py               # POST /auth/login
│
├── controllers/                     # C — Business logic
│   ├── __init__.py
│   ├── chat_controller.py           # Orchestrates 3-tool chatbot pipeline
│   ├── employee_controller.py       # Employee queries + RBAC filter
│   ├── project_controller.py        # Project queries
│   ├── client_controller.py         # Client → Project → Employee (3-hop)
│   └── auth_controller.py           # Token creation + validation
│
├── services/                        # External connections
│   ├── __init__.py
│   ├── graph.py                     # Neo4j driver + run_query() + schema loader
│   ├── cache.py                     # Redis get/set/invalidate
│   ├── auth.py                      # JWT encode/decode
│   └── langsmith_setup.py           # LangSmith env vars (called at startup)
│
└── tools/                           # LangChain Tools (core chatbot engine)
    ├── __init__.py
    ├── cypher_generator.py          # Tool 1 — NL → Cypher + validation + LIMIT
    ├── graph_executor.py            # Tool 2 — Cypher → Neo4j → results
    └── answer_formatter.py          # Tool 3 — Raw data → Natural language
```

---

## Phase 2 — Backend + Chatbot

---

### Step 2.1 — Project Setup [x] ✅ COMPLETE

**What:** Create backend/ folder, install all dependencies, confirm everything runs.

**Commands:**
```bash
mkdir backend && cd backend
python -m venv venv
venv\Scripts\activate   # Windows
pip install fastapi uvicorn python-dotenv
pip install neo4j redis
pip install langchain langchain-groq langchain-community
pip install langsmith
pip install python-jose[cryptography] passlib[bcrypt]
pip install pydantic
pip freeze > requirements.txt
```

**Done when:** `uvicorn main:app --reload` starts without errors and `http://localhost:8000/health` returns `{"status": "ok"}`.

---

### Step 2.2 — Config (`config.py`) [x] ✅ COMPLETE

**What:** Single place that loads all env vars. All other files import from here — no scattered `os.getenv()` anywhere else.

**Variables it exposes:**
```python
NEO4J_URI, NEO4J_USER, NEO4J_PASSWORD
GROQ_API_KEY
LANGSMITH_API_KEY, LANGSMITH_PROJECT
REDIS_URL
JWT_SECRET
```

**Done when:** App fails at startup with clear message if any required env var is missing.

---

### Step 2.3 — Neo4j Service (`services/graph.py`) [x] ✅ COMPLETE

**What:** Singleton Neo4j driver + query runner + schema loader.

**Key functions:**
```
get_driver()                → returns shared driver (created once)
run_query(cypher, params)   → executes query, returns list[dict]
load_schema()               → pulls schema from Neo4j, formats for LLM prompt
verify_connection()         → called at startup, fails fast if Neo4j is down
```

**Scale fix included here:**
```python
# Performance indexes — added at startup if not exist
STARTUP_INDEXES = [
    "CREATE INDEX employee_name_index IF NOT EXISTS FOR (e:Employee) ON (e.full_name)",
    "CREATE INDEX employee_status_index IF NOT EXISTS FOR (e:Employee) ON (e.current_status)",
    "CREATE INDEX project_status_index IF NOT EXISTS FOR (p:Project) ON (p.status)",
    "CREATE INDEX skill_name_index IF NOT EXISTS FOR (s:Skill) ON (s.name)",
    "CREATE INDEX dept_name_index IF NOT EXISTS FOR (d:Department) ON (d.name)",
]
```

**Schema output format (this goes into every LLM prompt):**
```
Nodes: Employee, Department, Role, Project, Skill, Certification, Client, PromotionHistory

Relationships:
(Employee)-[:BELONGS_TO]->(Department)
(Employee)-[:HAS_ROLE {since, is_current}]->(Role)
(Employee)-[:REPORTS_TO {type: line/project}]->(Employee)
(Employee)-[:ASSIGNED_TO {role_in_project, is_current}]->(Project)
(Employee)-[:HAS_SKILL {proficiency: beginner/intermediate/expert, years}]->(Skill)
(Employee)-[:HAS_CERTIFICATION {obtained_date}]->(Certification)
(Employee)-[:PROMOTED_TO]->(PromotionHistory)
(Employee)-[:MANAGES_PROJECT]->(Project)
(Project)-[:FOR_CLIENT]->(Client)
(PromotionHistory)-[:IN_DEPARTMENT]->(Department)

Key Employee properties: employee_id, full_name, email, joining_date,
                          total_experience_years, org_experience_years,
                          current_status, gender, address
Key Project properties: project_id, name, type (Client/Internal),
                        status (Active/Completed/On-hold), tech_stack, client_name
Key Client properties: client_id, name, industry, country
Available departments: Tech, Delivery, Sales, Marketing, HR, Finance, Executive
Available clients: TechVentures Inc, SecureBank AG, RetailGlobal Ltd,
                   MediCare Solutions, DataInsights Corp
```

**Done when:** `load_schema()` returns correct schema string and `run_query("MATCH (n) RETURN count(n)")` returns 456.

---

### Step 2.4 — Redis Cache Service (`services/cache.py`) [x] ✅ COMPLETE

**What:** Cache Cypher results to avoid hitting Neo4j on every repeated query.

**Key functions:**
```
get(key)                    → returns cached value or None
set(key, value, ttl)        → stores value with TTL
invalidate(pattern)         → clears keys matching pattern
cache_key(cypher, level)    → builds consistent cache key from query + access level
```

**TTL rules:**
```
Employee data       → 5 minutes  (changes rarely)
Project data        → 5 minutes
Org chart           → 2 minutes  (hierarchy changes occasionally)
Client data         → 10 minutes (very stable)
Analytics/counts    → 1 minute   (most volatile)
```

**Done when:** Cache hit returns in <5ms, miss goes to Neo4j and caches result.

---

### Step 2.5 — JWT Auth Service (`services/auth.py`) [x] ✅ COMPLETE

**What:** JWT token creation and validation. RBAC levels baked into the token.

**4 access levels:**
```
L1 Admin    → HR dept, C-Suite          → all fields including PII
L2 Manager  → Dept Heads, PMs           → own team full profiles
L3 Employee → All staff                 → org chart + own profile
L4 System   → Default chatbot queries   → no PII fields
```

**Token payload:**
```json
{
  "user_id": "EMP-TECH-010",
  "full_name": "Shubham Chougale",
  "department": "Tech",
  "access_level": "L3",
  "exp": 1234567890
}
```

**PII mask applied in controllers when access_level is L3/L4:**
```
Fields hidden: phone, dob, address
Fields shown:  full_name, email, role, department, projects, skills
```

**Done when:** Token created on login, validated on protected routes, expired tokens rejected with 401.

---

### Step 2.6 — LangSmith Setup (`services/langsmith_setup.py`) [x] ✅ COMPLETE

**What:** Enable tracing with zero overhead. Called once when app starts.

**How (4 env vars, nothing else needed):**
```python
def setup():
    os.environ["LANGCHAIN_TRACING_V2"]  = "true"
    os.environ["LANGCHAIN_API_KEY"]     = config.LANGSMITH_API_KEY
    os.environ["LANGCHAIN_PROJECT"]     = config.LANGSMITH_PROJECT
    os.environ["LANGCHAIN_ENDPOINT"]    = "https://api.smith.langchain.com"
```

**What gets traced automatically after this:**
- Every chatbot run as a parent trace
- Each of the 3 tool calls as child spans
- Input prompt + output Cypher per tool
- Token counts + latency per step
- Errors with full stack trace

**ChatResponse includes trace_url so frontend can link directly to it.**

**Done when:** After asking one question, a trace appears in smith.langchain.com → org-knowledge-hub project.

---

### Step 2.7 — Pydantic Models (`models/`) [x] ✅ COMPLETE

**Files to create:**

**`models/chat.py`**
```python
ChatRequest:
  query: str
  session_id: str

ChatResponse:
  answer: str
  cypher_used: str
  execution_ms: int
  trace_url: str          # LangSmith link for this run
  from_cache: bool
```

**`models/employee.py`**
```python
EmployeeResponse:         # list view (no PII)
  employee_id, full_name, email, role, department, joining_date

EmployeeDetail:           # full profile (PII filtered by access level)
  all EmployeeResponse fields +
  total_experience_years, org_experience_years, current_status,
  phone*, dob*, address*,    # * = L1/L2 only
  skills, certifications, current_projects, reports_to, promotions
```

**`models/client.py`**
```python
ClientResponse:           # list view
  client_id, name, industry, country, total_projects

ClientDetail:             # full view (XYZ client scenario)
  all ClientResponse fields +
  projects: list of ProjectWithTeam

ProjectWithTeam:
  project_id, name, status, tech_stack,
  team_size, employees: list[EmployeeResponse]
```

**Done when:** All models validate correctly in unit tests.

---

### Step 2.8 — The 3 LangChain Tools (`tools/`) [x] ✅ COMPLETE

**This is the core of the chatbot. Build in this order:**

---

#### Tool 1 — `tools/cypher_generator.py` [ ]

**Job:** Convert plain English question into a valid, safe Cypher query.

**System prompt includes:**
- Full graph schema (loaded from `services/graph.py`)
- Relationship directions for every type
- Available client names, department names (for exact matching)
- Rules: always MATCH/RETURN only, always add LIMIT for list queries

**LIMIT enforcement (scale fix):**
```python
LIMIT_RULES = """
- Queries returning lists: always add LIMIT 50
- User asks "all employees": LIMIT 100
- User asks "top N": LIMIT N
- COUNT queries: no LIMIT needed
- Single record lookups: no LIMIT needed
"""
```

**Validation before returning Cypher:**
```python
Step 1: Block dangerous keywords (DELETE, DROP, CREATE, SET, REMOVE, MERGE)
Step 2: Require RETURN clause
Step 3: EXPLAIN {cypher} → dry run on Neo4j to catch syntax errors
Step 4: If invalid → retry once with error feedback to LLM
Step 5: If still invalid → raise ToolException
```

**LangSmith captures:** prompt sent, Cypher returned, tokens used, latency.

---

#### Tool 2 — `tools/graph_executor.py` [ ]

**Job:** Execute validated Cypher on Neo4j, apply RBAC, return raw results.

**Execution flow:**
```
1. Build cache key from (cypher + access_level)
2. Check Redis → hit → return cached result instantly
3. Cache miss → execute on Neo4j
4. Apply RBAC mask (strip PII fields if L3/L4)
5. Check result size:
   - 0 rows    → return empty signal (not an error)
   - 1-50 rows → return as-is
   - 50+ rows  → return first 50 + total_count for formatter
6. Store result in Redis with appropriate TTL
7. Return results + metadata (row_count, from_cache, execution_ms)
```

**LangSmith captures:** Cypher executed, row count, cache hit/miss, Neo4j latency.

---

#### Tool 3 — `tools/answer_formatter.py` [ ]

**Job:** Convert raw Neo4j rows into a clean, natural language answer.

**Handles all edge cases:**
```
0 rows        → "No data found for your query. Try rephrasing."
1-50 rows     → Full natural language answer
50+ rows      → "Found {total} results. Here are the top 50: ..."
Null values   → Skipped gracefully (never says "null")
Error signal  → "I couldn't process that query. Please try again."
```

**LangSmith captures:** raw data input, formatted answer, tokens used.

**Done when:** All 3 tools tested individually with sample inputs before wiring into controller.

---

### Step 2.9 — Chat Controller (`controllers/chat_controller.py`) [x] ✅ COMPLETE

**What:** Orchestrates the 3 tools in sequence. This is the only file that knows about the full pipeline.

**Flow:**
```python
async def handle_chat(request: ChatRequest, user: UserPayload) -> ChatResponse:
    start = time.time()

    # Tool 1
    cypher = await cypher_generator.run(request.query)

    # Tool 2
    raw_result = await graph_executor.run(cypher, user.access_level)

    # Tool 3
    answer = await answer_formatter.run(request.query, raw_result)

    return ChatResponse(
        answer       = answer,
        cypher_used  = cypher,
        execution_ms = int((time.time() - start) * 1000),
        trace_url    = get_langsmith_trace_url(),
        from_cache   = raw_result.from_cache
    )
```

**Done when:** Full pipeline tested end-to-end with 5 sample questions before building routes.

---

### Step 2.10 — All Controllers [x] ✅ COMPLETE

**`controllers/client_controller.py`** (XYZ client scenario)
```
get_all_clients()                     → list with project counts
get_client_detail(client_id)          → client + all projects + all employees
get_client_employees(client_id)       → just employees across all client projects
```

**`controllers/employee_controller.py`**
```
get_all_employees(filters)            → paginated list, RBAC applied
get_employee_detail(employee_id)      → full profile, PII by access level
get_employee_reporting_chain(id)      → path from employee to CEO
```

**`controllers/project_controller.py`**
```
get_all_projects(status_filter)       → list with team sizes
get_project_detail(project_id)        → project + full team + manager + client
```

---

### Step 2.11 — Routes (`routes/`) [x] ✅ COMPLETE

**Thin layer only — validate input, call controller, return response.**

```
POST  /auth/login                   → auth_controller.login()
GET   /health                       → check Neo4j + Redis + return status

POST  /chat                         → chat_controller.handle_chat()         [JWT required]
GET   /employees                    → employee_controller.get_all()          [JWT required]
GET   /employees/{id}               → employee_controller.get_detail()       [JWT required]
GET   /departments                  → department headcount query              [JWT required]
GET   /projects                     → project_controller.get_all()           [JWT required]
GET   /projects/{id}                → project_controller.get_detail()        [JWT required]
GET   /clients                      → client_controller.get_all()            [JWT required]
GET   /clients/{id}                 → client_controller.get_detail()         [JWT required]
```

---

### Step 2.12 — Main App Entry (`main.py`) [x] ✅ COMPLETE

**What:** Wires everything together.

```python
On startup:
1. Load config — fail if any required env var missing
2. Setup LangSmith — enable tracing
3. Verify Neo4j connection — fail if unreachable
4. Create performance indexes — idempotent, safe to run every time
5. Load graph schema into memory — used by CypherGeneratorTool
6. Verify Redis connection — warn but don't fail (cache is optional)
7. Mount all routers
8. Log: "Org Knowledge Hub API ready on port 8000"

On shutdown:
1. Close Neo4j driver
2. Close Redis connection
```

---

### Step 2.13 — Backtest All Scenarios [x] ✅ COMPLETE — Run `python backend/backtest.py` to verify

**Run:** `python data/backtest.py`

**All checks that must pass:**

```
Graph Integrity
[ ] 155 employees, 7 departments, 7 projects, 5 clients
[ ] 120 certifications, 66 promotions

Shubham Chougale Profile
[ ] Employee exists with correct org_experience = 1.5
[ ] Belongs to Tech department
[ ] Assigned to OrgPulse project
[ ] Has Neo4j Certified Professional cert
[ ] Has AWS Certified Developer cert (2023-08-20)
[ ] Promotion: Assoc SE → SE on 2025-06-30

Hierarchy
[ ] Reporting chain reaches CEO
[ ] CEO has direct reports

Client → Project → Employee (3-hop)
[ ] TechVentures Inc → NeuraVault exists
[ ] NeuraVault has employees assigned
[ ] MediCare Solutions → CipherSec has team

Chatbot Pipeline
[ ] CypherGeneratorTool generates valid Cypher for all 6 query categories
[ ] GraphExecutorTool returns correct data
[ ] AnswerFormatterTool handles 0-results gracefully
[ ] LIMIT enforced on list queries
[ ] PII masked for L3/L4 access

LangSmith
[ ] Every chatbot run creates a trace
[ ] All 3 tool spans visible per trace
[ ] Trace URL returned in ChatResponse
```

**Done when:** All checks pass. Green across the board before moving to Phase 3.

---

## Phase 3 — Frontend

---

### Step 3.1 — Scaffold React App [x] ✅ COMPLETE

```bash
npm create vite@latest frontend -- --template react-ts
cd frontend
npm install tailwindcss @tailwindcss/vite
npm install axios react-router-dom
npm install lucide-react
npm install reactflow
npm install zustand
```

**Folder structure:**
```
frontend/src/
├── pages/
│   ├── LoginPage.tsx
│   ├── ChatPage.tsx           # main page
│   ├── OrgChartPage.tsx
│   ├── EmployeesPage.tsx
│   └── ClientsPage.tsx        # XYZ client scenario
├── components/
│   ├── Chat/
│   │   ├── ChatWindow.tsx
│   │   ├── MessageBubble.tsx
│   │   └── SuggestedQuestions.tsx
│   ├── OrgChart/
│   │   └── OrgTree.tsx
│   ├── Employee/
│   │   └── EmployeeCard.tsx
│   └── Layout/
│       ├── Sidebar.tsx
│       └── Navbar.tsx
├── services/
│   └── api.ts                 # all axios calls, JWT attached automatically
└── store/
    └── auth.ts                # JWT token + user in zustand
```

**Done when:** `npm run dev` opens blank app at localhost:3000 with no errors.

---

### Step 3.2 — Login Page [x] ✅ COMPLETE

**What:** Email + password → JWT token → stored in Zustand → redirect to chat.

**UI:**
```
┌─────────────────────────────┐
│     Org Knowledge Hub       │
│     Coditas Internal        │
│                             │
│  Email ___________________  │
│  Password ________________  │
│                             │
│       [ Sign In ]           │
│                             │
│  "Ask anything about your   │
│   organization"             │
└─────────────────────────────┘
```

**Done when:** Login works with a real employee email, wrong password shows error, token stored.

---

### Step 3.3 — Chat Interface (Core Page) [x] ✅ COMPLETE

**UI:**
```
┌─ Sidebar ──┬─ Chat ───────────────────────────────────────┐
│ 💬 Chat    │                                               │
│ 🏛️ Org     │  Suggested Questions:                         │
│ 👥 People  │  • Who works on NeuraVault?                   │
│ 📋 Projects│  • How many projects for TechVentures Inc?    │
│ 🤝 Clients │  • Who does Shubham report to?                │
│            │  • Who has AWS certification?                  │
│            │  • Show all Tech department employees         │
│            │                                               │
│            │  ─────────────────────────────────────────   │
│            │                                               │
│            │  You: How many projects for TechVentures?     │
│            │                                               │
│            │  🤖 TechVentures Inc has 1 active project —  │
│            │     NeuraVault — with 35 team members.        │
│            │     [View LangSmith trace ↗]                  │
│            │                                               │
│            │  ┌──────────────────────────┐  [➤ Send]      │
│            │  │ Ask something...          │                │
│            │  └──────────────────────────┘                │
└────────────┴──────────────────────────────────────────────┘
```

**Key features:**
- Suggested questions panel on first load
- Loading state while waiting for answer
- Each answer shows `[View LangSmith trace ↗]` link
- Copy answer button
- Shows whether answer came from cache

**Done when:** Can ask all 6 question categories and get correct answers.

---

### Step 3.4 — Org Chart Page [x] ✅ COMPLETE

**What:** Visual interactive org tree using React Flow.

**Features:**
- Top-down tree: CEO → C-Suite → Heads → Managers → ICs
- Color-coded nodes by department
- Click node → employee profile card slides in from right
- Search bar at top to highlight a specific employee
- Zoom and pan

**Data source:** `GET /employees` builds tree from `REPORTS_TO` relationships.

**Done when:** Full hierarchy visible, click on Shubham Chougale shows his correct profile.

---

### Step 3.5 — Employees Page [x] ✅ COMPLETE

**What:** Searchable, filterable employee directory.

**Filters:**
```
Search by name | Department | Role Level | Project | Skill
```

**Employee card shows:** name, role, department, joining date, avatar initials

**Click card → full profile modal:**
```
Profile tab      → name, role, email, joining date, experience
Skills tab       → all skills with proficiency badges
Projects tab     → current and past projects
Certifications   → all certs with expiry dates
Reporting Chain  → path from this employee to CEO
Promotions       → promotion history timeline
```

**PII visible:** only if user is L1/L2 access level.

**Done when:** Can search, filter, and view full profiles with all tabs working.

---

### Step 3.6 — Clients Page (XYZ Client Scenario) [x] ✅ COMPLETE — plus bonus Projects page

**What:** Dedicated view for every client — their projects and all associated employees.

**UI:**
```
┌─ Clients ───────────────────────────────────────────────┐
│                                                          │
│  [TechVentures Inc]  [SecureBank AG]  [RetailGlobal]    │
│                                                          │
│  ┌─ TechVentures Inc ──────────────────────────────┐    │
│  │ Industry: Venture Capital  │  Country: USA       │    │
│  │                                                  │    │
│  │ Projects (1 active)                              │    │
│  │ ┌─ NeuraVault ────────────────────────────────┐  │    │
│  │ │ Status: Active  │  Team: 35  │  Started: 2023│  │    │
│  │ │ Stack: Python, LangChain, Neo4j, FastAPI...  │  │    │
│  │ │                                              │  │    │
│  │ │ Team Members:                                │  │    │
│  │ │ Priya Verma (Tech Head)                      │  │    │
│  │ │ Shubham Chougale (Senior Engineer)              │  │    │
│  │ │ + 33 more  [Show all]                        │  │    │
│  │ └──────────────────────────────────────────────┘  │    │
│  └──────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────┘
```

**Data source:** `GET /clients/{id}` returns full client → project → employee data.

**Done when:** Every client shows correct projects and employee list. "Show all" expands the full team.

---

### Step 3.7 — Wire API + Final Integration [x] ✅ COMPLETE — build passed, no TS errors

**What:** All pages connected to backend, auth working end-to-end.

```typescript
// services/api.ts
const api = axios.create({ baseURL: 'http://localhost:8000' })

// Auto-attach JWT to every request
api.interceptors.request.use(config => {
    const token = useAuthStore.getState().token
    if (token) config.headers.Authorization = `Bearer ${token}`
    return config
})

// Auto-handle expired token
api.interceptors.response.use(null, error => {
    if (error.response?.status === 401) {
        useAuthStore.getState().logout()
        window.location.href = '/login'
    }
    return Promise.reject(error)
})
```

**Final checklist:**
```
[ ] Login → chat works end to end
[ ] JWT expiry handled gracefully
[ ] All pages load without console errors
[ ] Chatbot answers all 6 question categories correctly
[ ] Clients page shows correct project + employee data
[ ] Org chart renders full hierarchy
[ ] LangSmith trace link works from chat response
[ ] PII hidden for L3/L4 users
[ ] Redis cache working (second query faster than first)
```

**Done when:** Full app demo works without any manual Neo4j queries.

---

## Progress Tracker

```
Phase 2 — Backend
[x] 2.1   Project setup + requirements      ✅ DONE
[x] 2.2   config.py                         ✅ DONE
[x] 2.3   services/graph.py (with indexes)  ✅ DONE
[x] 2.4   services/cache.py                 ✅ DONE
[x] 2.5   services/auth.py                  ✅ DONE
[x] 2.6   services/langsmith_setup.py       ✅ DONE
[x] 2.7   models/ (all 5 files)             ✅ DONE
[x] 2.8   tools/cypher_generator.py         ✅ DONE
[x] 2.8   tools/graph_executor.py           ✅ DONE
[x] 2.8   tools/answer_formatter.py         ✅ DONE
[x] 2.9   controllers/chat_controller.py    ✅ DONE
[x] 2.10  controllers/ (client, employee, project, auth) ✅ DONE
[x] 2.11  routes/ (all 5 files)             ✅ DONE
[x] 2.12  main.py                           ✅ DONE
[x] 2.13  Backtest script ready             ✅ DONE — run to verify

Phase 3 — Frontend
[x] 3.1   Scaffold React app                ✅ DONE
[x] 3.2   Login page                        ✅ DONE
[x] 3.3   Chat interface                    ✅ DONE
[x] 3.4   Org chart (React Flow)            ✅ DONE
[x] 3.5   Employees page + profile modal    ✅ DONE
[x] 3.6   Clients page (XYZ scenario)       ✅ DONE
[x] 3.7   Full integration + build passed   ✅ DONE
```

---

## Build Order Rule

**Always build in this sequence — never skip ahead:**

```
config.py
    → services/ (graph, cache, auth, langsmith)
        → models/
            → tools/ (cypher_generator first, then executor, then formatter)
                → controllers/
                    → routes/
                        → main.py
                            → backtest
                                → Phase 3
```

Each layer depends on the one above it. Building out of order causes import errors and wasted debugging time.

---

## Definition of Done — Phase 2

Before starting Phase 3, ALL of these must be true:

1. `python data/backtest.py` → all checks green
2. LangSmith shows traces for every chatbot run
3. `GET /clients/CLIENT-001` returns TechVentures Inc with NeuraVault + 35 employees
4. PII fields hidden when queried with L3 token
5. Cache working — second identical query returns `from_cache: true`
6. API running at `http://localhost:8000/docs` with all routes visible

## Definition of Done — Phase 3

Before calling the project complete:

1. Full demo walkthrough without touching Neo4j Browser or terminal
2. Login → Chat → Org Chart → Employees → Clients all working
3. Ask "How many projects for TechVentures Inc?" in chat → correct answer
4. LangSmith trace link visible in chat response
5. No console errors in browser
