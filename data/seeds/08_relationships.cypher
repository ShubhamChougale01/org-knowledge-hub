// Rule: When filtering with WHERE, the second MATCH pattern must come BEFORE the WHERE clause.
// Rule: Never put null values inside a MERGE clause — use SET after MERGE for nullable properties.

// ==================== DEPARTMENT RELATIONSHIPS ====================
// Tech Department — individual explicit assignments for leadership
MATCH (e:Employee {employee_id: 'EMP-TECH-001'}), (d:Department {dept_id: 'DEPT-001'}) MERGE (e)-[:BELONGS_TO {since: date('2012-06-01')}]->(d);
MATCH (e:Employee {employee_id: 'EMP-TECH-002'}), (d:Department {dept_id: 'DEPT-001'}) MERGE (e)-[:BELONGS_TO {since: date('2014-08-15')}]->(d);
MATCH (e:Employee {employee_id: 'EMP-TECH-003'}), (d:Department {dept_id: 'DEPT-001'}) MERGE (e)-[:BELONGS_TO {since: date('2013-07-20')}]->(d);
MATCH (e:Employee {employee_id: 'EMP-TECH-004'}), (d:Department {dept_id: 'DEPT-001'}) MERGE (e)-[:BELONGS_TO {since: date('2016-03-10')}]->(d);
MATCH (e:Employee {employee_id: 'EMP-TECH-005'}), (d:Department {dept_id: 'DEPT-001'}) MERGE (e)-[:BELONGS_TO {since: date('2017-01-15')}]->(d);
MATCH (e:Employee {employee_id: 'EMP-TECH-006'}), (d:Department {dept_id: 'DEPT-001'}) MERGE (e)-[:BELONGS_TO {since: date('2015-09-20')}]->(d);
MATCH (e:Employee {employee_id: 'EMP-TECH-007'}), (d:Department {dept_id: 'DEPT-001'}) MERGE (e)-[:BELONGS_TO {since: date('2016-05-01')}]->(d);
MATCH (e:Employee {employee_id: 'EMP-TECH-008'}), (d:Department {dept_id: 'DEPT-001'}) MERGE (e)-[:BELONGS_TO {since: date('2017-02-10')}]->(d);
MATCH (e:Employee {employee_id: 'EMP-TECH-009'}), (d:Department {dept_id: 'DEPT-001'}) MERGE (e)-[:BELONGS_TO {since: date('2015-11-15')}]->(d);
MATCH (e:Employee {employee_id: 'EMP-TECH-010'}), (d:Department {dept_id: 'DEPT-001'}) MERGE (e)-[:BELONGS_TO {since: date('2024-12-31')}]->(d);
// Remaining Tech employees (batch by prefix)
MATCH (e:Employee), (d:Department {dept_id: 'DEPT-001'}) WHERE e.employee_id STARTS WITH 'EMP-TECH-' AND e.employee_id >= 'EMP-TECH-011' MERGE (e)-[r:BELONGS_TO]->(d) ON CREATE SET r.since = e.joining_date;

// Delivery Department
MATCH (e:Employee), (d:Department {dept_id: 'DEPT-002'}) WHERE e.employee_id STARTS WITH 'EMP-DEL-' MERGE (e)-[r:BELONGS_TO]->(d) ON CREATE SET r.since = e.joining_date;

// Sales Department
MATCH (e:Employee), (d:Department {dept_id: 'DEPT-003'}) WHERE e.employee_id STARTS WITH 'EMP-SAL-' MERGE (e)-[r:BELONGS_TO]->(d) ON CREATE SET r.since = e.joining_date;

// Marketing Department
MATCH (e:Employee), (d:Department {dept_id: 'DEPT-004'}) WHERE e.employee_id STARTS WITH 'EMP-MKT-' MERGE (e)-[r:BELONGS_TO]->(d) ON CREATE SET r.since = e.joining_date;

// HR Department
MATCH (e:Employee), (d:Department {dept_id: 'DEPT-005'}) WHERE e.employee_id STARTS WITH 'EMP-HR-' MERGE (e)-[r:BELONGS_TO]->(d) ON CREATE SET r.since = e.joining_date;

// Finance Department
MATCH (e:Employee), (d:Department {dept_id: 'DEPT-006'}) WHERE e.employee_id STARTS WITH 'EMP-FIN-' MERGE (e)-[r:BELONGS_TO]->(d) ON CREATE SET r.since = e.joining_date;

// Executive Department
MATCH (e:Employee), (d:Department {dept_id: 'DEPT-007'}) WHERE e.employee_id STARTS WITH 'EMP-CEO-' OR e.employee_id STARTS WITH 'EMP-EXE-' MERGE (e)-[r:BELONGS_TO]->(d) ON CREATE SET r.since = e.joining_date;

// ==================== ROLE RELATIONSHIPS ====================
MATCH (e:Employee {employee_id: 'EMP-CEO-001'}), (r:Role {role_id: 'ROLE-EXE-001'}) MERGE (e)-[:HAS_ROLE {since: date('2010-01-15'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-TECH-001'}), (r:Role {role_id: 'ROLE-TECH-001'}) MERGE (e)-[:HAS_ROLE {since: date('2012-06-01'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-TECH-002'}), (r:Role {role_id: 'ROLE-TECH-002'}) MERGE (e)-[:HAS_ROLE {since: date('2014-08-15'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-TECH-003'}), (r:Role {role_id: 'ROLE-TECH-002'}) MERGE (e)-[:HAS_ROLE {since: date('2013-07-20'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-TECH-004'}), (r:Role {role_id: 'ROLE-TECH-006'}) MERGE (e)-[:HAS_ROLE {since: date('2016-03-10'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-TECH-005'}), (r:Role {role_id: 'ROLE-TECH-006'}) MERGE (e)-[:HAS_ROLE {since: date('2017-01-15'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-TECH-006'}), (r:Role {role_id: 'ROLE-TECH-006'}) MERGE (e)-[:HAS_ROLE {since: date('2015-09-20'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-TECH-007'}), (r:Role {role_id: 'ROLE-TECH-006'}) MERGE (e)-[:HAS_ROLE {since: date('2016-05-01'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-TECH-008'}), (r:Role {role_id: 'ROLE-TECH-006'}) MERGE (e)-[:HAS_ROLE {since: date('2017-02-10'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-TECH-009'}), (r:Role {role_id: 'ROLE-TECH-006'}) MERGE (e)-[:HAS_ROLE {since: date('2015-11-15'), is_current: true}]->(r);

// Senior Engineers (EMP-TECH-010 through EMP-TECH-024)
MATCH (e:Employee), (r:Role {role_id: 'ROLE-TECH-007'}) WHERE e.employee_id >= 'EMP-TECH-010' AND e.employee_id <= 'EMP-TECH-024'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;

// Engineers (EMP-TECH-025 through EMP-TECH-044)
MATCH (e:Employee), (r:Role {role_id: 'ROLE-TECH-008'}) WHERE e.employee_id >= 'EMP-TECH-025' AND e.employee_id <= 'EMP-TECH-044'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;

// Associate Engineers (EMP-TECH-045 through EMP-TECH-060)
MATCH (e:Employee), (r:Role {role_id: 'ROLE-TECH-009'}) WHERE e.employee_id >= 'EMP-TECH-045' AND e.employee_id <= 'EMP-TECH-060'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;

// Delivery Heads
MATCH (e:Employee {employee_id: 'EMP-DEL-001'}), (r:Role {role_id: 'ROLE-DEL-001'}) MERGE (e)-[:HAS_ROLE {since: date('2013-09-01'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-DEL-002'}), (r:Role {role_id: 'ROLE-DEL-001'}) MERGE (e)-[:HAS_ROLE {since: date('2014-10-15'), is_current: true}]->(r);

// Delivery PMs
MATCH (e:Employee {employee_id: 'EMP-DEL-003'}), (r:Role {role_id: 'ROLE-DEL-003'}) MERGE (e)-[:HAS_ROLE {since: date('2015-11-20'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-DEL-004'}), (r:Role {role_id: 'ROLE-DEL-003'}) MERGE (e)-[:HAS_ROLE {since: date('2016-03-10'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-DEL-005'}), (r:Role {role_id: 'ROLE-DEL-003'}) MERGE (e)-[:HAS_ROLE {since: date('2016-05-01'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-DEL-006'}), (r:Role {role_id: 'ROLE-DEL-003'}) MERGE (e)-[:HAS_ROLE {since: date('2017-04-15'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-DEL-007'}), (r:Role {role_id: 'ROLE-DEL-003'}) MERGE (e)-[:HAS_ROLE {since: date('2015-12-10'), is_current: true}]->(r);

// Delivery Senior Analysts, Analysts, Associates
MATCH (e:Employee), (r:Role {role_id: 'ROLE-DEL-004'}) WHERE e.employee_id >= 'EMP-DEL-008' AND e.employee_id <= 'EMP-DEL-017'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;
MATCH (e:Employee), (r:Role {role_id: 'ROLE-DEL-005'}) WHERE e.employee_id >= 'EMP-DEL-018' AND e.employee_id <= 'EMP-DEL-029'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;
MATCH (e:Employee), (r:Role {role_id: 'ROLE-DEL-006'}) WHERE e.employee_id >= 'EMP-DEL-030' AND e.employee_id <= 'EMP-DEL-035'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;

// Sales
MATCH (e:Employee {employee_id: 'EMP-SAL-001'}), (r:Role {role_id: 'ROLE-SAL-001'}) MERGE (e)-[:HAS_ROLE {since: date('2013-08-15'), is_current: true}]->(r);
MATCH (e:Employee), (r:Role {role_id: 'ROLE-SAL-002'}) WHERE e.employee_id >= 'EMP-SAL-002' AND e.employee_id <= 'EMP-SAL-005'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;
MATCH (e:Employee), (r:Role {role_id: 'ROLE-SAL-003'}) WHERE e.employee_id >= 'EMP-SAL-006' AND e.employee_id <= 'EMP-SAL-015'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;
MATCH (e:Employee), (r:Role {role_id: 'ROLE-SAL-004'}) WHERE e.employee_id >= 'EMP-SAL-016' AND e.employee_id <= 'EMP-SAL-020'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;

// Marketing
MATCH (e:Employee {employee_id: 'EMP-MKT-001'}), (r:Role {role_id: 'ROLE-MKT-001'}) MERGE (e)-[:HAS_ROLE {since: date('2014-03-10'), is_current: true}]->(r);
MATCH (e:Employee), (r:Role {role_id: 'ROLE-MKT-002'}) WHERE e.employee_id >= 'EMP-MKT-002' AND e.employee_id <= 'EMP-MKT-004'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;
MATCH (e:Employee), (r:Role {role_id: 'ROLE-MKT-003'}) WHERE e.employee_id >= 'EMP-MKT-005' AND e.employee_id <= 'EMP-MKT-012'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;
MATCH (e:Employee), (r:Role {role_id: 'ROLE-MKT-004'}) WHERE e.employee_id >= 'EMP-MKT-013' AND e.employee_id <= 'EMP-MKT-015'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;

// HR
MATCH (e:Employee {employee_id: 'EMP-HR-001'}), (r:Role {role_id: 'ROLE-HR-001'}) MERGE (e)-[:HAS_ROLE {since: date('2012-07-01'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-HR-002'}), (r:Role {role_id: 'ROLE-HR-002'}) MERGE (e)-[:HAS_ROLE {since: date('2014-08-20'), is_current: true}]->(r);
MATCH (e:Employee), (r:Role {role_id: 'ROLE-HR-003'}) WHERE e.employee_id >= 'EMP-HR-003' AND e.employee_id <= 'EMP-HR-004'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;
MATCH (e:Employee), (r:Role {role_id: 'ROLE-HR-004'}) WHERE e.employee_id >= 'EMP-HR-005' AND e.employee_id <= 'EMP-HR-008'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;
MATCH (e:Employee), (r:Role {role_id: 'ROLE-HR-005'}) WHERE e.employee_id >= 'EMP-HR-009' AND e.employee_id <= 'EMP-HR-010'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;

// Finance
MATCH (e:Employee {employee_id: 'EMP-FIN-001'}), (r:Role {role_id: 'ROLE-FIN-001'}) MERGE (e)-[:HAS_ROLE {since: date('2011-06-01'), is_current: true}]->(r);
MATCH (e:Employee {employee_id: 'EMP-FIN-002'}), (r:Role {role_id: 'ROLE-FIN-002'}) MERGE (e)-[:HAS_ROLE {since: date('2013-08-15'), is_current: true}]->(r);
MATCH (e:Employee), (r:Role {role_id: 'ROLE-FIN-003'}) WHERE e.employee_id >= 'EMP-FIN-003' AND e.employee_id <= 'EMP-FIN-004'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;
MATCH (e:Employee), (r:Role {role_id: 'ROLE-FIN-004'}) WHERE e.employee_id >= 'EMP-FIN-005' AND e.employee_id <= 'EMP-FIN-009'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;
MATCH (e:Employee), (r:Role {role_id: 'ROLE-FIN-005'}) WHERE e.employee_id >= 'EMP-FIN-010' AND e.employee_id <= 'EMP-FIN-012'
MERGE (e)-[rel:HAS_ROLE]->(r) ON CREATE SET rel.since = e.joining_date, rel.is_current = true;

// Executive VPs — intentionally NOT assigned the CEO role.
// There is only one CEO (EMP-CEO-001 / Rajesh Sharma).
// EMP-EXE-001 and EMP-EXE-002 are VPs without a dedicated role node in this PoC.

// ==================== REPORTING RELATIONSHIPS ====================
// C-Suite reports to CEO
MATCH (e:Employee {employee_id: 'EMP-TECH-001'}), (m:Employee {employee_id: 'EMP-CEO-001'}) MERGE (e)-[:REPORTS_TO {type: 'line', since: date('2012-06-01')}]->(m);
MATCH (e:Employee {employee_id: 'EMP-FIN-001'}), (m:Employee {employee_id: 'EMP-CEO-001'}) MERGE (e)-[:REPORTS_TO {type: 'line', since: date('2011-06-01')}]->(m);
MATCH (e:Employee {employee_id: 'EMP-HR-001'}), (m:Employee {employee_id: 'EMP-CEO-001'}) MERGE (e)-[:REPORTS_TO {type: 'line', since: date('2012-07-01')}]->(m);
MATCH (e:Employee {employee_id: 'EMP-DEL-001'}), (m:Employee {employee_id: 'EMP-CEO-001'}) MERGE (e)-[:REPORTS_TO {type: 'line', since: date('2013-09-01')}]->(m);
MATCH (e:Employee {employee_id: 'EMP-DEL-002'}), (m:Employee {employee_id: 'EMP-CEO-001'}) MERGE (e)-[:REPORTS_TO {type: 'line', since: date('2014-10-15')}]->(m);
MATCH (e:Employee {employee_id: 'EMP-SAL-001'}), (m:Employee {employee_id: 'EMP-CEO-001'}) MERGE (e)-[:REPORTS_TO {type: 'line', since: date('2013-08-15')}]->(m);
MATCH (e:Employee {employee_id: 'EMP-MKT-001'}), (m:Employee {employee_id: 'EMP-CEO-001'}) MERGE (e)-[:REPORTS_TO {type: 'line', since: date('2014-03-10')}]->(m);

// HR Head → CHO; Finance Head → CFO
MATCH (e:Employee {employee_id: 'EMP-HR-002'}), (m:Employee {employee_id: 'EMP-HR-001'}) MERGE (e)-[:REPORTS_TO {type: 'line', since: date('2014-08-20')}]->(m);
MATCH (e:Employee {employee_id: 'EMP-FIN-002'}), (m:Employee {employee_id: 'EMP-FIN-001'}) MERGE (e)-[:REPORTS_TO {type: 'line', since: date('2013-08-15')}]->(m);

// Tech Heads → CTO
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-TECH-001'}) WHERE e.employee_id IN ['EMP-TECH-002', 'EMP-TECH-003']
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;

// Tech PMs → Tech Head
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-TECH-002'}) WHERE e.employee_id >= 'EMP-TECH-004' AND e.employee_id <= 'EMP-TECH-009'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;

// Senior Engineers → PM
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-TECH-004'}) WHERE e.employee_id >= 'EMP-TECH-010' AND e.employee_id <= 'EMP-TECH-024'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;

// Engineers → Senior Engineer
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-TECH-010'}) WHERE e.employee_id >= 'EMP-TECH-025' AND e.employee_id <= 'EMP-TECH-044'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;

// Associates → Engineer
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-TECH-025'}) WHERE e.employee_id >= 'EMP-TECH-045' AND e.employee_id <= 'EMP-TECH-060'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;

// Delivery structure
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-DEL-001'}) WHERE e.employee_id >= 'EMP-DEL-003' AND e.employee_id <= 'EMP-DEL-007'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-DEL-003'}) WHERE e.employee_id >= 'EMP-DEL-008' AND e.employee_id <= 'EMP-DEL-017'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-DEL-008'}) WHERE e.employee_id >= 'EMP-DEL-018' AND e.employee_id <= 'EMP-DEL-029'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-DEL-018'}) WHERE e.employee_id >= 'EMP-DEL-030' AND e.employee_id <= 'EMP-DEL-035'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;

// Sales structure
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-SAL-001'}) WHERE e.employee_id >= 'EMP-SAL-002' AND e.employee_id <= 'EMP-SAL-005'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-SAL-002'}) WHERE e.employee_id >= 'EMP-SAL-006' AND e.employee_id <= 'EMP-SAL-015'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-SAL-006'}) WHERE e.employee_id >= 'EMP-SAL-016' AND e.employee_id <= 'EMP-SAL-020'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;

// Marketing structure
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-MKT-001'}) WHERE e.employee_id >= 'EMP-MKT-002' AND e.employee_id <= 'EMP-MKT-004'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-MKT-002'}) WHERE e.employee_id >= 'EMP-MKT-005' AND e.employee_id <= 'EMP-MKT-012'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-MKT-005'}) WHERE e.employee_id >= 'EMP-MKT-013' AND e.employee_id <= 'EMP-MKT-015'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;

// HR structure
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-HR-002'}) WHERE e.employee_id >= 'EMP-HR-003' AND e.employee_id <= 'EMP-HR-004'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-HR-003'}) WHERE e.employee_id >= 'EMP-HR-005' AND e.employee_id <= 'EMP-HR-008'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-HR-005'}) WHERE e.employee_id >= 'EMP-HR-009' AND e.employee_id <= 'EMP-HR-010'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;

// Finance structure
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-FIN-002'}) WHERE e.employee_id >= 'EMP-FIN-003' AND e.employee_id <= 'EMP-FIN-004'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-FIN-003'}) WHERE e.employee_id >= 'EMP-FIN-005' AND e.employee_id <= 'EMP-FIN-009'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;
MATCH (e:Employee), (m:Employee {employee_id: 'EMP-FIN-005'}) WHERE e.employee_id >= 'EMP-FIN-010' AND e.employee_id <= 'EMP-FIN-012'
MERGE (e)-[r:REPORTS_TO]->(m) ON CREATE SET r.type = 'line', r.since = e.joining_date;

// ==================== PROJECT ASSIGNMENTS ====================
// NeuraVault (35 members)
MATCH (e:Employee {employee_id: 'EMP-TECH-002'}), (p:Project {project_id: 'PROJ-001'})
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'Tech Lead', r.start_date = date('2023-01-15'), r.end_date = null, r.is_current = true;
MATCH (e:Employee), (p:Project {project_id: 'PROJ-001'}) WHERE e.employee_id >= 'EMP-TECH-004' AND e.employee_id <= 'EMP-TECH-009'
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'PM/Architect', r.start_date = date('2023-01-15'), r.end_date = null, r.is_current = true;
MATCH (e:Employee), (p:Project {project_id: 'PROJ-001'}) WHERE e.employee_id >= 'EMP-TECH-010' AND e.employee_id <= 'EMP-TECH-029'
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'Engineer', r.start_date = date('2023-01-15'), r.end_date = null, r.is_current = true;
MATCH (e:Employee), (p:Project {project_id: 'PROJ-001'}) WHERE e.employee_id >= 'EMP-DEL-001' AND e.employee_id <= 'EMP-DEL-010'
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'Delivery Manager', r.start_date = date('2023-01-15'), r.end_date = null, r.is_current = true;

// SentinelAI (12 members)
MATCH (e:Employee), (p:Project {project_id: 'PROJ-002'}) WHERE e.employee_id >= 'EMP-TECH-004' AND e.employee_id <= 'EMP-TECH-005'
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'PM', r.start_date = date('2023-06-01'), r.end_date = null, r.is_current = true;
MATCH (e:Employee), (p:Project {project_id: 'PROJ-002'}) WHERE e.employee_id >= 'EMP-TECH-030' AND e.employee_id <= 'EMP-TECH-039'
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'Engineer', r.start_date = date('2023-06-01'), r.end_date = null, r.is_current = true;

// OrgPulse (8 members) — Shubham Chougale is here
MATCH (e:Employee {employee_id: 'EMP-TECH-010'}), (p:Project {project_id: 'PROJ-003'})
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'Senior Engineer', r.start_date = date('2024-08-01'), r.end_date = null, r.is_current = true;
MATCH (e:Employee), (p:Project {project_id: 'PROJ-003'}) WHERE e.employee_id >= 'EMP-TECH-025' AND e.employee_id <= 'EMP-TECH-031'
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'Engineer', r.start_date = date('2024-08-01'), r.end_date = null, r.is_current = true;

// DataBridge (10 members — completed)
MATCH (e:Employee), (p:Project {project_id: 'PROJ-004'}) WHERE e.employee_id >= 'EMP-TECH-006' AND e.employee_id <= 'EMP-TECH-015'
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'Engineer', r.start_date = date('2022-03-01'), r.end_date = date('2023-12-31'), r.is_current = false;

// MarketLens (6 members — completed)
MATCH (e:Employee), (p:Project {project_id: 'PROJ-005'}) WHERE e.employee_id >= 'EMP-SAL-006' AND e.employee_id <= 'EMP-SAL-011'
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'Business Analyst', r.start_date = date('2023-02-01'), r.end_date = date('2023-10-31'), r.is_current = false;

// TalentFlow (4 members — on hold)
MATCH (e:Employee), (p:Project {project_id: 'PROJ-006'}) WHERE e.employee_id >= 'EMP-HR-003' AND e.employee_id <= 'EMP-HR-004'
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'Product Owner', r.start_date = date('2024-01-15'), r.end_date = null, r.is_current = false;
MATCH (e:Employee), (p:Project {project_id: 'PROJ-006'}) WHERE e.employee_id >= 'EMP-TECH-032' AND e.employee_id <= 'EMP-TECH-033'
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'Full Stack Developer', r.start_date = date('2024-01-15'), r.end_date = null, r.is_current = false;

// CipherSec (9 members)
MATCH (e:Employee), (p:Project {project_id: 'PROJ-007'}) WHERE e.employee_id >= 'EMP-TECH-034' AND e.employee_id <= 'EMP-TECH-042'
MERGE (e)-[r:ASSIGNED_TO]->(p) ON CREATE SET r.role_in_project = 'DevOps/Security Engineer', r.start_date = date('2023-09-01'), r.end_date = null, r.is_current = true;

// ==================== SKILL RELATIONSHIPS ====================
// Shubham Chougale (EMP-TECH-010) — specific skills from spec
MATCH (e:Employee {employee_id: 'EMP-TECH-010'}), (s:Skill {skill_id: 'SKILL-001'}) MERGE (e)-[:HAS_SKILL {proficiency: 'expert', years: 4}]->(s);
MATCH (e:Employee {employee_id: 'EMP-TECH-010'}), (s:Skill {skill_id: 'SKILL-016'}) MERGE (e)-[:HAS_SKILL {proficiency: 'intermediate', years: 1}]->(s);
MATCH (e:Employee {employee_id: 'EMP-TECH-010'}), (s:Skill {skill_id: 'SKILL-032'}) MERGE (e)-[:HAS_SKILL {proficiency: 'intermediate', years: 0.5}]->(s);
MATCH (e:Employee {employee_id: 'EMP-TECH-010'}), (s:Skill {skill_id: 'SKILL-011'}) MERGE (e)-[:HAS_SKILL {proficiency: 'intermediate', years: 0.5}]->(s);
MATCH (e:Employee {employee_id: 'EMP-TECH-010'}), (s:Skill {skill_id: 'SKILL-007'}) MERGE (e)-[:HAS_SKILL {proficiency: 'beginner', years: 0}]->(s);

// Tech Head skills
MATCH (e:Employee {employee_id: 'EMP-TECH-002'}), (s:Skill {skill_id: 'SKILL-001'}) MERGE (e)-[:HAS_SKILL {proficiency: 'expert', years: 15}]->(s);
MATCH (e:Employee {employee_id: 'EMP-TECH-002'}), (s:Skill {skill_id: 'SKILL-016'}) MERGE (e)-[:HAS_SKILL {proficiency: 'expert', years: 8}]->(s);
MATCH (e:Employee {employee_id: 'EMP-TECH-002'}), (s:Skill {skill_id: 'SKILL-041'}) MERGE (e)-[:HAS_SKILL {proficiency: 'expert', years: 10}]->(s);

// Batch Python + Git skills for all Tech employees
MATCH (e:Employee), (s:Skill {skill_id: 'SKILL-001'}) WHERE e.employee_id STARTS WITH 'EMP-TECH-'
MERGE (e)-[r:HAS_SKILL]->(s) ON CREATE SET r.proficiency = 'intermediate', r.years = 3;
MATCH (e:Employee), (s:Skill {skill_id: 'SKILL-029'}) WHERE e.employee_id STARTS WITH 'EMP-TECH-'
MERGE (e)-[r:HAS_SKILL]->(s) ON CREATE SET r.proficiency = 'intermediate', r.years = 4;

// Problem Solving soft skill for all Tech employees
MATCH (e:Employee), (s:Skill {skill_id: 'SKILL-043'}) WHERE e.employee_id STARTS WITH 'EMP-TECH-'
MERGE (e)-[r:HAS_SKILL]->(s) ON CREATE SET r.proficiency = 'intermediate', r.years = 3;

// ==================== PROJECT FOR CLIENT RELATIONSHIPS ====================
MATCH (p:Project {project_id: 'PROJ-001'}), (c:Client {client_id: 'CLIENT-001'}) MERGE (p)-[:FOR_CLIENT]->(c);
MATCH (p:Project {project_id: 'PROJ-002'}), (c:Client {client_id: 'CLIENT-002'}) MERGE (p)-[:FOR_CLIENT]->(c);
MATCH (p:Project {project_id: 'PROJ-004'}), (c:Client {client_id: 'CLIENT-005'}) MERGE (p)-[:FOR_CLIENT]->(c);
MATCH (p:Project {project_id: 'PROJ-005'}), (c:Client {client_id: 'CLIENT-003'}) MERGE (p)-[:FOR_CLIENT]->(c);
MATCH (p:Project {project_id: 'PROJ-007'}), (c:Client {client_id: 'CLIENT-004'}) MERGE (p)-[:FOR_CLIENT]->(c);

// ==================== PROJECT MANAGEMENT RELATIONSHIPS ====================
MATCH (e:Employee {employee_id: 'EMP-TECH-002'}), (p:Project {project_id: 'PROJ-001'}) MERGE (e)-[:MANAGES_PROJECT]->(p);
MATCH (e:Employee {employee_id: 'EMP-TECH-002'}), (p:Project {project_id: 'PROJ-003'}) MERGE (e)-[:MANAGES_PROJECT]->(p);
MATCH (e:Employee {employee_id: 'EMP-DEL-001'}), (p:Project {project_id: 'PROJ-001'}) MERGE (e)-[:MANAGES_PROJECT]->(p);
MATCH (e:Employee {employee_id: 'EMP-TECH-004'}), (p:Project {project_id: 'PROJ-002'}) MERGE (e)-[:MANAGES_PROJECT]->(p);
MATCH (e:Employee {employee_id: 'EMP-TECH-005'}), (p:Project {project_id: 'PROJ-003'}) MERGE (e)-[:MANAGES_PROJECT]->(p);
MATCH (e:Employee {employee_id: 'EMP-TECH-007'}), (p:Project {project_id: 'PROJ-007'}) MERGE (e)-[:MANAGES_PROJECT]->(p);
