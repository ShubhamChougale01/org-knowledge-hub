# Knowledge Graph Guide
## Org Knowledge Hub - Data Layer Documentation

This document explains the **data folder structure**, the **knowledge graph schema**, node/relationship counts, and how the `load_data.py` script populates Neo4j with seed data.

---

## Table of Contents

1. [Folder Structure](#folder-structure)
2. [Knowledge Graph Overview](#knowledge-graph-overview)
3. [Node Types & Counts](#node-types--counts)
4. [Relationship Types & Connections](#relationship-types--connections)
5. [Seed Files Explained](#seed-files-explained)
6. [How load_data.py Works](#how-load_databy-works)
7. [Data Quality & Cleaning](#data-quality--cleaning)
8. [Maintenance & Updates](#maintenance--updates)

---

## Folder Structure

```
data/
├── seeds/                          # 11 Cypher files defining the knowledge graph
│   ├── 01_constraints.cypher       # Unique constraints on all node types
│   ├── 02_departments.cypher       # 7 Department nodes
│   ├── 03_roles.cypher             # 36 Role definitions across 7 departments
│   ├── 04_skills.cypher            # 62 Skill nodes (technical, soft, domain)
│   ├── 05_clients.cypher           # 5 Client nodes
│   ├── 06_employees.cypher         # 155 Employee nodes with full profiles
│   ├── 07_projects.cypher          # 7 Project nodes
│   ├── 08_relationships.cypher     # 1,820+ relationships connecting all nodes
│   ├── 09_certifications.cypher    # Employee certification data
│   ├── 10_promotions.cypher        # Promotion history
│   └── 11_admin_users.cypher       # Admin user accounts for login
│
├── load_data.py                    # Main Python script to execute all seed files
├── requirements.txt                # Python dependencies (neo4j, python-dotenv)
├── .env                           # Local Neo4j credentials (not committed)
└── KNOWLEDGE_GRAPH_GUIDE.md        # This file

```

---

## Knowledge Graph Overview

The knowledge graph represents **Coditas, an IT consulting company** with:
- **155 employees** distributed across 7 departments
- **36 job roles** organized in a 7-level hierarchy
- **62 skills** (technical, soft, domain-based)
- **7 active projects** linked to 5 clients
- **Organizational relationships** (reporting lines, role assignments, project assignments)

### Quick Stats

| Metric | Count | Details |
|--------|-------|---------|
| **Nodes** | ~279 | 155 employees, 7 depts, 36 roles, 62 skills, 7 projects, 5 clients, 7 certifications |
| **Relationships** | ~1,847 | BELONGS_TO, HAS_ROLE, REPORTS_TO, ASSIGNED_TO, HAS_SKILL, HAS_CERTIFICATION, etc. |
| **Execution Time** | <2 seconds | All 11 seed files load and execute sequentially |

---

## Node Types & Counts

### 1. **Employee** (155 nodes)
**Purpose:** Represents every person in the organization

**Properties:**
```
{
  employee_id: String (unique key),    // "EMP-TECH-001", "EMP-CEO-001", etc.
  full_name: String,
  email: String,
  phone: String,                        // PII: masked for non-admin users
  dob: Date,                            // PII: masked for non-admin users
  address: String,                      // PII: masked for non-admin users
  gender: String,
  employment_type: String,              // "Full-time", "Contract", etc.
  joining_date: Date,
  total_experience_years: Float,
  org_experience_years: Float,
  current_status: String,               // "Active", "On Leave", "Inactive"
  profile_photo_url: String (nullable),
  created_at: DateTime
}
```

**Distribution by Department:**
- Tech: 60 employees
- Delivery: 35 employees
- Sales: 20 employees
- Marketing: 15 employees
- HR: 10 employees
- Finance: 12 employees
- Executive: 3 employees (CEO, CFO, CHO, CTO, Chief)

**Example:** Shubham Chougale (EMP-TECH-010) — Senior Engineer in Tech department

---

### 2. **Department** (7 nodes)
**Purpose:** Organizational divisions

**Properties:**
```
{
  dept_id: String (unique key),        // "DEPT-001" through "DEPT-007"
  name: String,
  headcount: Integer,                  // Employee count in department
  description: String,
  created_at: DateTime
}
```

**All Departments:**
1. Tech (60 employees) — Engineering and Technology
2. Delivery (35) — Project Delivery and Operations
3. Sales (20) — Sales and Business Development
4. Marketing (15) — Marketing and Communications
5. HR (10) — Human Resources
6. Finance (12) — Finance and Accounting
7. Executive (3) — C-Suite and Executive Leadership

---

### 3. **Role** (36 nodes)
**Purpose:** Job titles with hierarchical levels (1–7, where 1 = C-Suite, 7 = Entry level)

**Properties:**
```
{
  role_id: String (unique key),        // "ROLE-TECH-001", "ROLE-DEL-005", etc.
  title: String,
  level: Integer,                      // 1-7: strategic (1) to entry (7)
  department: String,
  created_at: DateTime
}
```

**Role Hierarchy by Level:**
- **Level 7 (C-Suite):** CEO, CFO, CTO, CHO, Chief roles (1 per area)
- **Level 6 (Head):** CTO, Tech Head, Delivery Head, Sales Head, Marketing Head, HR Head, Finance Head
- **Level 5 (Manager/Lead):** Engineering Manager, Tech Lead, Product Manager, Project Manager, HR Manager, Finance Manager
- **Level 4 (Senior Individual Contributors):** Senior Engineer, Senior Project Analyst, Account Executive, Marketing Executive, HR Executive, Financial Analyst
- **Level 3 (Mid-Level IC):** Engineer, Project Analyst, Marketing Executive, Financial Analyst
- **Level 2 (Associate/Junior):** Associate Engineer, Associate Analyst, Sales Associate, Marketing Associate, HR Associate, Finance Associate
- **Note:** Some levels may not exist in every department (e.g., Sales has no Level 3)

**Total: 36 roles** distributed across 7 departments

---

### 4. **Skill** (62 nodes)
**Purpose:** Technical, soft, and domain competencies

**Properties:**
```
{
  skill_id: String (unique key),       // "SKILL-TECH-001", "SKILL-SOFT-001", etc.
  name: String,
  category: String,                    // "Technical", "Soft", "Domain"
  description: String (nullable),
  created_at: DateTime
}
```

**Categories:**
- **Technical Skills (30+):** Python, JavaScript, React, Node.js, Neo4j, SQL, MongoDB, Docker, Kubernetes, AWS, GCP, Java, Go, etc.
- **Soft Skills (15+):** Leadership, Communication, Problem-Solving, Teamwork, Time Management, Project Management, Strategic Thinking, Mentoring, etc.
- **Domain Skills (15+):** FinTech, Healthcare, E-Commerce, SaaS, Cybersecurity, Data Analytics, Machine Learning, etc.

---

### 5. **Project** (7 nodes)
**Purpose:** Active projects in the organization

**Properties:**
```
{
  project_id: String (unique key),     // "PROJ-001" through "PROJ-007"
  name: String,
  description: String,
  status: String,                      // "Active", "Completed", "On Hold"
  start_date: Date,
  end_date: Date (nullable),
  budget: Float (nullable),
  created_at: DateTime
}
```

**All Projects:**
1. **NeuraVault** — AI-powered data vault for financial institutions
2. **SentinelAI** — Real-time cybersecurity threat monitoring
3. **OrgPulse** — Internal employee engagement analytics platform
4. **DataBridge** — Data integration and ETL service
5. **MarketLens** — Market intelligence and competitive analysis
6. **TalentFlow** — HR analytics and recruitment optimization
7. **CipherSec** — Encryption and security compliance toolkit

---

### 6. **Client** (5 nodes)
**Purpose:** External companies that use our projects

**Properties:**
```
{
  client_id: String (unique key),      // "CLIENT-001" through "CLIENT-005"
  name: String,
  industry: String,                    // "Finance", "Healthcare", "Retail", etc.
  country: String,
  contact_person: String,
  contact_email: String,
  contact_phone: String,
  created_at: DateTime
}
```

**All Clients:**
1. **TechVentures Inc** — Tech startups and innovation hubs
2. **SecureBank AG** — European banking and financial services
3. **RetailGlobal Ltd** — Multinational retail chain
4. **MediCare Solutions** — Healthcare and medical technology
5. **DataInsights Corp** — Data analytics and business intelligence

---

### 7. **Certification** (7+ nodes)
**Purpose:** Professional certifications held by employees

**Properties:**
```
{
  cert_id: String (unique key),
  name: String,
  issuing_body: String,
  description: String,
  created_at: DateTime
}
```

**Examples:** AWS Certified Solutions Architect, GCP Professional Data Engineer, PMP, Kubernetes Administrator, Certified Ethical Hacker, etc.

---

### 8. **PromotionHistory** (varies)
**Purpose:** Track employee role transitions over time

**Properties:**
```
{
  history_id: String (unique key),
  employee_id: String,
  old_role: String,
  new_role: String,
  promotion_date: Date,
  created_at: DateTime
}
```

---

## Relationship Types & Connections

### 1. **BELONGS_TO** (155 total)
**From:** Employee → **To:** Department
**Purpose:** Assigns employees to departments

**Properties:**
```
{
  since: Date        // When the employee joined the department
}
```

**Example:** Shubham Chougale → Tech Department (since 2024-12-31)

---

### 2. **HAS_ROLE** (155 total)
**From:** Employee → **To:** Role
**Purpose:** Assigns current and past roles to employees

**Properties:**
```
{
  since: Date,       // When the role was assigned
  is_current: Boolean // true if still in this role
}
```

**Example:** Rajesh Sharma (CEO) → CEO role (since 2010-01-15, is_current: true)

---

### 3. **REPORTS_TO** (variable)
**From:** Employee → **To:** Employee
**Purpose:** Defines reporting hierarchy (who reports to whom)

**Properties:**
```
{
  type: String,      // "line" (direct), "matrix" (cross-functional), "project" (temporary)
  since: Date
}
```

**Example:**
- Arvind Patel (CTO) → Rajesh Sharma (CEO)
- Shubham Chougale (Senior Engineer) → Arvind Patel (CTO)

---

### 4. **ASSIGNED_TO** (variable)
**From:** Employee → **To:** Project
**Purpose:** Links employees to projects they work on

**Properties:**
```
{
  role_in_project: String,  // "Developer", "Team Lead", "Architect", etc.
  is_current: Boolean,      // true if actively assigned
  assignment_date: Date
}
```

**Example:** Shubham Chougale → NeuraVault (role_in_project: "Senior Engineer", is_current: true)

---

### 5. **HAS_SKILL** (600+)
**From:** Employee → **To:** Skill
**Purpose:** Associates employees with skills they possess

**Properties:**
```
{
  proficiency: String,  // "Beginner", "Intermediate", "Expert"
  years_of_experience: Float (nullable)
}
```

**Example:** Shubham Chougale → Python (proficiency: "Expert")

---

### 6. **HAS_CERTIFICATION** (50+)
**From:** Employee → **To:** Certification
**Purpose:** Records professional certifications

**Properties:**
```
{
  issued_date: Date,
  expiry_date: Date (nullable),
  certification_number: String (nullable)
}
```

**Example:** Arvind Patel → AWS Certified Solutions Architect (issued: 2018-06-15)

---

### 7. **FOR_CLIENT** (7)
**From:** Project → **To:** Client
**Purpose:** Links projects to their clients

**Properties:**
```
{
  contract_value: Float (nullable),
  start_date: Date (nullable),
  end_date: Date (nullable)
}
```

**Example:** NeuraVault → SecureBank AG

---

### 8. **MANAGES_PROJECT** (variable)
**From:** Employee → **To:** Project
**Purpose:** Designates project managers/owners

**Properties:**
```
{
  role_in_project: String,  // "Project Manager", "Product Owner", "Tech Lead"
  since: Date
}
```

**Example:** Ananya Gupta (Product Manager) → NeuraVault (since 2024-01-15)

---

### 9. **PROMOTED_TO** (variable)
**From:** Employee → **To:** Role
**Purpose:** Historical record of promotions

**Properties:**
```
{
  promotion_date: Date,
  previous_role: String (nullable)
}
```

---

## Seed Files Explained

Each Cypher file builds the graph incrementally. They **must run in order** because later files depend on nodes created earlier.

### **01_constraints.cypher** (10 lines)
**What it does:** Creates unique constraints on IDs to ensure idempotency

```cypher
CREATE CONSTRAINT IF NOT EXISTS FOR (e:Employee) REQUIRE e.employee_id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (d:Department) REQUIRE d.dept_id IS UNIQUE;
// ... (one for each node type)
```

**Why it matters:**
- Prevents duplicate nodes if the script runs twice
- Allows safe MERGE operations (MERGE creates OR returns existing)
- Database will reject duplicate IDs automatically

**Important:** These constraints are **idempotent** — running them again won't cause errors.

---

### **02_departments.cypher** (9 lines)
**What it does:** Creates 7 Department nodes

```cypher
MERGE (d1:Department {dept_id: 'DEPT-001', name: 'Tech', headcount: 60, ...})
SET d1.created_at = datetime();
```

**Pattern:**
- Uses `MERGE` (not CREATE) to ensure idempotency
- Sets `dept_id` first (the unique key)
- Then uses `SET` to add all other properties
- Adds `created_at` timestamp for auditing

**Output:** 7 Department nodes ready for relationships

---

### **03_roles.cypher** (48 lines)
**What it does:** Creates 36 Role nodes across all departments

```cypher
// Tech Department Roles
MERGE (r:Role {role_id: 'ROLE-TECH-001', title: 'CTO', level: 7, department: 'Tech'})
SET r.created_at = datetime();

// ... (1 line per role)
```

**Hierarchy Structure:**
- Each role has a unique `role_id` and a `level` (1–7)
- `level: 7` = CEO (executive), `level: 2` = associate/junior
- Roles are pre-created before employees are assigned to them

**Output:** 36 Role nodes ready for HAS_ROLE relationships

---

### **04_skills.cypher** (62 lines)
**What it does:** Creates 62 Skill nodes across three categories

```cypher
// Technical Skills
MERGE (s:Skill {skill_id: 'SKILL-TECH-001', name: 'Python', category: 'Technical'})
SET s.created_at = datetime();

// Soft Skills
MERGE (s:Skill {skill_id: 'SKILL-SOFT-001', name: 'Leadership', category: 'Soft'})
...

// Domain Skills
MERGE (s:Skill {skill_id: 'SKILL-DOMAIN-001', name: 'FinTech', category: 'Domain'})
```

**Output:** 62 Skill nodes ready for HAS_SKILL relationships

---

### **05_clients.cypher** (5 lines)
**What it does:** Creates 5 Client nodes

```cypher
MERGE (c:Client {client_id: 'CLIENT-001', name: 'TechVentures Inc', industry: 'Tech', ...})
SET c.created_at = datetime();
```

**Output:** 5 Client nodes ready for FOR_CLIENT relationships

---

### **06_employees.cypher** (155 lines, ~500+ lines with formatting)
**What it does:** Creates all 155 Employee nodes with full profiles

```cypher
// CEO
MERGE (e:Employee {employee_id: 'EMP-CEO-001'})
SET e.full_name = 'Rajesh Sharma',
    e.email = 'rajesh.sharma@coditas.com',
    e.phone = '+91-9876543210',
    e.dob = date('1968-03-15'),
    ... (all properties)
    e.created_at = datetime();

// Tech Department (60 employees)
MERGE (e:Employee {employee_id: 'EMP-TECH-001'})
...

// Delivery Department (35)
// Sales Department (20)
// Marketing (15)
// HR (10)
// Finance (12)
```

**Critical Pattern:**
```cypher
MERGE (e:Employee {employee_id: 'EMP-TECH-010'})  // UNIQUE KEY ONLY in MERGE
SET e.full_name = '...',                           // ALL OTHER props in SET
    e.email = '...',
    ...
```

**Why this matters:**
- MERGE cannot have NULL values in the match clause
- All nullable properties (like `profile_photo_url`) are set with SET
- This prevents "MERGE failed: cannot match on null" errors

**Output:** 155 Employee nodes with complete profiles ready for relationships

---

### **07_projects.cypher** (7 lines)
**What it does:** Creates 7 Project nodes

```cypher
MERGE (p:Project {project_id: 'PROJ-001', name: 'NeuraVault', ...})
SET p.created_at = datetime();
```

**Output:** 7 Project nodes ready for relationships

---

### **08_relationships.cypher** (300+ lines)
**What it does:** Creates 1,820+ relationships connecting all nodes

This is the **heaviest file** with multiple relationship types:

#### **BELONGS_TO Relationships (155)**
```cypher
// Explicit for leadership (batch all others)
MATCH (e:Employee {employee_id: 'EMP-TECH-001'}), (d:Department {dept_id: 'DEPT-001'})
MERGE (e)-[:BELONGS_TO {since: date('2012-06-01')}]->(d);

// Batch assignment by prefix
MATCH (e:Employee), (d:Department {dept_id: 'DEPT-001'})
WHERE e.employee_id STARTS WITH 'EMP-TECH-'
MERGE (e)-[r:BELONGS_TO]->(d)
ON CREATE SET r.since = e.joining_date;
```

**Pattern:** 
- Leadership roles get explicit assignments (ensure accuracy)
- Junior staff batched by ID prefix (efficiency)
- Uses `ON CREATE SET` to auto-populate `since` from `e.joining_date`

#### **HAS_ROLE Relationships (155)**
```cypher
// CEO
MATCH (e:Employee {employee_id: 'EMP-CEO-001'}), (r:Role {role_id: 'ROLE-EXE-001'})
MERGE (e)-[:HAS_ROLE {since: date('2010-01-15'), is_current: true}]->(r);

// Batch by range
MATCH (e:Employee), (r:Role {role_id: 'ROLE-TECH-007'})
WHERE e.employee_id >= 'EMP-TECH-010' AND e.employee_id <= 'EMP-TECH-024'
MERGE (e)-[rel:HAS_ROLE]->(r)
ON CREATE SET rel.since = e.joining_date, rel.is_current = true;
```

#### **REPORTS_TO Relationships (50+)**
```cypher
// Explicit reporting lines for each manager
MATCH (e:Employee {employee_id: 'EMP-TECH-001'}), (m:Employee {employee_id: 'EMP-CEO-001'})
MERGE (e)-[:REPORTS_TO {type: 'line', since: date('2012-06-01')}]->(m);
```

#### **ASSIGNED_TO & HAS_SKILL Relationships (600+)**
```cypher
// Project assignments
MATCH (e:Employee {employee_id: 'EMP-TECH-001'}), (p:Project {project_id: 'PROJ-001'})
MERGE (e)-[:ASSIGNED_TO {role_in_project: 'Tech Lead', is_current: true}]->(p);

// Skills (batched by employee range and skill)
MATCH (e:Employee), (s:Skill {skill_id: 'SKILL-TECH-001'})
WHERE e.employee_id IN ['EMP-TECH-001', 'EMP-TECH-002', ...]
MERGE (e)-[r:HAS_SKILL]->(s)
ON CREATE SET r.proficiency = 'Expert';
```

#### **FOR_CLIENT Relationships (7)**
```cypher
// Link projects to clients
MATCH (p:Project {project_id: 'PROJ-001'}), (c:Client {client_id: 'CLIENT-001'})
MERGE (p)-[:FOR_CLIENT {contract_value: 1500000.0}]->(c);
```

**Total from this file:** ~1,820 relationships created

---

### **09_certifications.cypher** (50+ lines)
**What it does:** Creates Certification nodes and links employees to them

```cypher
MERGE (c:Certification {cert_id: 'CERT-AWS-001', name: 'AWS Certified Solutions Architect', ...})
SET c.created_at = datetime();

// Link employees
MATCH (e:Employee {employee_id: 'EMP-TECH-001'}), (c:Certification {cert_id: 'CERT-AWS-001'})
MERGE (e)-[:HAS_CERTIFICATION {issued_date: date('2018-06-15')}]->(c);
```

**Output:** Certification nodes and HAS_CERTIFICATION relationships (50+)

---

### **10_promotions.cypher** (30+ lines)
**What it does:** Records promotion history for employees

```cypher
// Create promotion history nodes
MERGE (ph:PromotionHistory {history_id: 'PROMO-001', ...})
SET ph.employee_id = 'EMP-TECH-010',
    ph.old_role = 'Associate Engineer',
    ph.new_role = 'Senior Engineer',
    ph.promotion_date = date('2023-06-01'),
    ph.created_at = datetime();

// Link to employee
MATCH (e:Employee {employee_id: 'EMP-TECH-010'}), (ph:PromotionHistory {history_id: 'PROMO-001'})
MERGE (e)-[:PROMOTED_TO]->(ph);
```

**Output:** Promotion history and PROMOTED_TO relationships

---

### **11_admin_users.cypher** (10+ lines)
**What it does:** Creates admin user records for login purposes

```cypher
// Create admin user for authentication
MERGE (u:AdminUser {admin_id: 'ADMIN-001', ...})
SET u.username = 'admin',
    u.email = 'admin@coditas.com',
    u.password_hash = '...',  // bcrypt hash
    u.created_at = datetime();
```

**Output:** Admin user nodes (typically 5–10 for system testing)

---

## How load_data.py Works

The `load_data.py` script is the **orchestrator** that runs all 11 seed files in order.

### **Step 1: Initialize**
```python
from pathlib import Path
from dotenv import load_dotenv
from neo4j import GraphDatabase

load_dotenv()  # Load .env file

NEO4J_URI = os.getenv('NEO4J_URI', 'bolt://localhost:7687')
NEO4J_USER = os.getenv('NEO4J_USER', 'neo4j')
NEO4J_PASSWORD = os.getenv('NEO4J_PASSWORD', 'coditas123')
```

**What happens:**
- Reads environment variables from `data/.env`
- Gets Neo4j connection details (URI, username, password)
- Sets up defaults if .env is missing

---

### **Step 2: Connect to Neo4j**
```python
def get_driver():
    try:
        driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
        driver.verify_connectivity()  # Test the connection
        return driver
    except Exception as e:
        print(f"❌ Failed to connect to Neo4j at {NEO4J_URI}")
        return None
```

**What happens:**
- Creates a Neo4j driver (connection pool)
- Tests connectivity with `verify_connectivity()`
- Exits with error if Neo4j is not running

**Failure Points:**
- Neo4j Docker container not started
- Wrong URI (e.g., localhost:7687 vs localhost:7474)
- Wrong credentials in .env

---

### **Step 3: Read Seed Files**
```python
def read_cypher_file(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        print(f"❌ Error reading {file_path}: {e}")
        return None
```

**What happens:**
- Opens each `.cypher` file
- Reads the entire content as a string
- Handles encoding properly (UTF-8 for special characters)

---

### **Step 4: Clean Cypher Code**
```python
def execute_cypher(driver, cypher_content, filename):
    try:
        with driver.session() as session:
            # ⭐ CRITICAL: Strip comments BEFORE splitting by semicolon
            clean_lines = [
                line for line in cypher_content.splitlines()
                if not line.strip().startswith('//')
            ]
            clean_content = '\n'.join(clean_lines)
            
            # Split by semicolon to get individual statements
            statements = [s.strip() for s in clean_content.split(';') if s.strip()]
```

**Data Cleaning Logic:**

**Problem:** Cypher comments can contain semicolons
```cypher
// This is a comment with ; inside it
MERGE (e:Employee {id: 'EMP-001'});
```

If you split by `;` first, the comment fragment becomes orphaned and fails.

**Solution:** Remove all comment lines (`//`) BEFORE splitting
```
1. Iterate line by line
2. Skip lines that start with //
3. Join remaining lines
4. THEN split by ; (now safe)
5. Execute each statement
```

**Result:** Clean, executable Cypher statements

---

### **Step 5: Execute Each Statement**
```python
for statement in statements:
    session.run(statement)  # Execute against Neo4j
```

**What happens:**
- Each Cypher statement runs individually
- MERGE creates nodes only if they don't exist
- Relationships are created/updated atomically
- Errors are caught and reported

**Transaction Handling:**
- Each `session.run()` is wrapped in its own transaction
- If one statement fails, the file logs the error but continues
- Partial data may be committed (Neo4j auto-commits on success)

---

### **Step 6: Error Handling**
```python
try:
    # ... execute cypher ...
    print(f"✅ {filename} executed successfully")
    return True
except Neo4jError as e:
    print(f"❌ {filename} failed with Neo4j error:")
    print(f"   {e}")
    failed_files.append(filename)
    return False
```

**Error Types Caught:**
- `Neo4jError` — Constraint violations, syntax errors, connection issues
- Generic `Exception` — File I/O errors, encoding issues

**Result:** Failed files are tracked and reported at the end

---

### **Step 7: Count Nodes**
```python
def get_node_counts(driver):
    with driver.session() as session:
        result = session.run("""
            MATCH (n)
            RETURN labels(n)[0] as label, count(n) as count
            ORDER BY label
        """)
        return {record['label']: record['count'] for record in result}
```

**What happens:**
- Runs a Cypher query to count all nodes by type
- Displays counts in a formatted table
- Verifies data was loaded successfully

**Sample Output:**
```
📊 Final Node Counts:
   Certification         :    7
   Client               :    5
   Department           :    7
   Employee             :  155
   Project              :    7
   Role                 :   36
   Skill                :   62
   PromotionHistory     :   15
   AdminUser            :    5
   ────────────────────────
   TOTAL                :  299
```

---

### **Step 8: Count Relationships**
```python
rel_result = session.run("MATCH ()-[r]->() RETURN count(r) as count")
rel_count = rel_result.single()['count']
print(f"\n📋 Total Relationships: {rel_count:,}\n")
```

**What happens:**
- Counts all relationships in the graph
- Reports the total at the end

**Sample Output:**
```
📋 Total Relationships: 1,847
```

---

### **Step 9: Report Results**
```python
if failed_files:
    print(f"❌ {len(failed_files)} file(s) failed:")
    for f in failed_files:
        print(f"   - {f}")
    sys.exit(1)  # Exit with error code
else:
    print("✨ Data loading complete! Ready to use your knowledge graph.\n")
    sys.exit(0)  # Exit successfully
```

---

## Data Quality & Cleaning

### **Idempotency (Safe to Run Multiple Times)**

All seed files use `MERGE` instead of `CREATE`:
```cypher
MERGE (e:Employee {employee_id: 'EMP-TECH-001'})  // Returns existing if found
SET e.full_name = 'Name', ...                      // Updates properties
```

**Benefit:** Running `load_data.py` twice doesn't create duplicates.

**Why Constraints Matter:**
```cypher
CREATE CONSTRAINT IF NOT EXISTS FOR (e:Employee) REQUIRE e.employee_id IS UNIQUE;
```

- If someone tries to `MERGE` with a duplicate ID manually, Neo4j rejects it
- Ensures data integrity automatically

---

### **Comment Stripping**

The script removes Cypher comments before parsing:
```python
clean_lines = [
    line for line in cypher_content.splitlines()
    if not line.strip().startswith('//')
]
```

**Why it's needed:**
- Comments can contain `;` which confuses the statement splitter
- Example:
  ```cypher
  // Example: MERGE (n) WHERE id = '123';
  MERGE (e:Employee {id: 'EMP-001'});
  ```
  If you split by `;` first, you get an orphaned comment fragment.

**Solution:** Remove comments first, then split safely.

---

### **Data Validation Points**

| Check | Purpose | How |
|-------|---------|-----|
| **Connection Test** | Ensure Neo4j is running | `driver.verify_connectivity()` |
| **Seed Files Exist** | Ensure seeds folder has files | `if not seed_files: sys.exit(1)` |
| **Cypher Syntax** | Detect parsing errors | Neo4j reports syntax errors |
| **Constraints** | Prevent duplicates | Unique constraint on all IDs |
| **Final Counts** | Verify expected node/rel counts | Query `MATCH (n) RETURN labels(n), count(n)` |

---

### **PII Handling**

Employee nodes contain PII (phone, DOB, address):
```python
{
  phone: '+91-9876543210',     // PII
  dob: date('1968-03-15'),     // PII
  address: 'Delhi, India'      // PII
}
```

**Masking Strategy:**
- Data is stored **unmasked** in Neo4j (for full querying)
- Backend `auth.py` masks PII based on user's access level:
  - **Admin/Manager:** See full data
  - **Employee:** See only their own data
  - **Guest/System:** PII stripped entirely

**Example Mask:**
```python
if access_level not in ['L1_ADMIN', 'L2_MANAGER']:
    employee.phone = '***-****'
    employee.dob = None
    employee.address = None
```

---

## Maintenance & Updates

### **Updating Existing Data**

To modify an employee (e.g., change role):

```cypher
MATCH (e:Employee {employee_id: 'EMP-TECH-010'})
SET e.full_name = 'Updated Name',
    e.current_status = 'On Leave'
```

**Or in bulk:**
```cypher
MATCH (e:Employee) WHERE e.dept_id = 'DEPT-001'
SET e.current_status = 'Active'
```

### **Adding New Data**

To add a new employee without recreating everything:

```cypher
MERGE (e:Employee {employee_id: 'EMP-TECH-999'})
SET e.full_name = 'New Person',
    e.email = 'new@coditas.com',
    e.joining_date = date('2025-01-01'),
    ...
    e.created_at = datetime();

// Link to department
MATCH (e:Employee {employee_id: 'EMP-TECH-999'}), (d:Department {dept_id: 'DEPT-001'})
MERGE (e)-[:BELONGS_TO {since: e.joining_date}]->(d);

// Assign role
MATCH (e:Employee {employee_id: 'EMP-TECH-999'}), (r:Role {role_id: 'ROLE-TECH-007'})
MERGE (e)-[:HAS_ROLE {since: e.joining_date, is_current: true}]->(r);
```

### **Full Reset (Wipe & Reload)**

To completely clear the graph:

```cypher
// In Neo4j Browser (http://localhost:7474)
MATCH (n) DETACH DELETE n
```

Then run:
```bash
cd data
python load_data.py
```

### **Backup & Export**

To backup the graph as Cypher:
```bash
neo4j-admin database dump neo4j backup.dump --to-path=/path/to/backups
```

To export as CSV:
```cypher
MATCH (e:Employee)
RETURN e.employee_id, e.full_name, e.email
```

---

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| `❌ Failed to connect to Neo4j` | Docker not running or wrong URI | `docker ps` and verify `NEO4J_URI` in `.env` |
| `❌ No .cypher files found` | Seeds folder is empty or missing | Check `data/seeds/` directory exists and has files |
| `❌ Constraint violation` | Duplicate ID or malformed MERGE | Check seed file for duplicate node IDs |
| `Orphaned comment fragments` | Comments split incorrectly | Script handles this; check if using old version |
| Partial data loaded | Script stopped mid-way | Check logs for errors; re-run to complete |
| Wrong employee counts | Seeding incomplete | Verify all 11 files executed successfully |

---

## Summary

The `data/` folder is the **foundation** of the Org Knowledge Hub:

1. **Structure:** 11 ordered Cypher seed files that build the graph incrementally
2. **Content:** 279 nodes (employees, roles, departments, projects, skills, clients, certifications) and 1,847 relationships
3. **Loading:** `load_data.py` orchestrates execution with:
   - Connection pooling
   - Comment stripping (data cleaning)
   - Error handling
   - Final validation (node/relationship counts)
4. **Idempotency:** Safe to run multiple times; uses MERGE and unique constraints
5. **Maintenance:** Easy to add/update data by running additional Cypher queries

For any changes to the knowledge graph, add new Cypher files in `seeds/` (name them `12_*.cypher`, etc.) and they'll be picked up automatically on the next run!
