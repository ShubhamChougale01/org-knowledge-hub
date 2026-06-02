# Org Knowledge Hub

An internal AI-powered knowledge graph system for Coditas. Ask a chatbot plain English questions about the company — who works on which projects, who has specific skills, reporting relationships — and get factual answers from a live Neo4j graph database. No hallucinations, no guessing.

---

## Project Overview

Three layers working together:

1. **Knowledge Graph (Neo4j)** — 155 employees, 7 departments, 36 roles, 62 skills, 7 projects, 5 clients live as nodes and relationships (~279 nodes, ~1,847 relationships)

2. **Backend (FastAPI + LangChain)** — Takes plain English questions, generates Cypher queries using Groq's `llama-3.3-70b-versatile`, executes against Neo4j, formats answers back to natural language. Includes JWT auth with 4-level role-based access control and PII masking.

3. **Frontend (React + Vite)** — Chat interface, interactive org chart, and employee/project/client browsing. Users log in with email/password.

### Current Status

| Component | Status | Notes |
|---|---|---|
| Knowledge Graph | ✅ Complete | 279 nodes, 1847 relationships. Loaded via 11 seed files |
| Backend API | ✅ Complete | 5 routers, 3-tool chat pipeline, RBAC, caching, LangSmith tracing |
| Frontend UI | ✅ Complete | 6 pages, responsive design, session-aware |

---

## Repository Structure

```
org-knowledge-hub/
├── docker/
│   └── docker-compose.yml           # Neo4j 5.18 + Redis stack
│
├── data/
│   ├── seeds/                       # 11 Cypher files — seed data
│   │   ├── 01_constraints.cypher
│   │   ├── 02_departments.cypher
│   │   ├── 03_roles.cypher
│   │   ├── 04_skills.cypher
│   │   ├── 05_clients.cypher
│   │   ├── 06_employees.cypher
│   │   ├── 07_projects.cypher
│   │   ├── 08_relationships.cypher
│   │   ├── 09_certifications.cypher
│   │   ├── 10_promotions.cypher
│   │   └── 11_admin_users.cypher
│   ├── load_data.py                 # Runs all seed files in order
│   └── .env                         # DB credentials (not committed)
│
├── backend/                         # FastAPI + LangChain
│   ├── main.py                      # App entry, lifespan, route mounting
│   ├── config.py                    # Configuration (env var loading)
│   ├── backtest.py                  # Runs 20+ backtest queries (validation)
│   ├── requirements.txt
│   ├── .env                         # API keys, DB creds, JWT config
│   │
│   ├── models/
│   │   ├── auth.py                  # LoginRequest, TokenResponse, UserPayload
│   │   ├── chat.py                  # ChatRequest/Response, Cypher validation
│   │   ├── employee.py              # EmployeeResponse, EmployeeDetail
│   │   ├── project.py               # ProjectResponse, ProjectDetail
│   │   └── client.py                # ClientResponse, ClientDetail
│   │
│   ├── routes/
│   │   ├── auth_routes.py           # POST /auth/login
│   │   ├── chat_routes.py           # POST /chat
│   │   ├── employee_routes.py       # GET /employees, /employees/{id}, /employees/{id}/reporting-chain
│   │   ├── project_routes.py        # GET /projects, /projects/{id}
│   │   ├── client_routes.py         # GET /clients, /clients/{id}
│   │   └── dependencies.py          # get_current_user (JWT validation)
│   │
│   ├── controllers/
│   │   ├── auth_controller.py       # Login, token generation, access level derivation
│   │   ├── chat_controller.py       # Orchestrates chat pipeline (3 tools)
│   │   ├── employee_controller.py   # List/detail employees with PII masking
│   │   ├── project_controller.py    # List/detail projects
│   │   └── client_controller.py     # List/detail clients + team view
│   │
│   ├── services/
│   │   ├── auth.py                  # JWT creation/decoding, RBAC, PII masking
│   │   ├── graph.py                 # Neo4j driver, connection, indexes, schema
│   │   ├── cache.py                 # Redis client wrapper + health check
│   │   ├── langsmith_setup.py       # LangSmith tracing initialization
│   │   └── memory.py                # Session memory (chat history for context)
│   │
│   ├── tools/
│   │   ├── cypher_generator.py      # Tool 1: NL → Cypher (via Groq LLM)
│   │   ├── graph_executor.py        # Tool 2: Run Cypher, apply PII masking, cache results
│   │   └── answer_formatter.py      # Tool 3: Neo4j rows → natural language
│   │
│   └── scripts/
│       └── seed_sprints_and_ratings.py  # Optional: load sprint/rating data
│
├── frontend/                        # React 18 + Vite + Tailwind
│   ├── src/
│   │   ├── main.tsx                 # App entry
│   │   ├── App.tsx
│   │   ├── index.css
│   │   │
│   │   ├── pages/
│   │   │   ├── LoginPage.tsx        # Email/password login
│   │   │   ├── ChatPage.tsx         # Main chat interface
│   │   │   ├── OrgChartPage.tsx     # Interactive org hierarchy
│   │   │   ├── EmployeesPage.tsx    # Employee list + filtering
│   │   │   ├── ProjectsPage.tsx     # Project browsing
│   │   │   └── ClientsPage.tsx      # Client browsing
│   │   │
│   │   ├── components/
│   │   │   ├── Layout/              # AppLayout, Sidebar navigation
│   │   │   ├── Chat/                # Chat UI components
│   │   │   ├── Employee/            # Employee cards/details
│   │   │   └── OrgChart/            # Org chart visualization (React Flow)
│   │   │
│   │   ├── services/
│   │   │   └── api.ts               # Axios client to backend
│   │   │
│   │   ├── store/
│   │   │   └── auth.ts              # Auth state (Zustand)
│   │   │
│   │   └── types/
│   │       └── index.ts             # TypeScript interfaces
│   │
│   ├── package.json
│   └── vite.config.ts
│
├── reference/
│   ├── PROJECT_PLAN_V2.md           # Latest build plan, architecture decisions
│   ├── STEP1_README.md              # Graph schema, node counts, relationships
│   ├── Org_Knowledge_Hub_Blueprint.md  # Full ontology, 30+ use cases, sample Q&A
│   ├── tech_company_hierarchy.md    # 7-level role hierarchy reference
│   ├── cypher_query_reference.md    # 44 ready-to-run Cypher queries
│   └── backtest_queries.md          # Queries used by backtest.py
│
├── .env.example                     # Template for .env variables
├── CLAUDE.md                        # This file
└── README.md                        # (if present)
```

---

## Tech Stack

| Component | Tool | Purpose |
|---|---|---|
| **Graph DB** | Neo4j 5.18 | Native graph storage for org hierarchy and relationships |
| **LLM** | Groq `llama-3.3-70b-versatile` | Fast NL→Cypher generation, answer formatting |
| **LLM Orchestration** | LangChain | Tools framework, prompt management |
| **Backend API** | FastAPI + Pydantic | Fast async HTTP server, auto-docs at `/docs` |
| **Auth** | JWT (python-jose) | Stateless token-based auth, RBAC embedded in token |
| **Caching** | Redis | Query result caching (TTL varies by query type) |
| **Frontend** | React 18 + Vite + TailwindCSS + Lucide | Modern UI, fast dev server, icons |
| **Org Visualization** | React Flow | Interactive draggable org chart |
| **Observability** | LangSmith | Trace every NL→Cypher call for debugging |
| **Containerization** | Docker + docker-compose | Consistent local dev environment |

---

## Knowledge Graph Details

### Node Types (279 total)

| Type | Count | Description |
|---|---|---|
| Employee | 155 | Full profiles: name, email, DOB, joining date, experience, status |
| Department | 7 | Tech, Delivery, Sales, Marketing, HR, Finance, Executive |
| Role | 36 | Job titles with hierarchy levels 1–7 (1 = C-Suite, 7 = Entry) |
| Skill | 62 | Technical (Python, Neo4j, React…), Soft (Leadership…), Domain (FinTech…) |
| Project | 7 | NeuraVault, SentinelAI, OrgPulse, DataBridge, MarketLens, TalentFlow, CipherSec |
| Client | 5 | TechVentures Inc, SecureBank AG, RetailGlobal Ltd, MediCare Solutions, DataInsights Corp |
| Certification | — | Professional certifications (AWS, GCP, PMP, etc.) |
| PromotionHistory | — | Tracks role transitions and promotion dates |

### Relationship Types (1,847 total)

| Type | From | To | Properties |
|---|---|---|---|
| `BELONGS_TO` | Employee | Department | — |
| `HAS_ROLE` | Employee | Role | `is_current` (bool), `since` (date) |
| `REPORTS_TO` | Employee | Employee | `type` (line/matrix/project) |
| `ASSIGNED_TO` | Employee | Project | `role_in_project`, `is_current` |
| `HAS_SKILL` | Employee | Skill | `proficiency` (beginner/intermediate/expert) |
| `HAS_CERTIFICATION` | Employee | Certification | `issued_date`, `expiry_date` |
| `PROMOTED_TO` | Employee | Role | `promotion_date` |
| `MANAGES_PROJECT` | Employee | Project | — |
| `FOR_CLIENT` | Project | Client | — |

---

## Environment Variables

### Root Level: `.env.example` (copy to `.env`)

```
# Neo4j Database
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=coditas123

# LLM and Observability
GROQ_API_KEY=gsk_...
LANGSMITH_API_KEY=lsv2_pt_...
LANGSMITH_PROJECT=org-knowledge-hub

# Caching
REDIS_URL=redis://localhost:6379

# JWT Auth
JWT_SECRET=<long-random-string>
JWT_ALGORITHM=HS256
JWT_EXPIRES_HOURS=8

# Backend Server
BACKEND_PORT=8001
BACKEND_HOST=0.0.0.0

# Frontend
FRONTEND_PORT=5173
VITE_API_BASE_URL=http://localhost:8001

# Logging
LOG_LEVEL=INFO
```

### Data Layer: `data/.env` (for seed data loading)

```
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=coditas123
```

### Backend Layer: `backend/.env`

Contains all values from root `.env.example` except `FRONTEND_PORT` and `VITE_API_BASE_URL` (frontend-only). Backend reads from `backend/config.py` which sources `backend/.env` with fallbacks to root `.env`.

---

## How to Run

### Full Stack with Docker

```bash
cd docker
docker-compose up -d
# Neo4j Browser:  http://localhost:7474  (neo4j / coditas123)
# Redis: localhost:6379
```

### Load Data into Neo4j (first time only, or after MATCH (n) DETACH DELETE n in Neo4j Browser)

```bash
cd data
pip install -r requirements.txt
python load_data.py
```

### Backend Server

```bash
cd backend
pip install -r requirements.txt
# Ensure backend/.env is configured
uvicorn main:app --reload --port 8001
# API docs: http://localhost:8001/docs
# Health: http://localhost:8001/health
```

### Frontend Development Server

```bash
cd frontend
npm install
npm run dev
# Opens: http://localhost:5173
```

### Run Backtest (validation)

```bash
cd backend
python backtest.py
# Runs 20+ graph queries and prints results
```

### Reset Graph (wipe all data)

```
# In Neo4j Browser (http://localhost:7474):
MATCH (n) DETACH DELETE n
```

Then re-run `python data/load_data.py`.

---

## Backend Architecture

### MVC Pattern

- **Models** (`models/*.py`) — Pydantic schemas for request/response validation
- **Routes** (`routes/*.py`) — FastAPI path operations, JWT auth enforcement
- **Controllers** (`controllers/*.py`) — Business logic, orchestration
- **Services** (`services/*.py`) — Infrastructure (Neo4j, Redis, Auth, LangSmith)
- **Tools** (`tools/*.py`) — LangChain tools for the chat pipeline

### Chat Pipeline (3 Tools)

When a user asks a question, the backend runs this sequence:

1. **Cypher Generator** (`tools/cypher_generator.py`)
   - Input: User question + conversation history (for pronoun resolution)
   - LLM: Groq `llama-3.3-70b-versatile`
   - Output: Validated Cypher query
   - Special: Short-circuits template queries (e.g., "show top performers") to avoid LLM overhead
   - Validation: Blocked keywords, RETURN clause check, EXPLAIN syntax check, retry-on-failure

2. **Graph Executor** (`tools/graph_executor.py`)
   - Input: Cypher query, user's access level
   - Runs query against Neo4j
   - Applies Redis caching (configurable TTL: clients=600s, analytics=60s, org-chart=120s, default=300s)
   - Masks PII fields for access level (via `services/auth.py`)
   - Caps results to prevent token bloat (RESULT_SUMMARY_THRESHOLD)

3. **Answer Formatter** (`tools/answer_formatter.py`)
   - Input: Neo4j rows, conversation history
   - LLM: Groq `llama-3.3-70b-versatile`
   - Output: Natural language response
   - Zero-row edge case: Uses "helpful redirect" prompt
   - Caps data to 12,000 chars before LLM call

### Authentication & RBAC

Implemented in `services/auth.py`:

| Level | Who | PII Access | Where Checked |
|---|---|---|---|
| **L1 Admin** | HR dept + C-Suite (CEO, CTO, CFO, CHO, Chief) | Full (always) | Controllers + graph_executor |
| **L2 Manager** | Dept Heads, Managers, Leads | Full (team scope enforced) | Controllers + graph_executor |
| **L3 Employee** | All staff | Own profile only | Controllers + graph_executor |
| **L4 System** | Chatbot (default) | None (PII stripped) | graph_executor |

PII fields: `phone`, `dob`, `address`

JWT Token flow:
1. User POSTs email + password to `/auth/login`
2. `auth_controller.py` looks up employee, verifies password (bcrypt), derives access_level
3. `auth.py:create_token()` signs JWT with user data + access_level
4. Frontend stores token, sends `Authorization: Bearer <token>` on every request
5. `dependencies.py:get_current_user` validates token; raises 401 on invalid/expired
6. Controllers use decoded token to enforce PII masking

---

## Frontend Pages

All pages require authenticated JWT token (login first).

| Page | Route | Purpose |
|---|---|---|
| **Login** | `/` | Email/password → JWT token |
| **Chat** | `/chat` | Chat interface; sends questions to `/chat` endpoint, streams responses |
| **Org Chart** | `/org-chart` | Interactive hierarchical org visualization (React Flow); drag-to-explore |
| **Employees** | `/employees` | List + filter by department/project/skill; click for full profile |
| **Projects** | `/projects` | List projects, view team members, client info |
| **Clients** | `/clients` | List clients, associated projects, client contact details |

---

## What to Work On Next

### Immediate

1. **Validate Backtest** — Run and review `python backend/backtest.py` to confirm all 20+ queries execute correctly

2. **Port & Environment Consistency** — Verify:
   - `backend/.env` has `BACKEND_PORT=8001`
   - `frontend/.env` or `vite.config.ts` has `VITE_API_BASE_URL=http://localhost:8001`
   - No hardcoded localhost:8000 in frontend code

3. **Optional: Sprints & Ratings** — If needed, populate additional data:
   ```bash
   cd backend/scripts
   python seed_sprints_and_ratings.py
   ```

### Medium-Term

- **Production Hardening** — CORS allowlist refinement, HTTPS, rate limiting, structured logging
- **LangSmith Dashboard Review** — Check trace quality at https://smith.langchain.com (project: org-knowledge-hub)
- **Performance Tuning** — Profile Cypher generation latency, Redis hit rates, Neo4j query plans
- **Extended RBAC** — Add department-level access scopes (e.g., managers see only their team)

### Deployment

- **Docker Multi-Stage Builds** — Optimize image sizes
- **Environment Separation** — dev, staging, prod .env configs
- **Database Backup Strategy** — Neo4j export/import procedures
- **Monitoring & Alerting** — Application metrics, database health checks

---

## Key Reference Documents

All in `reference/`:

- **`PROJECT_PLAN_V2.md`** — Latest build plan and architectural decisions (Phase 1–3 status)
- **`STEP1_README.md`** — Knowledge graph schema, node/relationship counts, seed data overview
- **`Org_Knowledge_Hub_Blueprint.md`** — Full ontology, 30+ chatbot use cases with sample Q&A, RBAC design
- **`tech_company_hierarchy.md`** — 7-level organizational hierarchy reference
- **`cypher_query_reference.md`** — 44 ready-to-run Cypher queries (manual validation in Neo4j Browser)
- **`backtest_queries.md`** — Queries used by `backtest.py` validation suite

---

## Troubleshooting

**Neo4j won't start:**
```bash
docker-compose down
docker volume rm org-knowledge-hub_neo4j_data
docker-compose up -d
```

**Backend 401 Unauthorized:**
- Ensure `Authorization: Bearer <token>` header is sent
- Token may be expired (default 8 hours)
- Check `JWT_SECRET` and `JWT_ALGORITHM` match between `.env` and `config.py`

**Chat returns empty responses:**
- Check LangSmith traces at https://smith.langchain.com
- Verify Neo4j connection: `GET /health` should show `neo4j: healthy`
- Check `GROQ_API_KEY` is valid and has quota
- Ensure graph data is loaded: run `MATCH (n) RETURN count(n)` in Neo4j Browser

**Frontend can't reach backend:**
- Check `VITE_API_BASE_URL` in frontend environment
- Ensure backend is running on port 8001
- Check CORS allowlist includes your frontend origin

---

## For Users

**Help & feedback:** Check `/help` in Claude Code or report issues at https://github.com/anthropics/claude-code/issues

**Learning:** Refer to [Claude Code best practices](https://code.claude.com/docs/en/best-practices)
