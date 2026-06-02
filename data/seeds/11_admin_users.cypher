// Add real users for system administrators / project owners.
// These users have full L1 admin access (HR department = sees all PII).

// Shubham Chougale — Owner / HR Admin
MERGE (e:Employee {employee_id: 'EMP-ADMIN-001'})
SET e.full_name = 'Shubham Chougale',
    e.email = 'shubham.chougale@coditas.com',
    e.phone = '+91-9999900001',
    e.dob = date('1996-08-15'),
    e.gender = 'Male',
    e.address = 'Pune, Maharashtra',
    e.employment_type = 'Full-time',
    e.joining_date = date('2024-01-01'),
    e.total_experience_years = 5.0,
    e.org_experience_years = 2.4,
    e.current_status = 'Active',
    e.profile_photo_url = null,
    e.created_at = datetime();

// Department link → HR (gives L1 admin access via derive_access_level)
MATCH (e:Employee {employee_id: 'EMP-ADMIN-001'}), (d:Department {dept_id: 'DEPT-005'})
MERGE (e)-[:BELONGS_TO {since: date('2024-01-01')}]->(d);

// Role link → HR Head (gives manager-level visibility)
MATCH (e:Employee {employee_id: 'EMP-ADMIN-001'}), (r:Role {role_id: 'ROLE-HR-002'})
MERGE (e)-[:HAS_ROLE {since: date('2024-01-01'), is_current: true}]->(r);

// Reports to CHO (Sheila Iyer)
MATCH (e:Employee {employee_id: 'EMP-ADMIN-001'}), (m:Employee {employee_id: 'EMP-HR-001'})
MERGE (e)-[:REPORTS_TO {type: 'line', since: date('2024-01-01')}]->(m);
