# Cypher Query Reference — Org Knowledge Hub
# Run these in Neo4j Browser: http://localhost:7474 (neo4j / coditas123)

---

## CATEGORY A — Employee Lookup

```cypher
// A1. Get full profile of an employee
MATCH (e:Employee {full_name: 'Shubham Chougale'})
OPTIONAL MATCH (e)-[:BELONGS_TO]->(d:Department)
OPTIONAL MATCH (e)-[:HAS_ROLE]->(r:Role)
OPTIONAL MATCH (e)-[:REPORTS_TO]->(m:Employee)
OPTIONAL MATCH (e)-[:ASSIGNED_TO {is_current: true}]->(p:Project)
RETURN e.employee_id, e.full_name, e.email, e.joining_date,
       e.total_experience_years, e.org_experience_years,
       e.current_status, d.name AS department,
       r.title AS role, m.full_name AS reports_to,
       collect(p.name) AS current_projects;
```

```cypher
// A2. Find employee by email
MATCH (e:Employee {email: 'shubham.morya@coditas.com'})
RETURN e.full_name, e.employee_id, e.current_status;
```

```cypher
// A3. Who joined in a specific month/year (e.g. December 2024)
MATCH (e:Employee)
WHERE e.joining_date >= date('2024-12-01') AND e.joining_date <= date('2024-12-31')
RETURN e.full_name, e.employee_id, e.joining_date
ORDER BY e.joining_date;
```

```cypher
// A4. All associate engineers in Tech
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department {name: 'Tech'})
MATCH (e)-[:HAS_ROLE]->(r:Role {title: 'Associate Engineer'})
RETURN e.full_name, e.employee_id, e.joining_date
ORDER BY e.joining_date;
```

```cypher
// A5. How long has an employee been in the company
MATCH (e:Employee {full_name: 'Shubham Chougale'})
RETURN e.full_name, e.org_experience_years AS years_in_company,
       e.joining_date, e.total_experience_years AS total_career_experience;
```

```cypher
// A6. Search employees by partial name (case-insensitive)
MATCH (e:Employee)
WHERE toLower(e.full_name) CONTAINS toLower('sharma')
RETURN e.full_name, e.employee_id, e.email
ORDER BY e.full_name;
```

```cypher
// A7. All active employees
MATCH (e:Employee {current_status: 'Active'})
RETURN count(e) AS total_active;
```

```cypher
// A8. All employees who joined after a specific date
MATCH (e:Employee)
WHERE e.joining_date > date('2020-01-01')
MATCH (e)-[:BELONGS_TO]->(d:Department)
RETURN e.full_name, e.joining_date, d.name AS department
ORDER BY e.joining_date DESC;
```

---

## CATEGORY B — Hierarchy & Reporting

```cypher
// B1. Who does Shubham report to?
MATCH (e:Employee {full_name: 'Shubham Chougale'})-[r:REPORTS_TO]->(m:Employee)
RETURN m.full_name AS manager, m.email, r.type AS reporting_type;
```

```cypher
// B2. Who are someone's direct reports?
MATCH (e:Employee {full_name: 'Ananya Gupta'})<-[:REPORTS_TO]-(report:Employee)
OPTIONAL MATCH (report)-[:HAS_ROLE]->(r:Role)
RETURN report.full_name AS name, r.title AS role, report.email
ORDER BY r.level;
```

```cypher
// B3. Full reporting chain from employee up to CEO
MATCH path = (e:Employee {full_name: 'Shubham Chougale'})-[:REPORTS_TO*]->(top:Employee)
WHERE NOT (top)-[:REPORTS_TO]->()
RETURN [n IN nodes(path) | n.full_name] AS chain,
       length(path) AS levels_to_ceo;
```

```cypher
// B4. How many levels between an associate and CEO
MATCH path = (e:Employee)-[:REPORTS_TO*]->(ceo:Employee)
WHERE NOT (ceo)-[:REPORTS_TO]->()
AND e.employee_id = 'EMP-TECH-045'
RETURN e.full_name, length(path) AS levels_to_ceo;
```

```cypher
// B5. Who is the head of a specific department?
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department {name: 'Tech'})
MATCH (e)-[:HAS_ROLE]->(r:Role)
WHERE r.title IN ['CTO', 'Tech Head', 'Delivery Head', 'Sales Head', 'Marketing Head', 'HR Head', 'Finance Head', 'Chief Human Resources Officer', 'Chief Financial Officer', 'CEO']
RETURN e.full_name, r.title AS role;
```

```cypher
// B6. All employees who report to a specific person (direct + indirect)
MATCH (mgr:Employee {full_name: 'Arvind Patel'})<-[:REPORTS_TO*]-(report:Employee)
RETURN count(DISTINCT report) AS total_under_manager;
```

```cypher
// B7. Get the complete org tree under CTO (2 levels deep)
MATCH (cto:Employee {employee_id: 'EMP-TECH-001'})<-[:REPORTS_TO*1..2]-(e:Employee)
OPTIONAL MATCH (e)-[:HAS_ROLE]->(r:Role)
RETURN e.full_name, r.title AS role, e.employee_id
ORDER BY r.level DESC;
```

```cypher
// B8. Who has dual reporting lines (line + project)?
MATCH (e:Employee)-[r:REPORTS_TO]->(m:Employee)
WITH e, collect(r.type) AS types
WHERE size(types) > 1
RETURN e.full_name, types;
```

---

## CATEGORY C — Project Intelligence

```cypher
// C1. Which projects is Shubham currently working on?
MATCH (e:Employee {full_name: 'Shubham Chougale'})-[a:ASSIGNED_TO]->(p:Project)
WHERE a.is_current = true
RETURN p.name, p.status, p.type, a.role_in_project, a.start_date;
```

```cypher
// C2. All employees on a specific project with their roles
MATCH (e:Employee)-[a:ASSIGNED_TO]->(p:Project {name: 'NeuraVault'})
OPTIONAL MATCH (e)-[:HAS_ROLE]->(r:Role)
RETURN e.full_name, e.employee_id, r.title AS designation,
       a.role_in_project AS project_role, a.is_current AS currently_active
ORDER BY a.is_current DESC, r.level;
```

```cypher
// C3. Who is the PM / manager of a project?
MATCH (e:Employee)-[:MANAGES_PROJECT]->(p:Project {name: 'NeuraVault'})
OPTIONAL MATCH (e)-[:HAS_ROLE]->(r:Role)
RETURN e.full_name, r.title AS designation, e.email;
```

```cypher
// C4. All active projects with team size
MATCH (p:Project {status: 'Active'})
OPTIONAL MATCH (e:Employee)-[:ASSIGNED_TO {is_current: true}]->(p)
RETURN p.name, p.type, count(e) AS active_members, p.start_date
ORDER BY active_members DESC;
```

```cypher
// C5. Projects using specific tech stack
MATCH (p:Project)
WHERE 'Neo4j' IN p.tech_stack AND 'Python' IN p.tech_stack
RETURN p.name, p.status, p.tech_stack;
```

```cypher
// C6. Completed projects with duration
MATCH (p:Project {status: 'Completed'})
RETURN p.name, p.start_date, p.end_date,
       duration.between(p.start_date, p.end_date).months AS duration_months;
```

```cypher
// C7. All projects for a specific client
MATCH (p:Project)-[:FOR_CLIENT]->(c:Client {name: 'TechVentures Inc'})
RETURN p.name, p.status, p.start_date, p.team_size;
```

```cypher
// C8. Employees who worked on multiple projects
MATCH (e:Employee)-[:ASSIGNED_TO]->(p:Project)
WITH e, collect(p.name) AS projects
WHERE size(projects) > 1
RETURN e.full_name, e.employee_id, projects, size(projects) AS project_count
ORDER BY project_count DESC;
```

```cypher
// C9. Project with the largest team
MATCH (e:Employee)-[:ASSIGNED_TO {is_current: true}]->(p:Project)
WITH p, count(e) AS team_size
ORDER BY team_size DESC LIMIT 1
RETURN p.name, p.status, team_size;
```

```cypher
// C10. All client projects with client details
MATCH (p:Project {type: 'Client'})-[:FOR_CLIENT]->(c:Client)
RETURN p.name, p.status, c.name AS client, c.industry, c.country;
```

---

## CATEGORY D — Skills & Expertise

```cypher
// D1. Find all employees with a specific skill
MATCH (e:Employee)-[hs:HAS_SKILL]->(s:Skill {name: 'Neo4j'})
OPTIONAL MATCH (e)-[:BELONGS_TO]->(d:Department)
RETURN e.full_name, hs.proficiency, hs.years AS years_of_experience,
       d.name AS department
ORDER BY hs.years DESC;
```

```cypher
// D2. Find all Python EXPERTS specifically
MATCH (e:Employee)-[hs:HAS_SKILL]->(s:Skill {name: 'Python'})
WHERE hs.proficiency = 'expert'
OPTIONAL MATCH (e)-[:BELONGS_TO]->(d:Department)
RETURN e.full_name, e.employee_id, d.name AS department;
```

```cypher
// D3. What skills does a specific employee have?
MATCH (e:Employee {full_name: 'Shubham Chougale'})-[hs:HAS_SKILL]->(s:Skill)
RETURN s.name, s.category, hs.proficiency, hs.years AS years
ORDER BY hs.proficiency, s.category;
```

```cypher
// D4. Find candidates with multiple specific skills (AND condition)
MATCH (e:Employee)-[hs1:HAS_SKILL]->(s1:Skill {name: 'React'})
MATCH (e)-[hs2:HAS_SKILL]->(s2:Skill {name: 'Python'})
RETURN e.full_name, e.employee_id,
       hs1.proficiency AS react_level,
       hs2.proficiency AS python_level;
```

```cypher
// D5. All skills in Tech department with proficiency breakdown
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department {name: 'Tech'})
MATCH (e)-[hs:HAS_SKILL]->(s:Skill)
RETURN s.name, hs.proficiency, count(e) AS employee_count
ORDER BY s.name, hs.proficiency;
```

```cypher
// D6. Skill gap analysis — skills with fewest experts
MATCH (e:Employee)-[hs:HAS_SKILL {proficiency: 'expert'}]->(s:Skill)
WITH s, count(e) AS expert_count
ORDER BY expert_count ASC
RETURN s.name, s.category, expert_count
LIMIT 10;
```

```cypher
// D7. All skills by category
MATCH (s:Skill)
RETURN s.category, collect(s.name) AS skills, count(s) AS total
ORDER BY s.category;
```

```cypher
// D8. Find employees available for a project requiring LangChain + Neo4j
MATCH (e:Employee)-[:HAS_SKILL]->(s1:Skill {name: 'LangChain'})
MATCH (e)-[:HAS_SKILL]->(s2:Skill {name: 'Neo4j'})
OPTIONAL MATCH (e)-[:ASSIGNED_TO {is_current: true}]->(p:Project)
RETURN e.full_name, collect(p.name) AS current_projects;
```

---

## CATEGORY E — Department Analytics

```cypher
// E1. Headcount by department
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
WHERE e.current_status = 'Active'
RETURN d.name AS department, count(e) AS headcount
ORDER BY headcount DESC;
```

```cypher
// E2. Average experience by department
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
RETURN d.name AS department,
       round(avg(e.total_experience_years) * 10) / 10 AS avg_total_exp,
       round(avg(e.org_experience_years) * 10) / 10 AS avg_org_exp
ORDER BY avg_org_exp DESC;
```

```cypher
// E3. All employees in a department
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department {name: 'HR'})
OPTIONAL MATCH (e)-[:HAS_ROLE]->(r:Role)
RETURN e.full_name, e.employee_id, r.title AS role, e.joining_date
ORDER BY r.level;
```

```cypher
// E4. Role distribution across all departments
MATCH (e:Employee)-[:HAS_ROLE]->(r:Role)
RETURN r.department, r.title, count(e) AS count
ORDER BY r.department, r.level;
```

```cypher
// E5. Gender breakdown by department
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
RETURN d.name AS department, e.gender, count(e) AS count
ORDER BY d.name, e.gender;
```

```cypher
// E6. New hires in the last year
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
WHERE e.joining_date >= date('2024-01-01')
RETURN e.full_name, e.joining_date, d.name AS department
ORDER BY e.joining_date DESC;
```

```cypher
// E7. Department with highest average org experience
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
WITH d.name AS dept, avg(e.org_experience_years) AS avg_exp
ORDER BY avg_exp DESC LIMIT 1
RETURN dept, round(avg_exp * 10) / 10 AS avg_years;
```

---

## CATEGORY F — Historical & Timeline

```cypher
// F1. Employees with more than N years org experience
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
WHERE e.org_experience_years > 5 AND e.current_status = 'Active'
RETURN e.full_name, d.name AS dept, e.org_experience_years AS org_exp
ORDER BY e.org_experience_years DESC;
```

```cypher
// F2. Employees with the most total career experience
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
RETURN e.full_name, d.name AS dept, e.total_experience_years
ORDER BY e.total_experience_years DESC
LIMIT 10;
```

```cypher
// F3. Employees who joined in the same year
MATCH (e:Employee)
WITH e.joining_date.year AS year, collect(e.full_name) AS names, count(e) AS total
ORDER BY year DESC
RETURN year, total, names;
```

```cypher
// F4. Veterans — who has been here the longest?
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
RETURN e.full_name, e.joining_date, e.org_experience_years, d.name AS dept
ORDER BY e.joining_date ASC
LIMIT 10;
```

---

## CATEGORY G — Cross-Domain (Advanced)

```cypher
// G1. Find the best candidate to lead a new AI project
// (Senior or above, Python expert, Neo4j or LangChain skills, currently active)
MATCH (e:Employee)-[r1:HAS_SKILL]->(s1:Skill {name: 'Python'})
WHERE r1.proficiency = 'expert'
MATCH (e)-[:HAS_SKILL]->(s2:Skill)
WHERE s2.name IN ['Neo4j', 'LangChain', 'OpenAI API']
MATCH (e)-[:HAS_ROLE]->(role:Role)
WHERE role.level <= 4
OPTIONAL MATCH (e)-[:ASSIGNED_TO {is_current: true}]->(p:Project)
WITH e, collect(s2.name) AS ai_skills, collect(p.name) AS current_projects
RETURN e.full_name, e.employee_id, ai_skills, current_projects;
```

```cypher
// G2. Which department contributes most to active projects?
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
MATCH (e)-[:ASSIGNED_TO {is_current: true}]->(p:Project {status: 'Active'})
RETURN d.name AS department, count(DISTINCT e) AS members_on_active_projects
ORDER BY members_on_active_projects DESC;
```

```cypher
// G3. Full snapshot of a project (team + client + manager + tech)
MATCH (p:Project {name: 'OrgPulse'})
OPTIONAL MATCH (pm:Employee)-[:MANAGES_PROJECT]->(p)
OPTIONAL MATCH (member:Employee)-[:ASSIGNED_TO {is_current: true}]->(p)
OPTIONAL MATCH (p)-[:FOR_CLIENT]->(c:Client)
RETURN p.name, p.status, p.type, p.tech_stack,
       collect(DISTINCT pm.full_name) AS managers,
       collect(DISTINCT member.full_name) AS team_members,
       c.name AS client;
```

```cypher
// G4. Identify employees with no project assignment
MATCH (e:Employee)
WHERE NOT (e)-[:ASSIGNED_TO {is_current: true}]->()
OPTIONAL MATCH (e)-[:BELONGS_TO]->(d:Department)
OPTIONAL MATCH (e)-[:HAS_ROLE]->(r:Role)
RETURN e.full_name, d.name AS department, r.title AS role
ORDER BY d.name;
```

```cypher
// G5. Skills overlap between two employees
MATCH (e1:Employee {full_name: 'Shubham Chougale'})-[:HAS_SKILL]->(s:Skill)
MATCH (e2:Employee {full_name: 'Priya Verma'})-[:HAS_SKILL]->(s)
RETURN s.name AS shared_skill, s.category;
```

```cypher
// G6. Most assigned employees (busiest people)
MATCH (e:Employee)-[:ASSIGNED_TO {is_current: true}]->(p:Project)
WITH e, count(p) AS project_count
ORDER BY project_count DESC
RETURN e.full_name, e.employee_id, project_count
LIMIT 10;
```

```cypher
// G7. Complete graph overview — node and relationship counts
MATCH (n)
RETURN labels(n)[0] AS node_type, count(n) AS count
ORDER BY count DESC
UNION
MATCH ()-[r]->()
RETURN type(r) AS node_type, count(r) AS count
ORDER BY count DESC;
```

---

## VISUAL GRAPH QUERIES (return nodes+relationships, not just text)

```cypher
// VIZ1. See Shubham's full neighbourhood (colleagues, skills, projects)
MATCH path = (e:Employee {full_name: 'Shubham Chougale'})-[*1..2]-()
RETURN path LIMIT 70;
```

```cypher
// VIZ2. See the full Tech leadership org chart
MATCH path = (cto:Employee {employee_id: 'EMP-TECH-001'})<-[:REPORTS_TO*1..3]-(e:Employee)
RETURN path;
```

```cypher
// VIZ3. See a project and all its connected employees
MATCH path = (p:Project {name: 'OrgPulse'})<-[:ASSIGNED_TO|MANAGES_PROJECT]-(e:Employee)
RETURN path;
```

```cypher
// VIZ4. Entire org hierarchy (top 3 levels only — keep it readable)
MATCH path = (ceo:Employee {employee_id: 'EMP-CEO-001'})<-[:REPORTS_TO*1..2]-(e:Employee)
RETURN path;
```

```cypher
// VIZ5. Skills network for Tech department
MATCH path = (e:Employee)-[:HAS_SKILL]->(s:Skill)
WHERE e.employee_id STARTS WITH 'EMP-TECH-0'
AND e.employee_id <= 'EMP-TECH-015'
RETURN path;
```
