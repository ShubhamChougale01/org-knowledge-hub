# Backtest Query Reference
# These are the exact Cypher queries the chatbot should generate for each natural language question.
# Run each in Neo4j Browser to verify the graph returns correct data before testing the chatbot.

---

## CLIENT QUERIES (Multi-hop traversal)

```cypher
-- Q: "How many projects does TechVentures Inc have?"
MATCH (c:Client {name: 'TechVentures Inc'})<-[:FOR_CLIENT]-(p:Project)
RETURN c.name AS client, count(p) AS total_projects, collect(p.name) AS projects;
-- Expected: 1 project (NeuraVault)
```

```cypher
-- Q: "Who are all the employees working for TechVentures Inc?"
MATCH (c:Client {name: 'TechVentures Inc'})<-[:FOR_CLIENT]-(p:Project)
MATCH (e:Employee)-[:ASSIGNED_TO {is_current: true}]->(p)
RETURN c.name AS client, p.name AS project, count(DISTINCT e) AS team_size,
       collect(DISTINCT e.full_name) AS employees
ORDER BY p.name;
-- Expected: NeuraVault with 35 members
```

```cypher
-- Q: "Show me all clients and their active projects"
MATCH (c:Client)<-[:FOR_CLIENT]-(p:Project {status: 'Active'})
OPTIONAL MATCH (e:Employee)-[:ASSIGNED_TO {is_current: true}]->(p)
RETURN c.name AS client, c.industry, p.name AS project,
       count(DISTINCT e) AS team_size
ORDER BY c.name;
```

```cypher
-- Q: "Which client has the most employees working for them?"
MATCH (c:Client)<-[:FOR_CLIENT]-(p:Project)
MATCH (e:Employee)-[:ASSIGNED_TO {is_current: true}]->(p)
WITH c, count(DISTINCT e) AS total_employees
ORDER BY total_employees DESC LIMIT 1
RETURN c.name AS client, total_employees;
-- Expected: TechVentures Inc with 35+ employees
```

```cypher
-- Q: "What is the tech stack used for SecureBank AG projects?"
MATCH (c:Client {name: 'SecureBank AG'})<-[:FOR_CLIENT]-(p:Project)
RETURN c.name AS client, p.name AS project, p.tech_stack;
-- Expected: SentinelAI - Python, OpenAI, Pinecone, Node.js
```

---

## EMPLOYEE + PROJECT + CLIENT (3-hop queries)

```cypher
-- Q: "Show me Shubham Chougale's project and who the client is"
MATCH (e:Employee {full_name: 'Shubham Chougale'})-[:ASSIGNED_TO]->(p:Project)
OPTIONAL MATCH (p)-[:FOR_CLIENT]->(c:Client)
RETURN e.full_name, p.name AS project, p.status,
       coalesce(c.name, 'Internal') AS client;
```

```cypher
-- Q: "Which employees in Tech work on client projects?"
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department {name: 'Tech'})
MATCH (e)-[:ASSIGNED_TO {is_current: true}]->(p:Project {type: 'Client'})
MATCH (p)-[:FOR_CLIENT]->(c:Client)
RETURN e.full_name, p.name AS project, c.name AS client
ORDER BY c.name, p.name;
```

```cypher
-- Q: "How many Coditas employees are dedicated to MediCare Solutions?"
MATCH (c:Client {name: 'MediCare Solutions'})<-[:FOR_CLIENT]-(p:Project)
MATCH (e:Employee)-[:ASSIGNED_TO {is_current: true}]->(p)
RETURN count(DISTINCT e) AS dedicated_employees, p.name AS project;
-- Expected: CipherSec with 9 employees
```

---

## CERTIFICATION QUERIES

```cypher
-- Q: "Who has AWS certifications in the company?"
MATCH (e:Employee)-[:HAS_CERTIFICATION]->(c:Certification)
WHERE c.name CONTAINS 'AWS'
OPTIONAL MATCH (e)-[:BELONGS_TO]->(d:Department)
RETURN e.full_name, c.name AS certification, c.issued_date, d.name AS department
ORDER BY d.name;
```

```cypher
-- Q: "Does Shubham have Neo4j certification?"
MATCH (e:Employee {full_name: 'Shubham Chougale'})-[:HAS_CERTIFICATION]->(c:Certification)
WHERE c.name CONTAINS 'Neo4j'
RETURN e.full_name, c.name, c.issued_date, c.expiry_date;
-- Expected: Neo4j Certified Professional, 2024-03-15, no expiry
```

```cypher
-- Q: "Which certifications are expiring in the next 6 months?"
MATCH (e:Employee)-[:HAS_CERTIFICATION]->(c:Certification)
WHERE c.expiry_date IS NOT NULL
  AND c.expiry_date >= date()
  AND c.expiry_date <= date() + duration({months: 6})
RETURN e.full_name, c.name, c.expiry_date
ORDER BY c.expiry_date;
```

```cypher
-- Q: "How many employees have PMP certification?"
MATCH (e:Employee)-[:HAS_CERTIFICATION]->(c:Certification)
WHERE c.name CONTAINS 'Project Management Professional'
RETURN count(e) AS pmp_holders, collect(e.full_name) AS names;
```

---

## PROMOTION QUERIES

```cypher
-- Q: "Has Shubham Chougale been promoted?"
MATCH (e:Employee {full_name: 'Shubham Chougale'})-[:PROMOTED_TO]->(ph:PromotionHistory)
RETURN ph.from_role, ph.to_role, ph.effective_date;
-- Expected: Associate Software Engineer -> Software Engineer, 2025-06-30
```

```cypher
-- Q: "Show all promotions in the Tech department"
MATCH (ph:PromotionHistory)-[:IN_DEPARTMENT]->(d:Department {name: 'Tech'})
MATCH (e:Employee)-[:PROMOTED_TO]->(ph)
RETURN e.full_name, ph.from_role, ph.to_role, ph.effective_date
ORDER BY ph.effective_date DESC;
```

```cypher
-- Q: "Who got promoted to Senior Software Engineer?"
MATCH (e:Employee)-[:PROMOTED_TO]->(ph:PromotionHistory {to_role: 'Senior Software Engineer'})
RETURN e.full_name, ph.effective_date
ORDER BY ph.effective_date;
```

```cypher
-- Q: "How many promotions happened in 2021?"
MATCH (ph:PromotionHistory)
WHERE ph.effective_date.year = 2021
MATCH (e:Employee)-[:PROMOTED_TO]->(ph)
OPTIONAL MATCH (ph)-[:IN_DEPARTMENT]->(d:Department)
RETURN d.name AS department, count(ph) AS promotions_in_2021
ORDER BY promotions_in_2021 DESC;
```

---

## CROSS-DOMAIN COMPLEX QUERIES

```cypher
-- Q: "Find senior engineers who have AWS certification and are on active client projects"
MATCH (e:Employee)-[:HAS_ROLE]->(r:Role)
WHERE r.title CONTAINS 'Senior'
MATCH (e)-[:HAS_CERTIFICATION]->(c:Certification)
WHERE c.name CONTAINS 'AWS'
MATCH (e)-[:ASSIGNED_TO {is_current: true}]->(p:Project {type: 'Client', status: 'Active'})
MATCH (p)-[:FOR_CLIENT]->(cl:Client)
RETURN e.full_name, r.title, c.name AS cert, p.name AS project, cl.name AS client;
```

```cypher
-- Q: "Which department has the most certifications?"
MATCH (e:Employee)-[:BELONGS_TO]->(d:Department)
MATCH (e)-[:HAS_CERTIFICATION]->(c:Certification)
RETURN d.name AS department, count(c) AS total_certs
ORDER BY total_certs DESC;
```

```cypher
-- Q: "Show employees who were promoted AND have a client-facing project"
MATCH (e:Employee)-[:PROMOTED_TO]->(ph:PromotionHistory)
MATCH (e)-[:ASSIGNED_TO {is_current: true}]->(p:Project {type: 'Client'})
MATCH (p)-[:FOR_CLIENT]->(c:Client)
RETURN e.full_name, ph.from_role, ph.to_role, ph.effective_date,
       p.name AS project, c.name AS client
ORDER BY ph.effective_date DESC;
```
