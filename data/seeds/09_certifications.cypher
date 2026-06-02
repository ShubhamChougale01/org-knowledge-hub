// CERTIFICATION NODES — one node per certificate instance per employee
// Shubham Chougale has Neo4j Certified Professional + AWS Certified Developer as required

// ==================== TECH DEPARTMENT ====================

// CTO — Arvind Patel
MERGE (c:Certification {cert_id: 'CERT-001'}) SET c.name = 'AWS Certified Solutions Architect', c.issuer = 'Amazon Web Services', c.issued_date = date('2020-03-15'), c.expiry_date = date('2023-03-15');
MERGE (c:Certification {cert_id: 'CERT-002'}) SET c.name = 'Google Cloud Professional Data Engineer', c.issuer = 'Google', c.issued_date = date('2021-05-20'), c.expiry_date = date('2023-05-20');
MATCH (e:Employee {full_name: 'Arvind Patel'}), (c:Certification {cert_id: 'CERT-001'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2020-03-15')}]->(c);
MATCH (e:Employee {full_name: 'Arvind Patel'}), (c:Certification {cert_id: 'CERT-002'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-05-20')}]->(c);

// Tech Head — Priya Verma
MERGE (c:Certification {cert_id: 'CERT-003'}) SET c.name = 'AWS Certified Solutions Architect', c.issuer = 'Amazon Web Services', c.issued_date = date('2021-01-10'), c.expiry_date = date('2024-01-10');
MERGE (c:Certification {cert_id: 'CERT-004'}) SET c.name = 'Neo4j Certified Professional', c.issuer = 'Neo4j', c.issued_date = date('2022-06-15'), c.expiry_date = null;
MERGE (c:Certification {cert_id: 'CERT-005'}) SET c.name = 'Certified Kubernetes Administrator', c.issuer = 'CNCF', c.issued_date = date('2022-09-20'), c.expiry_date = date('2025-09-20');
MATCH (e:Employee {full_name: 'Priya Verma'}), (c:Certification {cert_id: 'CERT-003'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-01-10')}]->(c);
MATCH (e:Employee {full_name: 'Priya Verma'}), (c:Certification {cert_id: 'CERT-004'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-06-15')}]->(c);
MATCH (e:Employee {full_name: 'Priya Verma'}), (c:Certification {cert_id: 'CERT-005'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-09-20')}]->(c);

// Tech Head — Vikram Singh
MERGE (c:Certification {cert_id: 'CERT-006'}) SET c.name = 'Google Cloud Professional Data Engineer', c.issuer = 'Google', c.issued_date = date('2021-03-25'), c.expiry_date = date('2023-03-25');
MERGE (c:Certification {cert_id: 'CERT-007'}) SET c.name = 'Docker Certified Associate', c.issuer = 'Mirantis', c.issued_date = date('2022-11-10'), c.expiry_date = date('2024-11-10');
MATCH (e:Employee {full_name: 'Vikram Singh'}), (c:Certification {cert_id: 'CERT-006'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-03-25')}]->(c);
MATCH (e:Employee {full_name: 'Vikram Singh'}), (c:Certification {cert_id: 'CERT-007'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-11-10')}]->(c);

// PM — Ananya Gupta
MERGE (c:Certification {cert_id: 'CERT-008'}) SET c.name = 'AWS Certified Developer', c.issuer = 'Amazon Web Services', c.issued_date = date('2022-07-15'), c.expiry_date = date('2025-07-15');
MERGE (c:Certification {cert_id: 'CERT-009'}) SET c.name = 'GitHub Actions CI/CD', c.issuer = 'GitHub', c.issued_date = date('2023-01-20'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Ananya Gupta'}), (c:Certification {cert_id: 'CERT-008'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-07-15')}]->(c);
MATCH (e:Employee {full_name: 'Ananya Gupta'}), (c:Certification {cert_id: 'CERT-009'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-01-20')}]->(c);

// PM — Ashok Desai
MERGE (c:Certification {cert_id: 'CERT-010'}) SET c.name = 'Azure AI Engineer Associate', c.issuer = 'Microsoft', c.issued_date = date('2022-09-10'), c.expiry_date = date('2024-09-10');
MERGE (c:Certification {cert_id: 'CERT-011'}) SET c.name = 'HashiCorp Terraform Associate', c.issuer = 'HashiCorp', c.issued_date = date('2023-03-15'), c.expiry_date = date('2025-03-15');
MATCH (e:Employee {full_name: 'Ashok Desai'}), (c:Certification {cert_id: 'CERT-010'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-09-10')}]->(c);
MATCH (e:Employee {full_name: 'Ashok Desai'}), (c:Certification {cert_id: 'CERT-011'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-03-15')}]->(c);

// PM — Kavya Reddy
MERGE (c:Certification {cert_id: 'CERT-012'}) SET c.name = 'AWS Certified Developer', c.issuer = 'Amazon Web Services', c.issued_date = date('2022-04-20'), c.expiry_date = date('2025-04-20');
MATCH (e:Employee {full_name: 'Kavya Reddy'}), (c:Certification {cert_id: 'CERT-012'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-04-20')}]->(c);

// PM — Rohit Nair
MERGE (c:Certification {cert_id: 'CERT-013'}) SET c.name = 'Certified Kubernetes Administrator', c.issuer = 'CNCF', c.issued_date = date('2021-11-15'), c.expiry_date = date('2024-11-15');
MERGE (c:Certification {cert_id: 'CERT-014'}) SET c.name = 'Docker Certified Associate', c.issuer = 'Mirantis', c.issued_date = date('2022-05-10'), c.expiry_date = date('2024-05-10');
MATCH (e:Employee {full_name: 'Rohit Nair'}), (c:Certification {cert_id: 'CERT-013'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-11-15')}]->(c);
MATCH (e:Employee {full_name: 'Rohit Nair'}), (c:Certification {cert_id: 'CERT-014'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-05-10')}]->(c);

// PM — Shreya Singh
MERGE (c:Certification {cert_id: 'CERT-015'}) SET c.name = 'Azure AI Engineer Associate', c.issuer = 'Microsoft', c.issued_date = date('2023-02-20'), c.expiry_date = date('2025-02-20');
MATCH (e:Employee {full_name: 'Shreya Singh'}), (c:Certification {cert_id: 'CERT-015'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-02-20')}]->(c);

// PM — Nikhil Joshi
MERGE (c:Certification {cert_id: 'CERT-016'}) SET c.name = 'Google Cloud Professional Data Engineer', c.issuer = 'Google', c.issued_date = date('2022-08-15'), c.expiry_date = date('2024-08-15');
MERGE (c:Certification {cert_id: 'CERT-017'}) SET c.name = 'GitHub Actions CI/CD', c.issuer = 'GitHub', c.issued_date = date('2023-04-10'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Nikhil Joshi'}), (c:Certification {cert_id: 'CERT-016'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-08-15')}]->(c);
MATCH (e:Employee {full_name: 'Nikhil Joshi'}), (c:Certification {cert_id: 'CERT-017'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-04-10')}]->(c);

// Shubham Chougale — REQUIRED: Neo4j Certified Professional + AWS Certified Developer
MERGE (c:Certification {cert_id: 'CERT-018'}) SET c.name = 'Neo4j Certified Professional', c.issuer = 'Neo4j', c.issued_date = date('2024-03-15'), c.expiry_date = null;
MERGE (c:Certification {cert_id: 'CERT-019'}) SET c.name = 'AWS Certified Developer', c.issuer = 'Amazon Web Services', c.issued_date = date('2023-08-20'), c.expiry_date = date('2026-08-20');
MATCH (e:Employee {full_name: 'Shubham Chougale'}), (c:Certification {cert_id: 'CERT-018'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2024-03-15')}]->(c);
MATCH (e:Employee {full_name: 'Shubham Chougale'}), (c:Certification {cert_id: 'CERT-019'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-08-20')}]->(c);

// Senior Engineers
MERGE (c:Certification {cert_id: 'CERT-020'}) SET c.name = 'AWS Certified Solutions Architect', c.issuer = 'Amazon Web Services', c.issued_date = date('2022-06-10'), c.expiry_date = date('2025-06-10');
MERGE (c:Certification {cert_id: 'CERT-021'}) SET c.name = 'Neo4j Certified Professional', c.issuer = 'Neo4j', c.issued_date = date('2023-01-15'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Mohan Rao'}), (c:Certification {cert_id: 'CERT-020'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-06-10')}]->(c);
MATCH (e:Employee {full_name: 'Mohan Rao'}), (c:Certification {cert_id: 'CERT-021'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-01-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-022'}) SET c.name = 'Google Cloud Professional Data Engineer', c.issuer = 'Google', c.issued_date = date('2022-09-20'), c.expiry_date = date('2024-09-20');
MATCH (e:Employee {full_name: 'Divya Iyer'}), (c:Certification {cert_id: 'CERT-022'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-09-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-023'}) SET c.name = 'AWS Certified Developer', c.issuer = 'Amazon Web Services', c.issued_date = date('2022-03-15'), c.expiry_date = date('2025-03-15');
MATCH (e:Employee {full_name: 'Sanjay Chopra'}), (c:Certification {cert_id: 'CERT-023'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-03-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-024'}) SET c.name = 'GitHub Actions CI/CD', c.issuer = 'GitHub', c.issued_date = date('2023-05-20'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Anjali Mishra'}), (c:Certification {cert_id: 'CERT-024'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-05-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-025'}) SET c.name = 'Docker Certified Associate', c.issuer = 'Mirantis', c.issued_date = date('2022-11-10'), c.expiry_date = date('2024-11-10');
MATCH (e:Employee {full_name: 'Aditya Sinha'}), (c:Certification {cert_id: 'CERT-025'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-11-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-026'}) SET c.name = 'AWS Certified Developer', c.issuer = 'Amazon Web Services', c.issued_date = date('2023-02-15'), c.expiry_date = date('2026-02-15');
MATCH (e:Employee {full_name: 'Renu Pandey'}), (c:Certification {cert_id: 'CERT-026'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-02-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-027'}) SET c.name = 'Certified Kubernetes Administrator', c.issuer = 'CNCF', c.issued_date = date('2022-07-20'), c.expiry_date = date('2025-07-20');
MATCH (e:Employee {full_name: 'Mahesh Trivedi'}), (c:Certification {cert_id: 'CERT-027'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-07-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-028'}) SET c.name = 'Azure AI Engineer Associate', c.issuer = 'Microsoft', c.issued_date = date('2023-06-15'), c.expiry_date = date('2025-06-15');
MATCH (e:Employee {full_name: 'Swati Saxena'}), (c:Certification {cert_id: 'CERT-028'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-06-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-029'}) SET c.name = 'MongoDB Associate Developer', c.issuer = 'MongoDB', c.issued_date = date('2022-10-10'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Rajesh Bhat'}), (c:Certification {cert_id: 'CERT-029'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-10-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-030'}) SET c.name = 'Redis Certified Developer', c.issuer = 'Redis Labs', c.issued_date = date('2023-04-15'), c.expiry_date = date('2025-04-15');
MATCH (e:Employee {full_name: 'Meera Banerjee'}), (c:Certification {cert_id: 'CERT-030'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-04-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-031'}) SET c.name = 'AWS Certified Solutions Architect', c.issuer = 'Amazon Web Services', c.issued_date = date('2023-01-20'), c.expiry_date = date('2026-01-20');
MATCH (e:Employee {full_name: 'Vikram Menon'}), (c:Certification {cert_id: 'CERT-031'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-01-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-032'}) SET c.name = 'GitHub Actions CI/CD', c.issuer = 'GitHub', c.issued_date = date('2023-08-10'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Neha Kapoor'}), (c:Certification {cert_id: 'CERT-032'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-08-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-033'}) SET c.name = 'Google Cloud Professional Data Engineer', c.issuer = 'Google', c.issued_date = date('2022-12-15'), c.expiry_date = date('2024-12-15');
MATCH (e:Employee {full_name: 'Abhishek Kumar'}), (c:Certification {cert_id: 'CERT-033'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-12-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-034'}) SET c.name = 'Microsoft Azure Fundamentals', c.issuer = 'Microsoft', c.issued_date = date('2023-03-20'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Pooja Verma'}), (c:Certification {cert_id: 'CERT-034'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-03-20')}]->(c);

// Engineers
MERGE (c:Certification {cert_id: 'CERT-035'}) SET c.name = 'AWS Certified Developer', c.issuer = 'Amazon Web Services', c.issued_date = date('2023-06-10'), c.expiry_date = date('2026-06-10');
MATCH (e:Employee {full_name: 'Rahul Singh'}), (c:Certification {cert_id: 'CERT-035'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-06-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-036'}) SET c.name = 'Google Cloud Professional Data Engineer', c.issuer = 'Google', c.issued_date = date('2023-09-15'), c.expiry_date = date('2025-09-15');
MATCH (e:Employee {full_name: 'Deepika Nair'}), (c:Certification {cert_id: 'CERT-036'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-09-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-037'}) SET c.name = 'Docker Certified Associate', c.issuer = 'Mirantis', c.issued_date = date('2023-04-20'), c.expiry_date = date('2025-04-20');
MATCH (e:Employee {full_name: 'Sameer Patel'}), (c:Certification {cert_id: 'CERT-037'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-04-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-038'}) SET c.name = 'GitHub Actions CI/CD', c.issuer = 'GitHub', c.issued_date = date('2024-01-15'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Isha Sharma'}), (c:Certification {cert_id: 'CERT-038'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2024-01-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-039'}) SET c.name = 'AWS Certified Developer', c.issuer = 'Amazon Web Services', c.issued_date = date('2023-11-10'), c.expiry_date = date('2026-11-10');
MATCH (e:Employee {full_name: 'Varun Rao'}), (c:Certification {cert_id: 'CERT-039'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-11-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-040'}) SET c.name = 'Certified Kubernetes Administrator', c.issuer = 'CNCF', c.issued_date = date('2023-07-20'), c.expiry_date = date('2026-07-20');
MATCH (e:Employee {full_name: 'Arjun Desai'}), (c:Certification {cert_id: 'CERT-040'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-07-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-041'}) SET c.name = 'Microsoft Azure Fundamentals', c.issuer = 'Microsoft', c.issued_date = date('2024-02-15'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Tina Singh'}), (c:Certification {cert_id: 'CERT-041'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2024-02-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-042'}) SET c.name = 'AWS Certified Solutions Architect', c.issuer = 'Amazon Web Services', c.issued_date = date('2023-05-10'), c.expiry_date = date('2026-05-10');
MATCH (e:Employee {full_name: 'Praveen Kumar'}), (c:Certification {cert_id: 'CERT-042'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-05-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-043'}) SET c.name = 'Google Cloud Professional Data Engineer', c.issuer = 'Google', c.issued_date = date('2024-01-20'), c.expiry_date = date('2026-01-20');
MATCH (e:Employee {full_name: 'Rupali Reddy'}), (c:Certification {cert_id: 'CERT-043'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2024-01-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-044'}) SET c.name = 'Docker Certified Associate', c.issuer = 'Mirantis', c.issued_date = date('2023-10-15'), c.expiry_date = date('2025-10-15');
MATCH (e:Employee {full_name: 'Manoj Verma'}), (c:Certification {cert_id: 'CERT-044'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-10-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-045'}) SET c.name = 'HashiCorp Terraform Associate', c.issuer = 'HashiCorp', c.issued_date = date('2023-08-20'), c.expiry_date = date('2025-08-20');
MATCH (e:Employee {full_name: 'Rohan Sharma'}), (c:Certification {cert_id: 'CERT-045'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-08-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-046'}) SET c.name = 'AWS Certified Developer', c.issuer = 'Amazon Web Services', c.issued_date = date('2023-12-10'), c.expiry_date = date('2026-12-10');
MATCH (e:Employee {full_name: 'Sandeep Reddy'}), (c:Certification {cert_id: 'CERT-046'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-12-10')}]->(c);

// Associates — selected few
MERGE (c:Certification {cert_id: 'CERT-047'}) SET c.name = 'AWS Certified Developer', c.issuer = 'Amazon Web Services', c.issued_date = date('2024-03-10'), c.expiry_date = date('2027-03-10');
MATCH (e:Employee {full_name: 'Akshay Patel'}), (c:Certification {cert_id: 'CERT-047'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2024-03-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-048'}) SET c.name = 'GitHub Actions CI/CD', c.issuer = 'GitHub', c.issued_date = date('2024-04-15'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Manisha Verma'}), (c:Certification {cert_id: 'CERT-048'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2024-04-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-049'}) SET c.name = 'Microsoft Azure Fundamentals', c.issuer = 'Microsoft', c.issued_date = date('2024-02-20'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Harshit Gupta'}), (c:Certification {cert_id: 'CERT-049'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2024-02-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-050'}) SET c.name = 'MongoDB Associate Developer', c.issuer = 'MongoDB', c.issued_date = date('2024-05-10'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Nikita Desai'}), (c:Certification {cert_id: 'CERT-050'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2024-05-10')}]->(c);

// ==================== DELIVERY DEPARTMENT ====================

// Delivery Heads
MERGE (c:Certification {cert_id: 'CERT-051'}) SET c.name = 'Project Management Professional', c.issuer = 'PMI', c.issued_date = date('2019-08-15'), c.expiry_date = date('2022-08-15');
MERGE (c:Certification {cert_id: 'CERT-052'}) SET c.name = 'PRINCE2 Practitioner', c.issuer = 'Axelos', c.issued_date = date('2020-03-20'), c.expiry_date = date('2025-03-20');
MATCH (e:Employee {full_name: 'Satish Rao'}), (c:Certification {cert_id: 'CERT-051'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2019-08-15')}]->(c);
MATCH (e:Employee {full_name: 'Satish Rao'}), (c:Certification {cert_id: 'CERT-052'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2020-03-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-053'}) SET c.name = 'Project Management Professional', c.issuer = 'PMI', c.issued_date = date('2020-06-10'), c.expiry_date = date('2023-06-10');
MERGE (c:Certification {cert_id: 'CERT-054'}) SET c.name = 'SAFe Agilist', c.issuer = 'Scaled Agile', c.issued_date = date('2021-09-15'), c.expiry_date = date('2022-09-15');
MATCH (e:Employee {full_name: 'Meena Yadav'}), (c:Certification {cert_id: 'CERT-053'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2020-06-10')}]->(c);
MATCH (e:Employee {full_name: 'Meena Yadav'}), (c:Certification {cert_id: 'CERT-054'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-09-15')}]->(c);

// PMs
MERGE (c:Certification {cert_id: 'CERT-055'}) SET c.name = 'Project Management Professional', c.issuer = 'PMI', c.issued_date = date('2020-11-20'), c.expiry_date = date('2023-11-20');
MERGE (c:Certification {cert_id: 'CERT-056'}) SET c.name = 'Certified Scrum Master', c.issuer = 'Scrum Alliance', c.issued_date = date('2021-05-15'), c.expiry_date = date('2023-05-15');
MATCH (e:Employee {full_name: 'Vikram Mittal'}), (c:Certification {cert_id: 'CERT-055'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2020-11-20')}]->(c);
MATCH (e:Employee {full_name: 'Vikram Mittal'}), (c:Certification {cert_id: 'CERT-056'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-05-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-057'}) SET c.name = 'PRINCE2 Practitioner', c.issuer = 'Axelos', c.issued_date = date('2021-02-10'), c.expiry_date = date('2026-02-10');
MATCH (e:Employee {full_name: 'Anjaly Mohta'}), (c:Certification {cert_id: 'CERT-057'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-02-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-058'}) SET c.name = 'Project Management Professional', c.issuer = 'PMI', c.issued_date = date('2021-07-20'), c.expiry_date = date('2024-07-20');
MATCH (e:Employee {full_name: 'Rajesh Kumaran'}), (c:Certification {cert_id: 'CERT-058'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-07-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-059'}) SET c.name = 'Certified Scrum Master', c.issuer = 'Scrum Alliance', c.issued_date = date('2022-01-15'), c.expiry_date = date('2024-01-15');
MATCH (e:Employee {full_name: 'Priya Nambiar'}), (c:Certification {cert_id: 'CERT-059'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-01-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-060'}) SET c.name = 'PRINCE2 Practitioner', c.issuer = 'Axelos', c.issued_date = date('2020-09-10'), c.expiry_date = date('2025-09-10');
MERGE (c:Certification {cert_id: 'CERT-061'}) SET c.name = 'SAFe Agilist', c.issuer = 'Scaled Agile', c.issued_date = date('2021-11-20'), c.expiry_date = date('2022-11-20');
MATCH (e:Employee {full_name: 'Anil Chakraborty'}), (c:Certification {cert_id: 'CERT-060'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2020-09-10')}]->(c);
MATCH (e:Employee {full_name: 'Anil Chakraborty'}), (c:Certification {cert_id: 'CERT-061'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-11-20')}]->(c);

// Senior Analysts
MERGE (c:Certification {cert_id: 'CERT-062'}) SET c.name = 'Certified Scrum Master', c.issuer = 'Scrum Alliance', c.issued_date = date('2021-08-15'), c.expiry_date = date('2023-08-15');
MATCH (e:Employee {full_name: 'Shreya Dutta'}), (c:Certification {cert_id: 'CERT-062'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-08-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-063'}) SET c.name = 'SAFe Agilist', c.issuer = 'Scaled Agile', c.issued_date = date('2022-03-10'), c.expiry_date = date('2023-03-10');
MATCH (e:Employee {full_name: 'Ravi Shankar'}), (c:Certification {cert_id: 'CERT-063'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-03-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-064'}) SET c.name = 'ITIL 4 Foundation', c.issuer = 'PeopleCert', c.issued_date = date('2021-11-20'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Divya Menon'}), (c:Certification {cert_id: 'CERT-064'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-11-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-065'}) SET c.name = 'Certified Scrum Master', c.issuer = 'Scrum Alliance', c.issued_date = date('2022-06-15'), c.expiry_date = date('2024-06-15');
MATCH (e:Employee {full_name: 'Arun Gupta'}), (c:Certification {cert_id: 'CERT-065'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-06-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-066'}) SET c.name = 'SAFe Agilist', c.issuer = 'Scaled Agile', c.issued_date = date('2022-09-10'), c.expiry_date = date('2023-09-10');
MATCH (e:Employee {full_name: 'Ganesh Iyer'}), (c:Certification {cert_id: 'CERT-066'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-09-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-067'}) SET c.name = 'ITIL 4 Foundation', c.issuer = 'PeopleCert', c.issued_date = date('2021-07-15'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Srinivas Rao'}), (c:Certification {cert_id: 'CERT-067'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-07-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-068'}) SET c.name = 'Certified Scrum Master', c.issuer = 'Scrum Alliance', c.issued_date = date('2022-01-20'), c.expiry_date = date('2024-01-20');
MATCH (e:Employee {full_name: 'Ramesh Patel'}), (c:Certification {cert_id: 'CERT-068'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-01-20')}]->(c);

// Analysts
MERGE (c:Certification {cert_id: 'CERT-069'}) SET c.name = 'ITIL 4 Foundation', c.issuer = 'PeopleCert', c.issued_date = date('2022-10-15'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Savita Das'}), (c:Certification {cert_id: 'CERT-069'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-10-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-070'}) SET c.name = 'Certified Agile Project Manager', c.issuer = 'IIL', c.issued_date = date('2023-02-10'), c.expiry_date = date('2026-02-10');
MATCH (e:Employee {full_name: 'Arjun Prabhu'}), (c:Certification {cert_id: 'CERT-070'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-02-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-071'}) SET c.name = 'ITIL 4 Foundation', c.issuer = 'PeopleCert', c.issued_date = date('2023-05-15'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Vikrant Yadav'}), (c:Certification {cert_id: 'CERT-071'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-05-15')}]->(c);

// ==================== HR DEPARTMENT ====================

MERGE (c:Certification {cert_id: 'CERT-072'}) SET c.name = 'SHRM-SCP', c.issuer = 'SHRM', c.issued_date = date('2019-06-15'), c.expiry_date = date('2022-06-15');
MERGE (c:Certification {cert_id: 'CERT-073'}) SET c.name = 'SPHR', c.issuer = 'HRCI', c.issued_date = date('2020-01-20'), c.expiry_date = date('2023-01-20');
MATCH (e:Employee {full_name: 'Sheila Iyer'}), (c:Certification {cert_id: 'CERT-072'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2019-06-15')}]->(c);
MATCH (e:Employee {full_name: 'Sheila Iyer'}), (c:Certification {cert_id: 'CERT-073'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2020-01-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-074'}) SET c.name = 'SHRM-CP', c.issuer = 'SHRM', c.issued_date = date('2020-09-10'), c.expiry_date = date('2023-09-10');
MERGE (c:Certification {cert_id: 'CERT-075'}) SET c.name = 'PHR', c.issuer = 'HRCI', c.issued_date = date('2021-03-15'), c.expiry_date = date('2024-03-15');
MATCH (e:Employee {full_name: 'Vikram Desai'}), (c:Certification {cert_id: 'CERT-074'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2020-09-10')}]->(c);
MATCH (e:Employee {full_name: 'Vikram Desai'}), (c:Certification {cert_id: 'CERT-075'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-03-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-076'}) SET c.name = 'SHRM-CP', c.issuer = 'SHRM', c.issued_date = date('2021-11-20'), c.expiry_date = date('2024-11-20');
MATCH (e:Employee {full_name: 'Priya Sinha'}), (c:Certification {cert_id: 'CERT-076'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-11-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-077'}) SET c.name = 'PHR', c.issuer = 'HRCI', c.issued_date = date('2022-04-10'), c.expiry_date = date('2025-04-10');
MATCH (e:Employee {full_name: 'Ramesh Gupta'}), (c:Certification {cert_id: 'CERT-077'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-04-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-078'}) SET c.name = 'LinkedIn Certified Recruiter', c.issuer = 'LinkedIn', c.issued_date = date('2022-08-15'), c.expiry_date = date('2024-08-15');
MATCH (e:Employee {full_name: 'Sneha Verma'}), (c:Certification {cert_id: 'CERT-078'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-08-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-079'}) SET c.name = 'HR Analytics Certificate', c.issuer = 'HRCI', c.issued_date = date('2022-10-20'), c.expiry_date = date('2024-10-20');
MATCH (e:Employee {full_name: 'Arun Nair'}), (c:Certification {cert_id: 'CERT-079'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-10-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-080'}) SET c.name = 'LinkedIn Certified Recruiter', c.issuer = 'LinkedIn', c.issued_date = date('2023-01-15'), c.expiry_date = date('2025-01-15');
MATCH (e:Employee {full_name: 'Divya Sharma'}), (c:Certification {cert_id: 'CERT-080'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-01-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-081'}) SET c.name = 'HR Analytics Certificate', c.issuer = 'HRCI', c.issued_date = date('2023-03-10'), c.expiry_date = date('2025-03-10');
MATCH (e:Employee {full_name: 'Sanjiv Rao'}), (c:Certification {cert_id: 'CERT-081'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-03-10')}]->(c);

// ==================== SALES DEPARTMENT ====================

MERGE (c:Certification {cert_id: 'CERT-082'}) SET c.name = 'Salesforce Certified Administrator', c.issuer = 'Salesforce', c.issued_date = date('2020-05-15'), c.expiry_date = date('2021-05-15');
MERGE (c:Certification {cert_id: 'CERT-083'}) SET c.name = 'Certified Inside Sales Professional', c.issuer = 'AA-ISP', c.issued_date = date('2021-02-20'), c.expiry_date = date('2023-02-20');
MATCH (e:Employee {full_name: 'Karan Bhatnagar'}), (c:Certification {cert_id: 'CERT-082'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2020-05-15')}]->(c);
MATCH (e:Employee {full_name: 'Karan Bhatnagar'}), (c:Certification {cert_id: 'CERT-083'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-02-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-084'}) SET c.name = 'Salesforce Sales Cloud Consultant', c.issuer = 'Salesforce', c.issued_date = date('2021-08-10'), c.expiry_date = date('2022-08-10');
MATCH (e:Employee {full_name: 'Priya Malhotra'}), (c:Certification {cert_id: 'CERT-084'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-08-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-085'}) SET c.name = 'Certified Inside Sales Professional', c.issuer = 'AA-ISP', c.issued_date = date('2022-01-15'), c.expiry_date = date('2024-01-15');
MATCH (e:Employee {full_name: 'Rajesh Mittal'}), (c:Certification {cert_id: 'CERT-085'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-01-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-086'}) SET c.name = 'Salesforce Certified Administrator', c.issuer = 'Salesforce', c.issued_date = date('2022-06-20'), c.expiry_date = date('2023-06-20');
MATCH (e:Employee {full_name: 'Anita Sharma'}), (c:Certification {cert_id: 'CERT-086'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-06-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-087'}) SET c.name = 'Salesforce Sales Cloud Consultant', c.issuer = 'Salesforce', c.issued_date = date('2022-10-10'), c.expiry_date = date('2023-10-10');
MATCH (e:Employee {full_name: 'Aditya Agrawal'}), (c:Certification {cert_id: 'CERT-087'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-10-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-088'}) SET c.name = 'HubSpot Sales Software', c.issuer = 'HubSpot', c.issued_date = date('2022-03-15'), c.expiry_date = date('2023-03-15');
MATCH (e:Employee {full_name: 'Sneha Kulkarni'}), (c:Certification {cert_id: 'CERT-088'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-03-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-089'}) SET c.name = 'HubSpot Inbound Sales', c.issuer = 'HubSpot', c.issued_date = date('2022-07-20'), c.expiry_date = date('2023-07-20');
MATCH (e:Employee {full_name: 'Sunil Rao'}), (c:Certification {cert_id: 'CERT-089'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-07-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-090'}) SET c.name = 'Google Ads Certification', c.issuer = 'Google', c.issued_date = date('2023-01-10'), c.expiry_date = date('2024-01-10');
MATCH (e:Employee {full_name: 'Nivedita Singh'}), (c:Certification {cert_id: 'CERT-090'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-01-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-091'}) SET c.name = 'HubSpot Sales Software', c.issuer = 'HubSpot', c.issued_date = date('2022-11-15'), c.expiry_date = date('2023-11-15');
MATCH (e:Employee {full_name: 'Vikas Pandey'}), (c:Certification {cert_id: 'CERT-091'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-11-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-092'}) SET c.name = 'HubSpot Inbound Sales', c.issuer = 'HubSpot', c.issued_date = date('2023-04-20'), c.expiry_date = date('2024-04-20');
MATCH (e:Employee {full_name: 'Rashmi Gupta'}), (c:Certification {cert_id: 'CERT-092'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-04-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-093'}) SET c.name = 'Google Ads Certification', c.issuer = 'Google', c.issued_date = date('2023-02-15'), c.expiry_date = date('2024-02-15');
MATCH (e:Employee {full_name: 'Prakash Verma'}), (c:Certification {cert_id: 'CERT-093'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-02-15')}]->(c);

// ==================== MARKETING DEPARTMENT ====================

MERGE (c:Certification {cert_id: 'CERT-094'}) SET c.name = 'Google Analytics 4', c.issuer = 'Google', c.issued_date = date('2022-01-15'), c.expiry_date = date('2023-01-15');
MERGE (c:Certification {cert_id: 'CERT-095'}) SET c.name = 'Certified Digital Marketing Professional', c.issuer = 'Digital Marketing Institute', c.issued_date = date('2021-06-20'), c.expiry_date = date('2024-06-20');
MERGE (c:Certification {cert_id: 'CERT-096'}) SET c.name = 'HubSpot Content Marketing', c.issuer = 'HubSpot', c.issued_date = date('2022-09-10'), c.expiry_date = date('2023-09-10');
MATCH (e:Employee {full_name: 'Shreya Patel'}), (c:Certification {cert_id: 'CERT-094'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-01-15')}]->(c);
MATCH (e:Employee {full_name: 'Shreya Patel'}), (c:Certification {cert_id: 'CERT-095'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-06-20')}]->(c);
MATCH (e:Employee {full_name: 'Shreya Patel'}), (c:Certification {cert_id: 'CERT-096'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-09-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-097'}) SET c.name = 'Google Analytics 4', c.issuer = 'Google', c.issued_date = date('2022-04-15'), c.expiry_date = date('2023-04-15');
MERGE (c:Certification {cert_id: 'CERT-098'}) SET c.name = 'SEMrush SEO Toolkit', c.issuer = 'SEMrush', c.issued_date = date('2022-10-20'), c.expiry_date = date('2023-10-20');
MATCH (e:Employee {full_name: 'Arjun Mittal'}), (c:Certification {cert_id: 'CERT-097'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-04-15')}]->(c);
MATCH (e:Employee {full_name: 'Arjun Mittal'}), (c:Certification {cert_id: 'CERT-098'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-10-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-099'}) SET c.name = 'Google Analytics 4', c.issuer = 'Google', c.issued_date = date('2023-01-10'), c.expiry_date = date('2024-01-10');
MERGE (c:Certification {cert_id: 'CERT-100'}) SET c.name = 'Meta Blueprint Certification', c.issuer = 'Meta', c.issued_date = date('2022-08-15'), c.expiry_date = date('2023-08-15');
MATCH (e:Employee {full_name: 'Kavya Desai'}), (c:Certification {cert_id: 'CERT-099'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-01-10')}]->(c);
MATCH (e:Employee {full_name: 'Kavya Desai'}), (c:Certification {cert_id: 'CERT-100'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-08-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-101'}) SET c.name = 'Google Ads Search', c.issuer = 'Google', c.issued_date = date('2022-06-20'), c.expiry_date = date('2023-06-20');
MERGE (c:Certification {cert_id: 'CERT-102'}) SET c.name = 'Google Analytics 4', c.issuer = 'Google', c.issued_date = date('2022-11-10'), c.expiry_date = date('2023-11-10');
MATCH (e:Employee {full_name: 'Nikhil Sharma'}), (c:Certification {cert_id: 'CERT-101'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-06-20')}]->(c);
MATCH (e:Employee {full_name: 'Nikhil Sharma'}), (c:Certification {cert_id: 'CERT-102'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-11-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-103'}) SET c.name = 'HubSpot Content Marketing', c.issuer = 'HubSpot', c.issued_date = date('2023-02-15'), c.expiry_date = date('2024-02-15');
MATCH (e:Employee {full_name: 'Divya Singh'}), (c:Certification {cert_id: 'CERT-103'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-02-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-104'}) SET c.name = 'Hootsuite Social Marketing', c.issuer = 'Hootsuite', c.issued_date = date('2023-05-10'), c.expiry_date = date('2024-05-10');
MATCH (e:Employee {full_name: 'Sanjay Verma'}), (c:Certification {cert_id: 'CERT-104'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-05-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-105'}) SET c.name = 'Google Ads Search', c.issuer = 'Google', c.issued_date = date('2023-03-20'), c.expiry_date = date('2024-03-20');
MATCH (e:Employee {full_name: 'Neha Iyer'}), (c:Certification {cert_id: 'CERT-105'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-03-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-106'}) SET c.name = 'SEMrush SEO Toolkit', c.issuer = 'SEMrush', c.issued_date = date('2023-01-15'), c.expiry_date = date('2024-01-15');
MATCH (e:Employee {full_name: 'Rajesh Chopra'}), (c:Certification {cert_id: 'CERT-106'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-01-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-107'}) SET c.name = 'HubSpot Email Marketing', c.issuer = 'HubSpot', c.issued_date = date('2023-06-10'), c.expiry_date = date('2024-06-10');
MATCH (e:Employee {full_name: 'Priya Yadav'}), (c:Certification {cert_id: 'CERT-107'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-06-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-108'}) SET c.name = 'Meta Blueprint Certification', c.issuer = 'Meta', c.issued_date = date('2023-04-15'), c.expiry_date = date('2024-04-15');
MATCH (e:Employee {full_name: 'Vikram Rao'}), (c:Certification {cert_id: 'CERT-108'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-04-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-109'}) SET c.name = 'Hootsuite Social Marketing', c.issuer = 'Hootsuite', c.issued_date = date('2023-07-20'), c.expiry_date = date('2024-07-20');
MATCH (e:Employee {full_name: 'Sneha Patel'}), (c:Certification {cert_id: 'CERT-109'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-07-20')}]->(c);

// ==================== FINANCE DEPARTMENT ====================

MERGE (c:Certification {cert_id: 'CERT-110'}) SET c.name = 'CFA Level 3', c.issuer = 'CFA Institute', c.issued_date = date('2019-09-15'), c.expiry_date = null;
MERGE (c:Certification {cert_id: 'CERT-111'}) SET c.name = 'CPA', c.issuer = 'AICPA', c.issued_date = date('2020-03-20'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Sudhir Verma'}), (c:Certification {cert_id: 'CERT-110'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2019-09-15')}]->(c);
MATCH (e:Employee {full_name: 'Sudhir Verma'}), (c:Certification {cert_id: 'CERT-111'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2020-03-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-112'}) SET c.name = 'CFA Level 2', c.issuer = 'CFA Institute', c.issued_date = date('2020-11-10'), c.expiry_date = null;
MERGE (c:Certification {cert_id: 'CERT-113'}) SET c.name = 'Certified Management Accountant', c.issuer = 'IMA', c.issued_date = date('2021-05-15'), c.expiry_date = date('2024-05-15');
MATCH (e:Employee {full_name: 'Anjali Saxena'}), (c:Certification {cert_id: 'CERT-112'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2020-11-10')}]->(c);
MATCH (e:Employee {full_name: 'Anjali Saxena'}), (c:Certification {cert_id: 'CERT-113'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-05-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-114'}) SET c.name = 'Certified Management Accountant', c.issuer = 'IMA', c.issued_date = date('2022-02-20'), c.expiry_date = date('2025-02-20');
MATCH (e:Employee {full_name: 'Rakesh Kumar'}), (c:Certification {cert_id: 'CERT-114'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-02-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-115'}) SET c.name = 'Financial Risk Manager', c.issuer = 'GARP', c.issued_date = date('2022-07-15'), c.expiry_date = date('2024-07-15');
MATCH (e:Employee {full_name: 'Laxmi Desai'}), (c:Certification {cert_id: 'CERT-115'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-07-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-116'}) SET c.name = 'ACCA', c.issuer = 'ACCA Global', c.issued_date = date('2021-09-10'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Priya Menon'}), (c:Certification {cert_id: 'CERT-116'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2021-09-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-117'}) SET c.name = 'Excel VBA for Finance', c.issuer = 'Coursera', c.issued_date = date('2022-04-20'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Sunder Rao'}), (c:Certification {cert_id: 'CERT-117'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-04-20')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-118'}) SET c.name = 'ACCA', c.issuer = 'ACCA Global', c.issued_date = date('2022-08-15'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Deepa Sharma'}), (c:Certification {cert_id: 'CERT-118'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-08-15')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-119'}) SET c.name = 'CFA Level 1', c.issuer = 'CFA Institute', c.issued_date = date('2022-12-10'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Mohan Singh'}), (c:Certification {cert_id: 'CERT-119'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2022-12-10')}]->(c);

MERGE (c:Certification {cert_id: 'CERT-120'}) SET c.name = 'Excel VBA for Finance', c.issuer = 'Coursera', c.issued_date = date('2023-03-15'), c.expiry_date = null;
MATCH (e:Employee {full_name: 'Ritu Gupta'}), (c:Certification {cert_id: 'CERT-120'}) MERGE (e)-[:HAS_CERTIFICATION {obtained_date: date('2023-03-15')}]->(c);
