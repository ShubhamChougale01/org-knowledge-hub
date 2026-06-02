# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## What This Is

The FastAPI backend for Org Knowledge Hub — an AI-powered knowledge graph chatbot that answers questions about employee org structure, skills, and projects by converting natural language to Cypher queries against a Neo4j database.

---

## Backend Stack & Dependencies

**Core Framework:**
- **FastAPI** (≥0.115.0) — Modern async HTTP server, auto-generates OpenAPI docs at `/docs`
- **Uvicorn** (≥0.32.0) — ASGI server; used with `--reload` flag in development

**Graph Database:**
- **neo4j** (≥5.18.0) — Official Neo4j driver for Python; manages connection pool and query execution

**LLM & Orchestration:**
- **langchain** (≥0.3.27) — Framework for building LLM pipelines
- **langchain-groq** (≥0.3.0) — Integration for Groq's LLM API
- **langchain-community** (≥0.3.27) — Additional LangChain integrations
- **langsmith** (≥0.1.142) — Observability/tracing for all LLM calls

**Caching & Storage:**
- **redis** (≥5.1.1) — Optional; caches query results (app continues if down)

**Authentication & Security:**
- **python-jose** (≥3.3.0) — JWT token creation and validation (symmetric key)
- **passlib[bcrypt]** (≥1.7.4) — Password hashing (not used in current auth flow, but available)

**Utilities:**
- **python-dotenv** (≥1.0.1) — Loads `.env` files at startup
- **pydantic** (≥2.9.2) — Request/response validation and serialization

**No traditional test runner** — validation is done via `backtest.py` which runs end-to-end scenarios.

---

## Local Development Setup (without Docker)

### Prerequisites
- Python 3.9+ installed
- Neo4j instance running (either Docker or locally)
- Groq API key and LangSmith API key (free tier available)

### Step 1: Install dependencies
```bash
cd backend
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

pip install -r requirements.txt
```

### Step 2: Start Neo4j (Docker option)
```bash
cd ../docker
docker-compose up -d
# Verify: docker ps | grep neo4j
# Browser: http://localhost:7474 (neo4j / coditas123)
```

Or if running Neo4j locally without Docker:
- Ensure it's listening on `bolt://localhost:7687` (default port)
- Default credentials: `neo4j` / `coditas123`

### Step 3: Start Redis (optional, for caching)
```bash
# Docker option:
docker run -d -p 6379:6379 redis:latest

# Or run locally if installed:
redis-server
```

### Step 4: Create `.env` file in backend/
```bash
# Copy from root template
cp ../.env.example .env

# Edit .env with your values (see Environment Variables section below)
```

### Step 5: Seed the database (first time only)
```bash
cd ../data
python load_data.py
# This runs all 11 seed files in order (employees, projects, relationships, etc.)
```

### Step 6: Start the backend
```bash
cd ../backend
python main.py
```

Server listens at `http://localhost:8000`
- **API docs:** http://localhost:8000/docs (Swagger UI, try requests here)
- **Health check:** `GET http://localhost:8000/health`

---

## Backend Folder Structure

```
backend/
├── main.py                      # FastAPI app entry; startup/shutdown hooks, route mounting
├── config.py                    # Env var loading (centralized, fails fast on missing keys)
├── backtest.py                  # End-to-end test suite (~30 scenarios)
├── requirements.txt             # Python dependencies
├── .env                         # Local secrets (NOT committed)
│
├── models/                      # Pydantic request/response schemas
│   ├── __init__.py
│   ├── auth.py                  # LoginRequest, TokenResponse, UserPayload (4 RBAC levels)
│   ├── chat.py                  # ChatRequest, ChatResponse, CypherValidationResult
│   ├── employee.py              # EmployeeResponse, EmployeeDetail (with PII masking)
│   ├── project.py               # ProjectResponse, ProjectDetail
│   └── client.py                # ClientResponse, ClientDetail
│
├── routes/                      # FastAPI routers (endpoints only, logic in controllers)
│   ├── __init__.py
│   ├── auth_routes.py           # POST /auth/login → tokens
│   ├── chat_routes.py           # POST /chat → chatbot answer
│   ├── employee_routes.py       # GET /employees, /employees/{id}, /employees/{id}/reporting-chain
│   ├── project_routes.py        # GET /projects, /projects/{id}
│   ├── client_routes.py         # GET /clients, /clients/{id}
│   └── dependencies.py          # get_current_user (JWT token validation middleware)
│
├── controllers/                 # Business logic orchestration
│   ├── __init__.py
│   ├── auth_controller.py       # Login, token generation, access level derivation
│   ├── chat_controller.py       # Orchestrates 3-tool pipeline (Cypher → Execute → Format)
│   ├── employee_controller.py   # Fetch employees with PII masking by access level
│   ├── project_controller.py    # Fetch projects and team members
│   └── client_controller.py     # Fetch clients and assigned teams
│
├── services/                    # Shared integrations (database, auth, cache, observability)
│   ├── __init__.py
│   ├── graph.py                 # Neo4j driver singleton, connection, indexes, schema loader
│   ├── auth.py                  # JWT creation/decoding, RBAC levels, PII masking rules
│   ├── cache.py                 # Redis client wrapper, health check
│   ├── langsmith_setup.py       # LangSmith tracing initialization
│   └── memory.py                # In-memory conversation history (session context for chatbot)
│
├── tools/                       # Chatbot pipeline tools (NL → Cypher → Neo4j → Answer)
│   ├── __init__.py
│   ├── cypher_generator.py      # Tool 1: NL → Cypher (Groq LLM + validation + retry)
│   ├── graph_executor.py        # Tool 2: Execute Cypher, handle errors, apply PII masking
│   └── answer_formatter.py      # Tool 3: Neo4j rows → markdown → natural language
│
└── scripts/
    └── seed_sprints_and_ratings.py  # Optional: additional data seeding

---

## Quick Start Commands (TL;DR)

```bash
# 1. Install dependencies
python -m venv venv
source venv/bin/activate  # or: venv\Scripts\activate on Windows
pip install -r requirements.txt

# 2. Start Neo4j (first time setup)
cd ../docker && docker-compose up -d && cd ../backend

# 3. Load data into Neo4j (first time only)
cd ../data && python load_data.py && cd ../backend

# 4. Create .env file (copy from root template, fill in API keys)
cp ../.env.example .env
# Then edit .env with your GROQ_API_KEY, LANGSMITH_API_KEY, JWT_SECRET

# 5. Start the backend
python main.py
# Now at: http://localhost:8000/docs (Swagger UI for trying requests)

# 6. Validate everything works
python backtest.py
```

---

## API Conventions

### Endpoint Structure
All endpoints are prefixed by domain and follow REST conventions:
- **Auth:** `POST /auth/login` — single endpoint for token generation
- **Chat:** `POST /chat` — main conversational interface
- **Employees:** `GET /employees`, `GET /employees/{id}`, `GET /employees/{id}/reporting-chain`
- **Projects:** `GET /projects`, `GET /projects/{id}`
- **Clients:** `GET /clients`, `GET /clients/{id}`
- **Health:** `GET /health`, `GET /` — system status

**No API versioning yet** — routes don't have `/v1/` prefix. If breaking changes arise, will add versioning at that point.

### Request/Response Patterns

**All requests are Pydantic-validated.** Invalid payloads return `422 Unprocessable Entity` with validation details.

**All responses follow this structure:**
```python
# Success
{
    "data": <result>,
    "error": null
}

# Error
{
    "data": null,
    "error": {
        "code": "ERR_CODE",
        "message": "Human-readable description"
    }
}
```

**Authentication:**
- Login returns `{"access_token": "...", "token_type": "bearer"}`
- All protected endpoints require `Authorization: Bearer <token>` header
- Missing/invalid token → `401 Unauthorized`
- Insufficient permissions → `403 Forbidden`

### Error Handling

Errors are caught at the controller level and returned with appropriate HTTP status codes:
- `400` — Bad request (client error, invalid input)
- `401` — Unauthorized (missing/invalid token)
- `403` — Forbidden (insufficient RBAC level for requested data)
- `404` — Not found (entity doesn't exist)
- `500` — Server error (Neo4j timeout, LLM failure, unexpected crash)

LangSmith tracing captures all LLM call failures for debugging.

### RBAC Access Levels

Embedded in the JWT token as `access_level`:
1. **Admin (L1)** — HR, C-Suite — sees everything including phone, DOB, address
2. **Manager (L2)** — Department heads, PMs — sees their own team's full profiles
3. **Employee (L3)** — Everyone — sees org chart, own profile, project names
4. **Chatbot (L4)** — Non-PII fields only (default when querying without login)

When the chatbot generates Cypher, it injects WHERE clauses based on this level — the LLM doesn't need to know about it.

---

## Database Setup & Operations

### Initial Setup (first time)

**1. Verify Neo4j connectivity**
```bash
# From backend folder:
python -c "from services.graph import verify_connection; verify_connection(); print('✅ Connected')"
```

**2. Load seed data**
```bash
cd ../data
python load_data.py
# Runs all 11 seed files in order:
#   01_constraints.cypher
#   02_departments.cypher
#   03_roles.cypher
#   04_skills.cypher
#   05_clients.cypher
#   06_employees.cypher (155 employees)
#   07_projects.cypher
#   08_relationships.cypher
#   09_certifications.cypher
#   10_promotions.cypher
#   11_admin_users.cypher
```

**3. Verify data loaded**
```bash
# Check node count via Neo4j Browser (http://localhost:7474):
MATCH (n) RETURN count(n)
# Should return ~279 nodes

# Check relationships:
MATCH ()-[r]-() RETURN count(r)
# Should return ~1,847 relationships
```

### Reset the Database

If you need to start fresh:

**Option 1: Via Neo4j Browser**
1. Go to http://localhost:7474
2. Login with `neo4j` / `coditas123`
3. Run: `MATCH (n) DETACH DELETE n`
4. Re-run `python load_data.py` from the `data/` folder

**Option 2: Programmatically**
```bash
python -c "
from services.graph import get_driver, run_query
run_query('MATCH (n) DETACH DELETE n')
print('✅ Database cleared')
"
```

### Performance Indexes

Indexes are created automatically at startup in `main.py` (idempotent via `graph.py:create_indexes()`).
Currently indexed fields for fast lookups:
- `Employee.employee_id` (primary key)
- `Employee.full_name` (for search)
- `Department.name`
- `Project.name`
- `Skill.name`
- `Client.name`

To add a new index, modify `services/graph.py:create_indexes()` and restart the app.

### Running Cypher Queries Manually

**From Python:**
```python
from services.graph import run_query

result = run_query("MATCH (e:Employee) RETURN e LIMIT 5")
for row in result:
    print(row)
```

**From Neo4j Browser:** http://localhost:7474

**See 44+ pre-written queries:** `reference/cypher_query_reference.md`

---

## Environment Variables

All env vars are read in `config.py` at startup. Missing required vars cause immediate failure with a clear error message. Copy `.env.example` from the root to `backend/.env` and fill in your values.

### Required Variables

**Neo4j Connection:**
- `NEO4J_URI` — e.g., `bolt://localhost:7687` (default port; change if custom)
- `NEO4J_USER` — e.g., `neo4j`
- `NEO4J_PASSWORD` — e.g., `coditas123`

**Groq LLM:**
- `GROQ_API_KEY` — Get from https://console.groq.com (free tier available)
- `GROQ_MODEL` — Optional, defaults to `llama-3.3-70b-versatile`

**LangSmith Tracing:**
- `LANGSMITH_API_KEY` — Get from https://smith.langchain.com (free tier available)
- `LANGSMITH_PROJECT` — Project name in LangSmith (e.g., `org-knowledge-hub`)

**JWT Authentication:**
- `JWT_SECRET` — Any long random string (e.g., `openssl rand -base64 32`)

### Optional Variables

**Redis Cache:**
- `REDIS_URL` — Default: `redis://localhost:6379`. If missing/unreachable, app logs warning and continues

**Server:**
- `BACKEND_HOST` — Default: `0.0.0.0`
- `BACKEND_PORT` — Default: `8000`

**Logging:**
- `LOG_LEVEL` — Default: `INFO`. Set to `DEBUG` for verbose logs, `WARNING` for quiet mode

**JWT Tokens:**
- `JWT_ALGORITHM` — Default: `HS256` (symmetric)
- `JWT_EXPIRES_HOURS` — Default: `8`

**Cache TTLs (seconds):**
- `CACHE_TTL_EMPLOYEE` — Default: `300` (5 minutes)
- `CACHE_TTL_PROJECT` — Default: `300`
- `CACHE_TTL_CLIENT` — Default: `600` (10 minutes)
- `CACHE_TTL_ORG_CHART` — Default: `120` (2 minutes)
- `CACHE_TTL_ANALYTICS` — Default: `60` (1 minute)

**Chatbot Behavior:**
- `CYPHER_DEFAULT_LIMIT` — Default: `70`. LIMIT clause on list queries
- `CYPHER_MAX_LIMIT` — Default: `100`. Hard cap even if user asks for more
- `RESULT_SUMMARY_THRESHOLD` — Default: `70`. If results > this, summarize instead of listing
- `CYPHER_RETRY_ON_INVALID` — Default: `True`. Retry once if first Cypher attempt fails validation

### Example `.env`
```
# Neo4j
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=coditas123

# LLM
GROQ_API_KEY=gsk_xxxxxxxxxxxxx
GROQ_MODEL=llama-3.3-70b-versatile

# Observability
LANGSMITH_API_KEY=ls_xxxxxxxxxxxxx
LANGSMITH_PROJECT=org-knowledge-hub

# Auth
JWT_SECRET=your-super-secret-key-here-at-least-32-chars

# Optional
REDIS_URL=redis://localhost:6379
BACKEND_PORT=8000
LOG_LEVEL=INFO
```

---

## Key Design Patterns

### 1. Configuration centralization
All env vars are read in `config.py` at startup. No scattered `os.getenv()` calls. If a required var is missing, the app fails immediately with a clear error instead of mid-request.

### 2. Singleton driver
Neo4j driver is created once in `services/graph.py:get_driver()` and reused across all requests. Closed gracefully on shutdown via the FastAPI lifespan handler.

### 3. Pydantic schemas for every boundary
Request/response models live in `models/`. They validate inputs and auto-generate OpenAPI docs. The models are strict — validation failures return 422 immediately.

### 4. RBAC baked into the LLM
User access levels (Admin/Manager/Employee/Chatbot) are in the `UserPayload` model. When the chatbot generates Cypher, it injects WHERE clauses based on the user's level — the LLM doesn't need to know about it.

### 5. LangSmith tracing on every LLM call
Every call to the Groq LLM in `cypher_generator.py` is automatically traced by LangSmith. This makes debugging bad Cypher queries easy — you can replay the exact prompt + model behavior.

### 6. Validation in Cypher generator
Generated Cypher is validated before execution:
- Whitelist (MATCH, WHERE, RETURN, etc.) — no DELETE/CREATE
- LIMIT enforcement on list queries for scale safety
- Syntax check via EXPLAIN (doesn't run the query, just validates)
- If invalid → retry once with error feedback

### 7. Result caching by query hash
Query results are cached in Redis keyed on the Cypher hash. TTLs are per-type (employee 5min, project 5min, client 10min). Cache hits are logged.

---

## The Chatbot Pipeline (most important)

When a user posts to `POST /chat`:

1. **Route** → `chat_routes.py` extracts the question and user auth level
2. **Controller** → `chat_controller.py:handle_chat()` orchestrates
3. **Step 1: Generate Cypher** → `cypher_generator.py`
   - Sends question + full graph schema + RBAC constraints to Groq
   - Receives Cypher query string
   - Validates (whitelist, LIMIT, syntax via EXPLAIN)
   - If invalid → retry once with error feedback
   - **Traced in LangSmith** for debugging
4. **Step 2: Execute Cypher** → `graph_executor.py`
   - Runs the query against Neo4j
   - Catches errors (timeout, parse errors)
   - Returns raw records with type conversions (Neo4j temporal → Python native)
5. **Step 3: Format Answer** → `answer_formatter.py`
   - If results > threshold (70) → summarize; else → list all
   - Markdown formatting
   - Human-readable response
6. **Response** → `ChatResponse` model returned to frontend

**Debugging:**
- Check LangSmith trace for the exact prompt/model behavior in step 1
- Run the Cypher manually in Neo4j Browser to verify step 2
- Check logs for cache hits/misses and execution times

---

## What Changed Frequently

- **Cypher patterns** — if adding new query types, update the schema in `cypher_generator.py` and add test cases to `backtest.py`
- **RBAC rules** — modify the WHERE-clause injection in `auth.py:derive_access_level()` if security policies change
- **Result formatting** — adjust thresholds and markdown in `answer_formatter.py`
- **Cache TTLs** — configured in `config.py` per resource type

---

## Testing

There is no pytest yet. Testing is done via `backtest.py`, which runs 30+ real scenarios:
- Direct employee lookups
- Org chart traversals
- Skill searches
- Project assignments
- Client relationships
- etc.

Each scenario verifies:
1. Cypher is generated without error
2. Query returns expected results
3. Answer is formatted without error
4. Edge cases don't crash the system

To add a test:
1. Add a new `@check()` block in `backtest.py`
2. Call the relevant controller/service directly
3. Assert the result

---

## Useful Files to Read First

If you're new to the codebase:
1. **config.py** — understand all available config vars
2. **main.py** — understand the startup/shutdown sequence
3. **services/graph.py** — understand how Neo4j queries are executed
4. **tools/cypher_generator.py** — understand the NL→Cypher pipeline
5. **backtest.py** — understand what the system is expected to do

---

## Common Gotchas

- **Neo4j auth failures** — make sure `.env` has correct `NEO4J_USER/PASSWORD` and Neo4j is running (`docker ps | grep neo4j`)
- **Missing Groq API key** — backtest will fail on LLM calls; check console.groq.com
- **Temporal type mismatch** — Neo4j returns `Date` and `DateTime` objects; `graph.py:_convert_record()` converts them to Python native types before Pydantic sees them
- **Cache not working** — Redis is optional; app continues if it's down (logs a warning)
- **LIMIT not being enforced** — check `cypher_generator.py` regex for list vs. count detection

---

## Deployment Notes

The app uses FastAPI's lifespan handler to:
1. Verify Neo4j connectivity at startup
2. Create performance indexes (idempotent)
3. Set up LangSmith tracing
4. Close connections gracefully on shutdown

For production:
- Set `LOG_LEVEL=WARNING` to reduce spam
- Use environment-specific JWT_SECRETs
- Monitor LangSmith traces for degraded query quality
- Set up Redis for persistent caching
- Consider setting stricter RBAC access levels in `auth.py`
