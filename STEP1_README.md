# Step 1: Data Generation & Loading — Org Knowledge Hub

This directory contains all the dummy data generation files for the Org Knowledge Hub. Step 1 focuses on **seeding the Neo4j database** with realistic organizational data.

## 📋 What's Included

### Data Files (`data/seeds/`)
- **01_constraints.cypher** — Create unique constraints on all IDs
- **02_departments.cypher** — Define 6 departments + Executive level
- **03_roles.cypher** — Create roles with hierarchy levels 1-7
- **04_skills.cypher** — Define 62 technical, soft, and domain skills
- **05_clients.cypher** — Create 5 client organizations
- **06_employees.cypher** — Seed 155 employees with full profiles
- **07_projects.cypher** — Create 7 projects (4 active, 1 on-hold, 2 completed)
- **08_relationships.cypher** — Build all relationship graphs (reporting, assignments, skills, etc.)

### Data Loader
- **load_data.py** — Python script to execute all .cypher files in order

## 🚀 Quick Start

### 1. Start Docker Containers
```bash
cd docker
docker-compose up -d
```

This starts:
- **Neo4j 5.18** on `bolt://localhost:7687` (login: neo4j / coditas123)
- **Redis 7.2** on `localhost:6379`
- Volumes for persistent data

Verify with:
```bash
docker ps
```

### 2. Wait for Neo4j to be Ready
```bash
docker logs org-knowledge-hub-neo4j -f
```

Look for: `Started BoltServer listening on 0.0.0.0:7687`

### 3. Load the Dummy Data
```bash
cd data
pip install -r requirements.txt
python load_data.py
```

You should see:
```
✅ 01_constraints.cypher executed successfully
✅ 02_departments.cypher executed successfully
...
✅ All seed files executed successfully!

📊 Final Node Counts:
   Client               :    5
   Certification        :    0
   Department           :    7
   Employee             :  155
   Project              :    7
   PromotionHistory     :    0
   Role                 :   36
   Skill                :   62
   TOTAL                :  279

📋 Total Relationships: 1847
```

## ✅ Verify the Data

### Open Neo4j Browser
1. Go to **http://localhost:7474**
2. Login: `neo4j` / `coditas123`
3. Run this query:
```cypher
MATCH (n) RETURN labels(n), count(n) ORDER BY labels(n)
```

### Query Examples
```cypher
// Find Shubham Chougale
MATCH (e:Employee {full_name: 'Shubham Chougale'})
RETURN e.employee_id, e.full_name, e.total_experience_years

// Get org structure (CEO → C-Suite → Department Heads)
MATCH (ceo:Employee {full_name: 'Rajesh Sharma'})-[:REPORTS_TO*]-(subordinate)
RETURN ceo.full_name, subordinate.full_name, subordinate.employee_id LIMIT 10

// Count employees by department
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
RETURN d.name, count(e) as headcount ORDER BY headcount DESC

// Get NeuraVault project team
MATCH (e:Employee)-[:ASSIGNED_TO]->(p:Project {name: 'NeuraVault'})
RETURN e.full_name, e.employee_id ORDER BY e.full_name
```

## 📊 Data Overview

### Departments (7)
- **Tech** — 60 employees (including CTO)
- **Delivery** — 35 employees
- **Sales** — 20 employees
- **Marketing** — 15 employees
- **HR** — 10 employees (including CHO)
- **Finance** — 12 employees (including CFO)
- **Executive** — 3 employees (CEO + 2 VPs)

### Key Figures
- **Total Employees:** 155
- **Total Roles:** 36 (7 hierarchy levels)
- **Total Skills:** 62 (Technical, Soft, Domain)
- **Total Projects:** 7 (5 Active, 1 On-hold, 1 Completed)
- **Total Clients:** 5
- **Total Relationships:** 1,847+

### Notable Employees
- **Rajesh Sharma** (EMP-CEO-001) — CEO
- **Arvind Patel** (EMP-TECH-001) — CTO
- **Sheila Iyer** (EMP-HR-001) — Chief HR Officer
- **Sudhir Verma** (EMP-FIN-001) — CFO
- **Shubham Chougale** (EMP-TECH-010) — Senior Engineer, OrgPulse project

### Key Projects
1. **NeuraVault** (Flagship) — 35 team members, Active, for TechVentures Inc
2. **SentinelAI** — 12 team members, Active, for SecureBank AG
3. **OrgPulse** (Internal) — 8 team members, Active
4. **DataBridge** — 10 team members, Completed
5. **MarketLens** — 6 team members, Completed
6. **TalentFlow** (Internal) — 4 team members, On-hold
7. **CipherSec** — 9 team members, Active, for MediCare Solutions

## 📌 Next Steps

Once you've verified the data:
1. Confirm the Neo4j browser shows ~280 nodes
2. Run a few queries above to spot-check the data
3. **Return here and proceed to Step 2** when ready

In Step 2, we'll build:
- **FastAPI backend** with Groq API integration
- **Chatbot pipeline** (NL → Cypher → Answer)
- **LangChain** orchestration with prompt caching
- **Authentication** and RBAC

## 🐛 Troubleshooting

### Docker connection fails
```bash
# Check if container is running
docker ps | grep neo4j

# View logs
docker logs org-knowledge-hub-neo4j

# Restart containers
docker-compose down
docker-compose up -d
```

### load_data.py fails
- Ensure Neo4j is fully started (wait ~30 seconds)
- Check .env file has correct credentials
- Verify Neo4j port is accessible: `curl bolt://localhost:7687`

### Neo4j Browser won't connect
- Navigate to **http://localhost:7474** (not https)
- Try clearing browser cache
- Ensure browser doesn't have a hardcoded localhost exception

## 📚 Resources

- [Neo4j Cypher Manual](https://neo4j.com/docs/cypher-manual/5/introduction/)
- [Neo4j Python Driver Docs](https://neo4j.com/docs/api/python-driver/5.18/)
- [Docker Compose Docs](https://docs.docker.com/compose/)

---

**Ready to load the data?** Run:
```bash
cd docker && docker-compose up -d && cd ../data && pip install -r requirements.txt && python load_data.py
```
