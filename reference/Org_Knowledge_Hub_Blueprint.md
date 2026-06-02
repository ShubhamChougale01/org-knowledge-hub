# Org Knowledge Hub — Project Blueprint
**Version:** 1.0 (PoC)
**Classification:** Internal
**Prepared For:** Coditas Engineering Team

---

## Table of Contents
1. [Executive Summary](#1-executive-summary)
2. [Business Goals](#2-business-goals)
3. [Ontology Design](#3-ontology-design)
4. [Data Ownership & Governance](#4-data-ownership--governance)
5. [Security & Access Control](#5-security--access-control)
6. [Query Requirements & Chatbot Use Cases](#6-query-requirements--chatbot-use-cases)
7. [Scale Expectations](#7-scale-expectations)
8. [Knowledge Graph Schema](#8-knowledge-graph-schema)
9. [Dummy Data Specification](#9-dummy-data-specification)
10. [Cypher Query Templates](#10-cypher-query-templates)
11. [Tech Stack Recommendation](#11-tech-stack-recommendation)
12. [Implementation Roadmap](#12-implementation-roadmap)

---

## 1. Executive Summary

The **Org Knowledge Hub** is an internal AI-powered knowledge graph system built on Neo4j, enabling employees and HR to query structured organizational data through a natural language chatbot — without hallucinations. The system maps employees, their roles, departments, reporting hierarchies, skills, project histories, and certifications into an interconnected graph. A conversational AI layer translates user questions into Cypher queries and returns factual, grounded answers.

**Core Value Proposition:**
- Zero-hallucination answers about employees, teams, and projects
- Instant org-chart traversal and reporting chain lookup
- Project history and skill-gap analysis
- Dynamic updates as employees join, leave, or change roles

---

## 2. Business Goals

| Goal | Description | Success Metric |
|------|-------------|----------------|
| **Structured Org Intelligence** | Eliminate tribal knowledge silos by centralizing employee and project data in a traversable graph | 100% of 150+ employees modelled |
| **Hallucination-Free Chatbot** | All chatbot answers grounded in graph facts via Cypher queries — no LLM confabulation | 0 factually incorrect answers in test suite |
| **Semantic Employee Search** | Find employees by skills, experience, or role combinations using natural language | Latency < 600ms for 95th percentile |
| **Organizational Analytics** | Headcount, hierarchy depth, project allocation, tenure analysis | Dashboards queryable in < 600ms |
| **Historical Tracking** | Promotion history, project timelines, and hierarchy changes preserved | Full audit trail retained |

---

## 3. Ontology Design

### 3.1 Node Types (Entities)

#### `Employee`
| Property | Type | Notes |
|----------|------|-------|
| `employee_id` | String (UUID) | Unique, immutable |
| `full_name` | String | |
| `email` | String | Unique |
| `phone` | String | Confidential |
| `dob` | Date | Confidential |
| `gender` | String | |
| `address` | String | Confidential |
| `employment_type` | Enum | Full-time / Contract / Intern |
| `joining_date` | Date | |
| `total_experience_years` | Float | Pre-joining experience |
| `org_experience_years` | Float | Computed / maintained |
| `current_status` | Enum | Active / Inactive / On-leave |
| `profile_photo_url` | String | |

#### `Department`
| Property | Type | Notes |
|----------|------|-------|
| `dept_id` | String | Unique |
| `name` | Enum | HR / Sales / Marketing / Tech / Finance / Delivery |
| `created_at` | Date | |

#### `Role`
| Property | Type | Notes |
|----------|------|-------|
| `role_id` | String | Unique |
| `title` | String | CEO / CTO / CFO / Delivery Head / Project Manager / Sr. Software Engineer / Software Engineer / Associate Software Engineer / HR Manager / HR Executive / Sales Head / Sales Manager / Sales Executive / Marketing Head / Marketing Manager / Marketing Executive / Finance Head / Finance Manager / Finance Analyst |
| `level` | Integer | 1 = C-Suite, 2 = Head, 3 = Manager, 4 = Senior IC, 5 = IC, 6 = Associate |
| `department` | String | Parent dept |

#### `Project`
| Property | Type | Notes |
|----------|------|-------|
| `project_id` | String | Unique |
| `name` | String | |
| `description` | String | |
| `type` | Enum | Client / Internal |
| `status` | Enum | Active / Completed / On-hold |
| `start_date` | Date | |
| `end_date` | Date | Null if active |
| `tech_stack` | List<String> | |
| `client_name` | String | Null if internal |

#### `Skill`
| Property | Type | Notes |
|----------|------|-------|
| `skill_id` | String | Unique |
| `name` | String | Python, React, Neo4j, etc. |
| `category` | Enum | Technical / Soft / Domain |

#### `Certification`
| Property | Type | Notes |
|----------|------|-------|
| `cert_id` | String | Unique |
| `name` | String | |
| `issuer` | String | |
| `issued_date` | Date | |
| `expiry_date` | Date | |

#### `Client`
| Property | Type | Notes |
|----------|------|-------|
| `client_id` | String | Unique |
| `name` | String | |
| `industry` | String | |
| `country` | String | |

#### `PromotionHistory`
| Property | Type | Notes |
|----------|------|-------|
| `history_id` | String | Unique |
| `from_role` | String | |
| `to_role` | String | |
| `effective_date` | Date | |

---

### 3.2 Relationship Types (Edges)

| Relationship | From → To | Properties | Notes |
|---|---|---|---|
| `BELONGS_TO` | Employee → Department | `since: Date` | Single dept per employee |
| `HAS_ROLE` | Employee → Role | `since: Date`, `is_current: Boolean` | Current and historical |
| `REPORTS_TO` | Employee → Employee | `type: Enum (line/project)`, `since: Date`, `until: Date` | Supports dual reporting |
| `ASSIGNED_TO` | Employee → Project | `role_in_project: String`, `start_date: Date`, `end_date: Date`, `is_current: Boolean` | Many-to-many |
| `HAS_SKILL` | Employee → Skill | `proficiency: Enum (beginner/intermediate/expert)`, `years: Float` | |
| `HAS_CERTIFICATION` | Employee → Certification | `obtained_date: Date` | |
| `PREVIOUSLY_WORKED_AT` | Employee → Company (string stored on edge) | `from_date: Date`, `to_date: Date`, `role: String` | |
| `PROMOTED_TO` | Employee → PromotionHistory | `date: Date` | For audit trail |
| `MANAGES_PROJECT` | Employee → Project | `since: Date` | PM / Tech Lead |
| `FOR_CLIENT` | Project → Client | | |
| `PART_OF_DEPT` | Project → Department | | |

---

### 3.3 Hierarchy Levels (Tech Department — Reference)

```
Level 1: CEO
Level 2: CTO / CFO / CMO / CHO (Chief HR Officer)
Level 3: Delivery Head / Tech Head / Sales Head / Marketing Head / HR Head / Finance Head
Level 4: Project Manager / Team Lead
Level 5: Senior Software Engineer / Senior Analyst / Senior Designer
Level 6: Software Engineer / Analyst / Designer
Level 7: Associate Software Engineer / Associate Analyst
```

All 6 departments follow the same 7-level pattern with role names adapted per function.

---

## 4. Data Ownership & Governance

| Data Category | Owner | Notes |
|---|---|---|
| Employee PII (DOB, phone, address) | HR Department | Confidential — restricted access |
| Professional data (skills, certs, projects) | Employee + Manager | Visible to team |
| Salary / compensation | Finance + HR | Not stored in this PoC |
| Project details | Delivery Head / PM | Visible org-wide |
| Promotion history | HR | Visible to managers and above |
| Org chart / hierarchy | HR | Visible to all employees |

**Confidential fields** (masked or access-restricted):
- `dob`, `phone`, `address`, `employment_type` → HR and Managers only
- `email` → All employees (internal directory)

---

## 5. Security & Access Control

### Role-Based Access (RBAC)

| Access Level | Who | Can See |
|---|---|---|
| **L1 — Admin** | HR, C-Suite | Everything including confidential PII |
| **L2 — Manager** | Project Managers, Dept Heads | Own team's full profiles + project data |
| **L3 — Employee** | All employees | Own profile + public org chart + project names |
| **L4 — Chatbot** | System user for the chatbot | Non-PII fields only (unless querying self) |

### Key Rules
- An employee can always query their own full profile
- Managers can see all details of their direct and indirect reports
- Confidential fields (`phone`, `dob`, `address`) are masked in chatbot responses unless user is HR/Admin
- Project client names are visible internally to all employees

---

## 6. Query Requirements & Chatbot Use Cases

### 6.1 Chatbot Question Categories & Sample Q&A

#### Category A — Employee Lookup
| Question | Answer Pattern | Cypher Intent |
|---|---|---|
| "Who is Shubham Chougale?" | Name, role, department, joining date, org experience | MATCH employee by name |
| "What is Priya's email?" | email field | MATCH employee, return email |
| "How long has Rahul been in the company?" | org_experience_years | MATCH employee, return org_experience_years |
| "Who joined in December 2024?" | List of employees | MATCH employees where joining_date in range |
| "Who are all the associate engineers in Tech?" | List | MATCH by role + department |

#### Category B — Hierarchy & Reporting
| Question | Answer Pattern | Cypher Intent |
|---|---|---|
| "Who does Shubham report to?" | Manager name + type (line/project) | MATCH REPORTS_TO edge |
| "Who are Anita's direct reports?" | List of employees | MATCH inbound REPORTS_TO |
| "What is the full reporting chain above Rohan?" | Chain of names up to CEO | MATCH path via REPORTS_TO* |
| "Who is the head of the Delivery department?" | Name | MATCH Delivery Head role |
| "How many levels are between an Associate and the CEO?" | Numeric answer | Shortest path length |

#### Category C — Project Intelligence
| Question | Answer Pattern | Cypher Intent |
|---|---|---|
| "Which projects is Shubham currently working on?" | Project names | MATCH ASSIGNED_TO where is_current=true |
| "Who all worked on Project Nexus?" | List of employees + their roles | MATCH ASSIGNED_TO for project |
| "What was Anita's role in the GenAI Platform project?" | Role in project | MATCH ASSIGNED_TO edge property |
| "Show me all completed projects in Tech department" | List | MATCH project status=Completed + dept |
| "Which projects use Python and Neo4j?" | List | MATCH project tech_stack contains |
| "Who is the PM of the largest active project?" | Name | MATCH MANAGES_PROJECT for active projects |

#### Category D — Skills & Expertise
| Question | Answer Pattern | Cypher Intent |
|---|---|---|
| "Find all backend experts in the company" | List of employees | MATCH HAS_SKILL where skill=backend related |
| "Who has Neo4j expertise?" | List | MATCH HAS_SKILL skill.name=Neo4j |
| "What skills does Rohan have?" | Skill list with proficiency | MATCH HAS_SKILL from employee |
| "Find someone with React + Node.js experience for a new project" | Candidate list | MATCH multiple HAS_SKILL |
| "Who has AWS certification?" | List | MATCH HAS_CERTIFICATION |

#### Category E — Department Analytics
| Question | Answer Pattern | Cypher Intent |
|---|---|---|
| "How many people are in the Tech department?" | Count | MATCH BELONGS_TO dept=Tech |
| "What is the average experience in Marketing?" | Number | AVG total_experience_years |
| "Which department has the most employees?" | Dept name + count | COUNT grouped by dept |
| "List all employees in HR" | List | MATCH BELONGS_TO dept=HR |
| "Who are all the managers across all departments?" | List | MATCH role level=3 |

#### Category F — Historical & Timeline
| Question | Answer Pattern | Cypher Intent |
|---|---|---|
| "When was Shubham promoted?" | Date + from/to role | MATCH PROMOTED_TO history |
| "What was Anita's previous role?" | Role name | MATCH HAS_ROLE is_current=false |
| "Show project timeline for Project Nexus" | Start/end dates, milestones | MATCH project + ASSIGNED_TO dates |
| "Which employees have been here for more than 3 years?" | List | MATCH org_experience_years > 3 |
| "Who has changed departments in the last year?" | List | MATCH BELONGS_TO since in range |

### 6.2 Total Identified Chatbot Use Cases: **30+**
Grouped: Employee Search (6), Hierarchy (5), Projects (6), Skills (5), Analytics (4), History (4), Cross-domain (5+)

---

## 7. Scale Expectations

| Parameter | Value | Notes |
|---|---|---|
| **Employees (PoC)** | 150+ | Across 6 departments |
| **Departments** | 6 | HR, Sales, Marketing, Tech, Finance, Delivery |
| **Projects** | 7 (1 large flagship) | Mix of client and internal, GenAI-focused |
| **Hierarchy Levels** | 7 | C-Suite down to Associate |
| **Skills Nodes** | ~50 | Technical, soft, domain |
| **Graph Nodes (est.)** | ~500–700 | Employees + Departments + Projects + Skills + Certs |
| **Graph Edges (est.)** | ~2,000–3,000 | All relationship types |
| **Concurrent Chatbot Users** | 20–30 (PoC) | Scale to 150 post-PoC |
| **Query Volume** | ~200 queries/day (PoC) | |
| **Max Response Latency** | 600ms (P95) | Cypher + LLM combined |
| **Data Refresh Frequency** | Event-driven | On employee join/exit/promote/project change |

---

## 8. Knowledge Graph Schema (Neo4j)

```cypher
// =====================
// NODE CONSTRAINTS
// =====================

CREATE CONSTRAINT employee_id_unique IF NOT EXISTS
FOR (e:Employee) REQUIRE e.employee_id IS UNIQUE;

CREATE CONSTRAINT dept_id_unique IF NOT EXISTS
FOR (d:Department) REQUIRE d.dept_id IS UNIQUE;

CREATE CONSTRAINT role_id_unique IF NOT EXISTS
FOR (r:Role) REQUIRE r.role_id IS UNIQUE;

CREATE CONSTRAINT project_id_unique IF NOT EXISTS
FOR (p:Project) REQUIRE p.project_id IS UNIQUE;

CREATE CONSTRAINT skill_id_unique IF NOT EXISTS
FOR (s:Skill) REQUIRE s.skill_id IS UNIQUE;

CREATE CONSTRAINT client_id_unique IF NOT EXISTS
FOR (c:Client) REQUIRE c.client_id IS UNIQUE;

// =====================
// INDEX FOR PERFORMANCE
// =====================

CREATE INDEX employee_name_index IF NOT EXISTS FOR (e:Employee) ON (e.full_name);
CREATE INDEX employee_dept_index IF NOT EXISTS FOR (e:Employee) ON (e.dept_id);
CREATE INDEX project_status_index IF NOT EXISTS FOR (p:Project) ON (p.status);
CREATE INDEX skill_name_index IF NOT EXISTS FOR (s:Skill) ON (s.name);
```

---

## 9. Dummy Data Specification

### 9.1 Departments (6)
```
1. HR
2. Sales
3. Marketing
4. Tech
5. Finance
6. Delivery
```

### 9.2 Projects (7 — GenAI & Enterprise focus)

| # | Project Name | Type | Status | Team Size | Tech Stack |
|---|---|---|---|---|---|
| 1 | **NeuraVault** (Flagship) | Client | Active | 35 members | Python, LangChain, Neo4j, FastAPI, React, AWS |
| 2 | **SentinelAI** | Client | Active | 12 members | Python, OpenAI, Pinecone, Node.js |
| 3 | **OrgPulse** (this project) | Internal | Active | 8 members | Neo4j, LangChain, React, FastAPI |
| 4 | **DataBridge** | Client | Completed | 10 members | Spark, Airflow, dbt, Snowflake |
| 5 | **MarketLens** | Client | Completed | 6 members | Python, Tableau, FastAPI |
| 6 | **TalentFlow** | Internal | On-hold | 4 members | React, Node.js, PostgreSQL |
| 7 | **CipherSec** | Client | Active | 9 members | Python, Docker, Kubernetes, AWS |

### 9.3 Sample Employee — Shubham Chougale (as specified)
```json
{
  "employee_id": "EMP-001",
  "full_name": "Shubham Chougale",
  "email": "shubham.morya@company.com",
  "phone": "+91-9876543210",
  "dob": "1997-06-15",
  "gender": "Male",
  "address": "Pune, Maharashtra",
  "employment_type": "Full-time",
  "joining_date": "2024-12-31",
  "total_experience_years": 4.5,
  "org_experience_years": 1.5,
  "current_status": "Active",
  "department": "Tech",
  "current_role": "Software Engineer",
  "skills": ["Python", "Neo4j", "LangChain", "FastAPI", "React"],
  "current_projects": ["OrgPulse"],
  "past_projects": ["SentinelAI"],
  "previous_companies": [
    {
      "company": "Infosys",
      "role": "Associate Software Engineer",
      "from": "2020-07-01",
      "to": "2022-12-31"
    },
    {
      "company": "Wipro",
      "role": "Software Engineer",
      "from": "2023-01-01",
      "to": "2024-12-15"
    }
  ]
}
```

### 9.4 Department Headcount Distribution (150+ Employees)

| Department | Count | C-Suite | Head | Manager | Senior IC | IC | Associate |
|---|---|---|---|---|---|---|---|
| Tech | 60 | 1 (CTO) | 2 | 6 | 15 | 20 | 16 |
| Delivery | 35 | 0 | 2 | 5 | 10 | 12 | 6 |
| Sales | 20 | 0 | 1 | 4 | 0 | 10 | 5 |
| Marketing | 15 | 0 | 1 | 3 | 0 | 8 | 3 |
| HR | 10 | 1 (CHO) | 1 | 2 | 0 | 4 | 2 |
| Finance | 12 | 1 (CFO) | 1 | 2 | 0 | 5 | 3 |
| **C-Suite** | 3 | CEO, CTO, CFO | | | | | |
| **Total** | **155** | | | | | | |

---

## 10. Cypher Query Templates

### Q1: Get full profile of an employee
```cypher
MATCH (e:Employee {full_name: "Shubham Chougale"})
OPTIONAL MATCH (e)-[:BELONGS_TO]->(d:Department)
OPTIONAL MATCH (e)-[:HAS_ROLE {is_current: true}]->(r:Role)
OPTIONAL MATCH (e)-[:REPORTS_TO]->(m:Employee)
OPTIONAL MATCH (e)-[:ASSIGNED_TO {is_current: true}]->(p:Project)
RETURN e, d.name AS department, r.title AS role, m.full_name AS manager, collect(p.name) AS current_projects
```

### Q2: Who reports to a given manager?
```cypher
MATCH (mgr:Employee {full_name: "Anita Sharma"})<-[:REPORTS_TO]-(report:Employee)
OPTIONAL MATCH (report)-[:HAS_ROLE {is_current: true}]->(r:Role)
RETURN report.full_name AS name, r.title AS role
ORDER BY r.level
```

### Q3: Full reporting chain (bottom to top)
```cypher
MATCH path = (e:Employee {full_name: "Shubham Chougale"})-[:REPORTS_TO*]->(top:Employee)
WHERE NOT (top)-[:REPORTS_TO]->()
RETURN [n IN nodes(path) | n.full_name] AS chain
```

### Q4: Find employees with specific skills
```cypher
MATCH (e:Employee)-[hs:HAS_SKILL]->(s:Skill)
WHERE s.name IN ["Neo4j", "Python"]
WITH e, collect(s.name) AS skills, collect(hs.proficiency) AS levels
WHERE size(skills) = 2
RETURN e.full_name AS name, skills, levels
```

### Q5: All employees on a project with their roles
```cypher
MATCH (e:Employee)-[a:ASSIGNED_TO]->(p:Project {name: "NeuraVault"})
OPTIONAL MATCH (e)-[:HAS_ROLE {is_current: true}]->(r:Role)
RETURN e.full_name AS employee, r.title AS designation, a.role_in_project AS project_role,
       a.start_date AS joined_project, a.end_date AS left_project, a.is_current AS currently_active
ORDER BY a.is_current DESC
```

### Q6: Department headcount analytics
```cypher
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
WHERE e.current_status = "Active"
RETURN d.name AS department, count(e) AS headcount
ORDER BY headcount DESC
```

### Q7: Find the PM of a project
```cypher
MATCH (e:Employee)-[:MANAGES_PROJECT]->(p:Project {name: "NeuraVault"})
RETURN e.full_name AS project_manager, e.email AS email
```

### Q8: Employee promotion history
```cypher
MATCH (e:Employee {full_name: "Shubham Chougale"})-[:PROMOTED_TO]->(h:PromotionHistory)
RETURN h.from_role AS promoted_from, h.to_role AS promoted_to, h.effective_date AS on_date
ORDER BY h.effective_date
```

### Q9: Projects by tech stack
```cypher
MATCH (p:Project)
WHERE "Neo4j" IN p.tech_stack AND "Python" IN p.tech_stack
RETURN p.name AS project, p.status AS status, p.tech_stack AS stack
```

### Q10: Employees with > N years org experience
```cypher
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
WHERE e.org_experience_years > 2 AND e.current_status = "Active"
RETURN e.full_name AS name, d.name AS dept, e.org_experience_years AS org_exp
ORDER BY e.org_experience_years DESC
```

---

## 11. Tech Stack Recommendation

### Graph Database
- **Neo4j** (Community or AuraDB Free for PoC)

### Backend / API
- **FastAPI** (Python) — REST + WebSocket for chatbot
- **LangChain** — LLM orchestration, Cypher generation
- **Claude Sonnet / GPT-4o** — NL → Cypher translation

### NL → Cypher Pipeline
```
User Question
     ↓
Intent Classification (LLM)
     ↓
Cypher Query Generation (LangChain + Neo4j GraphCypherQAChain)
     ↓
Query Execution (Neo4j)
     ↓
Result Formatting (LLM)
     ↓
Answer to User
```

### Frontend
- **React + TailwindCSS** — Chat interface + org chart viewer
- **React Flow / D3.js** — Interactive knowledge graph visualization

### Embedding / Semantic Search (Phase 2)
- **sentence-transformers** for employee/project descriptions
- **Pinecone / Weaviate** for vector similarity search

### Infrastructure
- **Docker Compose** — Local PoC setup
- **AWS EC2 / ECS** — Production deployment

---

## 12. Implementation Roadmap

### Phase 1 — Foundation (Week 1–2)
- [ ] Finalize ontology and Neo4j schema
- [ ] Generate 155 dummy employee records
- [ ] Create 7 project records with assignments
- [ ] Load graph via Cypher seed scripts
- [ ] Validate all relationships and constraints

### Phase 2 — Chatbot Core (Week 3–4)
- [ ] Set up FastAPI backend
- [ ] Integrate LangChain with Neo4j
- [ ] Build NL → Cypher pipeline
- [ ] Test 30 chatbot use cases
- [ ] Implement RBAC in API layer

### Phase 3 — Frontend (Week 5–6)
- [ ] Chat interface (React)
- [ ] Org chart visualization
- [ ] Employee search with filters
- [ ] Admin panel for data management

### Phase 4 — Hardening & Demo (Week 7–8)
- [ ] Performance testing (< 600ms)
- [ ] Security audit (PII masking)
- [ ] Semantic search integration
- [ ] Demo preparation + documentation

---

## Open Questions for Next Session

1. Should we define a **data ingestion API** so HR can add/update employees through a form (vs. direct DB edits)?
2. Do we need **multilingual** support in the chatbot?
3. Should employee photos be stored, or is a directory link sufficient?
4. Is there a preferred **LLM provider** (OpenAI, Anthropic, or self-hosted)?
5. Will the chatbot be a **standalone web app** or embedded in an existing HR tool?

---

*Document prepared based on project description and Q&A session. Version 1.0 — subject to revision.*
