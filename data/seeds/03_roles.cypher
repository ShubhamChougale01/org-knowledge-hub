// Tech Department Roles
MERGE (r:Role {role_id: 'ROLE-TECH-001', title: 'CTO', level: 7, department: 'Tech'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-TECH-002', title: 'Tech Head', level: 6, department: 'Tech'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-TECH-003', title: 'Principal Engineer', level: 6, department: 'Tech'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-TECH-004', title: 'Engineering Manager', level: 5, department: 'Tech'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-TECH-005', title: 'Tech Lead', level: 5, department: 'Tech'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-TECH-006', title: 'Product Manager', level: 5, department: 'Tech'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-TECH-007', title: 'Senior Engineer', level: 4, department: 'Tech'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-TECH-008', title: 'Engineer', level: 3, department: 'Tech'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-TECH-009', title: 'Associate Engineer', level: 2, department: 'Tech'}) SET r.created_at = datetime();

// Delivery Department Roles
MERGE (r:Role {role_id: 'ROLE-DEL-001', title: 'Delivery Head', level: 6, department: 'Delivery'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-DEL-002', title: 'Delivery Manager', level: 5, department: 'Delivery'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-DEL-003', title: 'Project Manager', level: 5, department: 'Delivery'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-DEL-004', title: 'Senior Project Analyst', level: 4, department: 'Delivery'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-DEL-005', title: 'Project Analyst', level: 3, department: 'Delivery'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-DEL-006', title: 'Associate Analyst', level: 2, department: 'Delivery'}) SET r.created_at = datetime();

// Sales Department Roles
MERGE (r:Role {role_id: 'ROLE-SAL-001', title: 'Sales Head', level: 6, department: 'Sales'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-SAL-002', title: 'Sales Manager', level: 5, department: 'Sales'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-SAL-003', title: 'Account Executive', level: 4, department: 'Sales'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-SAL-004', title: 'Sales Associate', level: 2, department: 'Sales'}) SET r.created_at = datetime();

// Marketing Department Roles
MERGE (r:Role {role_id: 'ROLE-MKT-001', title: 'Marketing Head', level: 6, department: 'Marketing'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-MKT-002', title: 'Marketing Manager', level: 5, department: 'Marketing'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-MKT-003', title: 'Marketing Executive', level: 4, department: 'Marketing'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-MKT-004', title: 'Marketing Associate', level: 2, department: 'Marketing'}) SET r.created_at = datetime();

// HR Department Roles
MERGE (r:Role {role_id: 'ROLE-HR-001', title: 'Chief Human Resources Officer', level: 7, department: 'HR'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-HR-002', title: 'HR Head', level: 6, department: 'HR'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-HR-003', title: 'HR Manager', level: 5, department: 'HR'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-HR-004', title: 'HR Executive', level: 4, department: 'HR'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-HR-005', title: 'HR Associate', level: 2, department: 'HR'}) SET r.created_at = datetime();

// Finance Department Roles
MERGE (r:Role {role_id: 'ROLE-FIN-001', title: 'Chief Financial Officer', level: 7, department: 'Finance'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-FIN-002', title: 'Finance Head', level: 6, department: 'Finance'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-FIN-003', title: 'Finance Manager', level: 5, department: 'Finance'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-FIN-004', title: 'Financial Analyst', level: 3, department: 'Finance'}) SET r.created_at = datetime();
MERGE (r:Role {role_id: 'ROLE-FIN-005', title: 'Finance Associate', level: 2, department: 'Finance'}) SET r.created_at = datetime();

// Executive Department Roles
MERGE (r:Role {role_id: 'ROLE-EXE-001', title: 'CEO', level: 7, department: 'Executive'}) SET r.created_at = datetime();
