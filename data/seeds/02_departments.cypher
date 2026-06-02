// Create departments
MERGE (d1:Department {dept_id: 'DEPT-001', name: 'Tech', headcount: 60, description: 'Engineering and Technology'}) SET d1.created_at = datetime();
MERGE (d2:Department {dept_id: 'DEPT-002', name: 'Delivery', headcount: 35, description: 'Project Delivery and Operations'}) SET d2.created_at = datetime();
MERGE (d3:Department {dept_id: 'DEPT-003', name: 'Sales', headcount: 20, description: 'Sales and Business Development'}) SET d3.created_at = datetime();
MERGE (d4:Department {dept_id: 'DEPT-004', name: 'Marketing', headcount: 15, description: 'Marketing and Communications'}) SET d4.created_at = datetime();
MERGE (d5:Department {dept_id: 'DEPT-005', name: 'HR', headcount: 10, description: 'Human Resources'}) SET d5.created_at = datetime();
MERGE (d6:Department {dept_id: 'DEPT-006', name: 'Finance', headcount: 12, description: 'Finance and Accounting'}) SET d6.created_at = datetime();
MERGE (d7:Department {dept_id: 'DEPT-007', name: 'Executive', headcount: 3, description: 'C-Suite and Executive Leadership'}) SET d7.created_at = datetime();
