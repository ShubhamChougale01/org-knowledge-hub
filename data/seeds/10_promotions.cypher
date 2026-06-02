// PROMOTION HISTORY — career progression inside Coditas
// C-Suite excluded (hired at level). Only org_experience_years >= 1.5 eligible.
// Shubham Chougale: Associate Software Engineer -> Software Engineer on 2025-06-30 (required)

// ==================== TECH DEPARTMENT ====================

// Tech Heads (promoted from Senior Engineer)
MERGE (ph:PromotionHistory {history_id: 'PROMO-001'}) SET ph.from_role = 'Senior Software Engineer', ph.to_role = 'Tech Head', ph.effective_date = date('2019-08-01');
MATCH (e:Employee {full_name: 'Priya Verma'}), (ph:PromotionHistory {history_id: 'PROMO-001'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-001'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-002'}) SET ph.from_role = 'Senior Software Engineer', ph.to_role = 'Tech Head', ph.effective_date = date('2018-07-15');
MATCH (e:Employee {full_name: 'Vikram Singh'}), (ph:PromotionHistory {history_id: 'PROMO-002'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-002'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

// Product Managers (promoted from Senior Software Engineer)
MERGE (ph:PromotionHistory {history_id: 'PROMO-003'}) SET ph.from_role = 'Senior Software Engineer', ph.to_role = 'Product Manager', ph.effective_date = date('2020-03-01');
MATCH (e:Employee {full_name: 'Ananya Gupta'}), (ph:PromotionHistory {history_id: 'PROMO-003'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-003'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-004'}) SET ph.from_role = 'Senior Software Engineer', ph.to_role = 'Product Manager', ph.effective_date = date('2021-01-01');
MATCH (e:Employee {full_name: 'Ashok Desai'}), (ph:PromotionHistory {history_id: 'PROMO-004'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-004'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-005'}) SET ph.from_role = 'Senior Software Engineer', ph.to_role = 'Product Manager', ph.effective_date = date('2019-09-01');
MATCH (e:Employee {full_name: 'Kavya Reddy'}), (ph:PromotionHistory {history_id: 'PROMO-005'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-005'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-006'}) SET ph.from_role = 'Senior Software Engineer', ph.to_role = 'Product Manager', ph.effective_date = date('2020-05-01');
MATCH (e:Employee {full_name: 'Rohit Nair'}), (ph:PromotionHistory {history_id: 'PROMO-006'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-006'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-007'}) SET ph.from_role = 'Senior Software Engineer', ph.to_role = 'Product Manager', ph.effective_date = date('2021-02-01');
MATCH (e:Employee {full_name: 'Shreya Singh'}), (ph:PromotionHistory {history_id: 'PROMO-007'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-007'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-008'}) SET ph.from_role = 'Senior Software Engineer', ph.to_role = 'Product Manager', ph.effective_date = date('2019-11-01');
MATCH (e:Employee {full_name: 'Nikhil Joshi'}), (ph:PromotionHistory {history_id: 'PROMO-008'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-008'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

// Shubham Chougale — REQUIRED promotion
MERGE (ph:PromotionHistory {history_id: 'PROMO-009'}) SET ph.from_role = 'Associate Software Engineer', ph.to_role = 'Software Engineer', ph.effective_date = date('2025-06-30');
MATCH (e:Employee {full_name: 'Shubham Chougale'}), (ph:PromotionHistory {history_id: 'PROMO-009'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-009'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

// Senior Engineers (promoted from Software Engineer)
MERGE (ph:PromotionHistory {history_id: 'PROMO-010'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2019-06-01');
MATCH (e:Employee {full_name: 'Mohan Rao'}), (ph:PromotionHistory {history_id: 'PROMO-010'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-010'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-011'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2020-04-01');
MATCH (e:Employee {full_name: 'Divya Iyer'}), (ph:PromotionHistory {history_id: 'PROMO-011'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-011'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-012'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2020-01-01');
MATCH (e:Employee {full_name: 'Sanjay Chopra'}), (ph:PromotionHistory {history_id: 'PROMO-012'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-012'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-013'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2020-08-01');
MATCH (e:Employee {full_name: 'Anjali Mishra'}), (ph:PromotionHistory {history_id: 'PROMO-013'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-013'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-014'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2021-03-01');
MATCH (e:Employee {full_name: 'Aditya Sinha'}), (ph:PromotionHistory {history_id: 'PROMO-014'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-014'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-015'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2021-05-01');
MATCH (e:Employee {full_name: 'Renu Pandey'}), (ph:PromotionHistory {history_id: 'PROMO-015'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-015'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-016'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2019-09-01');
MATCH (e:Employee {full_name: 'Mahesh Trivedi'}), (ph:PromotionHistory {history_id: 'PROMO-016'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-016'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-017'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2021-01-01');
MATCH (e:Employee {full_name: 'Swati Saxena'}), (ph:PromotionHistory {history_id: 'PROMO-017'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-017'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-018'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2020-04-01');
MATCH (e:Employee {full_name: 'Rajesh Bhat'}), (ph:PromotionHistory {history_id: 'PROMO-018'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-018'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-019'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2021-06-01');
MATCH (e:Employee {full_name: 'Meera Banerjee'}), (ph:PromotionHistory {history_id: 'PROMO-019'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-019'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-020'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2021-02-01');
MATCH (e:Employee {full_name: 'Vikram Menon'}), (ph:PromotionHistory {history_id: 'PROMO-020'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-020'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-021'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2021-11-01');
MATCH (e:Employee {full_name: 'Neha Kapoor'}), (ph:PromotionHistory {history_id: 'PROMO-021'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-021'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-022'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2020-07-01');
MATCH (e:Employee {full_name: 'Abhishek Kumar'}), (ph:PromotionHistory {history_id: 'PROMO-022'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-022'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-023'}) SET ph.from_role = 'Software Engineer', ph.to_role = 'Senior Software Engineer', ph.effective_date = date('2021-02-01');
MATCH (e:Employee {full_name: 'Pooja Verma'}), (ph:PromotionHistory {history_id: 'PROMO-023'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-023'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

// Engineers (promoted from Associate — those with >= 2 years)
MERGE (ph:PromotionHistory {history_id: 'PROMO-024'}) SET ph.from_role = 'Associate Software Engineer', ph.to_role = 'Software Engineer', ph.effective_date = date('2020-08-01');
MATCH (e:Employee {full_name: 'Rahul Singh'}), (ph:PromotionHistory {history_id: 'PROMO-024'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-024'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-025'}) SET ph.from_role = 'Associate Software Engineer', ph.to_role = 'Software Engineer', ph.effective_date = date('2020-04-01');
MATCH (e:Employee {full_name: 'Sameer Patel'}), (ph:PromotionHistory {history_id: 'PROMO-025'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-025'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-026'}) SET ph.from_role = 'Associate Software Engineer', ph.to_role = 'Software Engineer', ph.effective_date = date('2020-05-01');
MATCH (e:Employee {full_name: 'Varun Rao'}), (ph:PromotionHistory {history_id: 'PROMO-026'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-026'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-027'}) SET ph.from_role = 'Associate Software Engineer', ph.to_role = 'Software Engineer', ph.effective_date = date('2020-10-01');
MATCH (e:Employee {full_name: 'Praveen Kumar'}), (ph:PromotionHistory {history_id: 'PROMO-027'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-027'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-028'}) SET ph.from_role = 'Associate Software Engineer', ph.to_role = 'Software Engineer', ph.effective_date = date('2020-06-01');
MATCH (e:Employee {full_name: 'Manoj Verma'}), (ph:PromotionHistory {history_id: 'PROMO-028'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-028'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-029'}) SET ph.from_role = 'Associate Software Engineer', ph.to_role = 'Software Engineer', ph.effective_date = date('2020-02-01');
MATCH (e:Employee {full_name: 'Rohan Sharma'}), (ph:PromotionHistory {history_id: 'PROMO-029'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-029'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-030'}) SET ph.from_role = 'Associate Software Engineer', ph.to_role = 'Software Engineer', ph.effective_date = date('2020-07-01');
MATCH (e:Employee {full_name: 'Sandeep Reddy'}), (ph:PromotionHistory {history_id: 'PROMO-030'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-030'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-031'}) SET ph.from_role = 'Associate Software Engineer', ph.to_role = 'Software Engineer', ph.effective_date = date('2020-11-01');
MATCH (e:Employee {full_name: 'Suresh Nair'}), (ph:PromotionHistory {history_id: 'PROMO-031'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-031'}), (d:Department {name: 'Tech'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

// ==================== DELIVERY DEPARTMENT ====================

MERGE (ph:PromotionHistory {history_id: 'PROMO-032'}) SET ph.from_role = 'Senior Project Analyst', ph.to_role = 'Delivery Head', ph.effective_date = date('2019-09-01');
MATCH (e:Employee {full_name: 'Satish Rao'}), (ph:PromotionHistory {history_id: 'PROMO-032'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-032'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-033'}) SET ph.from_role = 'Senior Project Analyst', ph.to_role = 'Delivery Head', ph.effective_date = date('2020-10-01');
MATCH (e:Employee {full_name: 'Meena Yadav'}), (ph:PromotionHistory {history_id: 'PROMO-033'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-033'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-034'}) SET ph.from_role = 'Project Analyst', ph.to_role = 'Project Manager', ph.effective_date = date('2020-11-01');
MATCH (e:Employee {full_name: 'Vikram Mittal'}), (ph:PromotionHistory {history_id: 'PROMO-034'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-034'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-035'}) SET ph.from_role = 'Project Analyst', ph.to_role = 'Project Manager', ph.effective_date = date('2021-03-01');
MATCH (e:Employee {full_name: 'Anjaly Mohta'}), (ph:PromotionHistory {history_id: 'PROMO-035'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-035'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-036'}) SET ph.from_role = 'Project Analyst', ph.to_role = 'Project Manager', ph.effective_date = date('2021-05-01');
MATCH (e:Employee {full_name: 'Rajesh Kumaran'}), (ph:PromotionHistory {history_id: 'PROMO-036'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-036'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-037'}) SET ph.from_role = 'Project Analyst', ph.to_role = 'Project Manager', ph.effective_date = date('2022-04-01');
MATCH (e:Employee {full_name: 'Priya Nambiar'}), (ph:PromotionHistory {history_id: 'PROMO-037'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-037'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-038'}) SET ph.from_role = 'Project Analyst', ph.to_role = 'Project Manager', ph.effective_date = date('2020-12-01');
MATCH (e:Employee {full_name: 'Anil Chakraborty'}), (ph:PromotionHistory {history_id: 'PROMO-038'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-038'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

// Senior Analysts
MERGE (ph:PromotionHistory {history_id: 'PROMO-039'}) SET ph.from_role = 'Project Analyst', ph.to_role = 'Senior Project Analyst', ph.effective_date = date('2020-08-01');
MATCH (e:Employee {full_name: 'Shreya Dutta'}), (ph:PromotionHistory {history_id: 'PROMO-039'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-039'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-040'}) SET ph.from_role = 'Project Analyst', ph.to_role = 'Senior Project Analyst', ph.effective_date = date('2021-01-01');
MATCH (e:Employee {full_name: 'Ravi Shankar'}), (ph:PromotionHistory {history_id: 'PROMO-040'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-040'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-041'}) SET ph.from_role = 'Project Analyst', ph.to_role = 'Senior Project Analyst', ph.effective_date = date('2021-06-01');
MATCH (e:Employee {full_name: 'Divya Menon'}), (ph:PromotionHistory {history_id: 'PROMO-041'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-041'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-042'}) SET ph.from_role = 'Project Analyst', ph.to_role = 'Senior Project Analyst', ph.effective_date = date('2020-07-01');
MATCH (e:Employee {full_name: 'Arun Gupta'}), (ph:PromotionHistory {history_id: 'PROMO-042'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-042'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-043'}) SET ph.from_role = 'Project Analyst', ph.to_role = 'Senior Project Analyst', ph.effective_date = date('2021-02-01');
MATCH (e:Employee {full_name: 'Ganesh Iyer'}), (ph:PromotionHistory {history_id: 'PROMO-043'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-043'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-044'}) SET ph.from_role = 'Project Analyst', ph.to_role = 'Senior Project Analyst', ph.effective_date = date('2020-09-01');
MATCH (e:Employee {full_name: 'Srinivas Rao'}), (ph:PromotionHistory {history_id: 'PROMO-044'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-044'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-045'}) SET ph.from_role = 'Project Analyst', ph.to_role = 'Senior Project Analyst', ph.effective_date = date('2021-08-01');
MATCH (e:Employee {full_name: 'Ramesh Patel'}), (ph:PromotionHistory {history_id: 'PROMO-045'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-045'}), (d:Department {name: 'Delivery'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

// ==================== SALES DEPARTMENT ====================

MERGE (ph:PromotionHistory {history_id: 'PROMO-046'}) SET ph.from_role = 'Sales Manager', ph.to_role = 'Sales Head', ph.effective_date = date('2019-08-01');
MATCH (e:Employee {full_name: 'Karan Bhatnagar'}), (ph:PromotionHistory {history_id: 'PROMO-046'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-046'}), (d:Department {name: 'Sales'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-047'}) SET ph.from_role = 'Account Executive', ph.to_role = 'Sales Manager', ph.effective_date = date('2021-09-01');
MATCH (e:Employee {full_name: 'Priya Malhotra'}), (ph:PromotionHistory {history_id: 'PROMO-047'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-047'}), (d:Department {name: 'Sales'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-048'}) SET ph.from_role = 'Account Executive', ph.to_role = 'Sales Manager', ph.effective_date = date('2022-01-01');
MATCH (e:Employee {full_name: 'Rajesh Mittal'}), (ph:PromotionHistory {history_id: 'PROMO-048'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-048'}), (d:Department {name: 'Sales'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-049'}) SET ph.from_role = 'Account Executive', ph.to_role = 'Sales Manager', ph.effective_date = date('2022-04-01');
MATCH (e:Employee {full_name: 'Anita Sharma'}), (ph:PromotionHistory {history_id: 'PROMO-049'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-049'}), (d:Department {name: 'Sales'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-050'}) SET ph.from_role = 'Account Executive', ph.to_role = 'Sales Manager', ph.effective_date = date('2022-02-01');
MATCH (e:Employee {full_name: 'Aditya Agrawal'}), (ph:PromotionHistory {history_id: 'PROMO-050'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-050'}), (d:Department {name: 'Sales'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

// ==================== MARKETING DEPARTMENT ====================

MERGE (ph:PromotionHistory {history_id: 'PROMO-051'}) SET ph.from_role = 'Marketing Manager', ph.to_role = 'Marketing Head', ph.effective_date = date('2020-03-01');
MATCH (e:Employee {full_name: 'Shreya Patel'}), (ph:PromotionHistory {history_id: 'PROMO-051'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-051'}), (d:Department {name: 'Marketing'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-052'}) SET ph.from_role = 'Marketing Executive', ph.to_role = 'Marketing Manager', ph.effective_date = date('2021-05-01');
MATCH (e:Employee {full_name: 'Arjun Mittal'}), (ph:PromotionHistory {history_id: 'PROMO-052'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-052'}), (d:Department {name: 'Marketing'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-053'}) SET ph.from_role = 'Marketing Executive', ph.to_role = 'Marketing Manager', ph.effective_date = date('2022-01-01');
MATCH (e:Employee {full_name: 'Kavya Desai'}), (ph:PromotionHistory {history_id: 'PROMO-053'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-053'}), (d:Department {name: 'Marketing'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-054'}) SET ph.from_role = 'Marketing Executive', ph.to_role = 'Marketing Manager', ph.effective_date = date('2021-08-01');
MATCH (e:Employee {full_name: 'Nikhil Sharma'}), (ph:PromotionHistory {history_id: 'PROMO-054'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-054'}), (d:Department {name: 'Marketing'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

// ==================== HR DEPARTMENT ====================

MERGE (ph:PromotionHistory {history_id: 'PROMO-055'}) SET ph.from_role = 'HR Manager', ph.to_role = 'HR Head', ph.effective_date = date('2020-08-01');
MATCH (e:Employee {full_name: 'Vikram Desai'}), (ph:PromotionHistory {history_id: 'PROMO-055'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-055'}), (d:Department {name: 'HR'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-056'}) SET ph.from_role = 'HR Executive', ph.to_role = 'HR Manager', ph.effective_date = date('2021-04-01');
MATCH (e:Employee {full_name: 'Priya Sinha'}), (ph:PromotionHistory {history_id: 'PROMO-056'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-056'}), (d:Department {name: 'HR'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-057'}) SET ph.from_role = 'HR Executive', ph.to_role = 'HR Manager', ph.effective_date = date('2021-06-01');
MATCH (e:Employee {full_name: 'Ramesh Gupta'}), (ph:PromotionHistory {history_id: 'PROMO-057'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-057'}), (d:Department {name: 'HR'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-058'}) SET ph.from_role = 'HR Associate', ph.to_role = 'HR Executive', ph.effective_date = date('2021-05-01');
MATCH (e:Employee {full_name: 'Sneha Verma'}), (ph:PromotionHistory {history_id: 'PROMO-058'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-058'}), (d:Department {name: 'HR'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-059'}) SET ph.from_role = 'HR Associate', ph.to_role = 'HR Executive', ph.effective_date = date('2022-01-01');
MATCH (e:Employee {full_name: 'Arun Nair'}), (ph:PromotionHistory {history_id: 'PROMO-059'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-059'}), (d:Department {name: 'HR'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-060'}) SET ph.from_role = 'HR Associate', ph.to_role = 'HR Executive', ph.effective_date = date('2021-09-01');
MATCH (e:Employee {full_name: 'Sanjiv Rao'}), (ph:PromotionHistory {history_id: 'PROMO-060'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-060'}), (d:Department {name: 'HR'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

// ==================== FINANCE DEPARTMENT ====================

MERGE (ph:PromotionHistory {history_id: 'PROMO-061'}) SET ph.from_role = 'Finance Manager', ph.to_role = 'Finance Head', ph.effective_date = date('2020-08-01');
MATCH (e:Employee {full_name: 'Anjali Saxena'}), (ph:PromotionHistory {history_id: 'PROMO-061'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-061'}), (d:Department {name: 'Finance'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-062'}) SET ph.from_role = 'Financial Analyst', ph.to_role = 'Finance Manager', ph.effective_date = date('2021-01-01');
MATCH (e:Employee {full_name: 'Rakesh Kumar'}), (ph:PromotionHistory {history_id: 'PROMO-062'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-062'}), (d:Department {name: 'Finance'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-063'}) SET ph.from_role = 'Financial Analyst', ph.to_role = 'Finance Manager', ph.effective_date = date('2021-03-01');
MATCH (e:Employee {full_name: 'Laxmi Desai'}), (ph:PromotionHistory {history_id: 'PROMO-063'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-063'}), (d:Department {name: 'Finance'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-064'}) SET ph.from_role = 'Finance Associate', ph.to_role = 'Financial Analyst', ph.effective_date = date('2021-06-01');
MATCH (e:Employee {full_name: 'Priya Menon'}), (ph:PromotionHistory {history_id: 'PROMO-064'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-064'}), (d:Department {name: 'Finance'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-065'}) SET ph.from_role = 'Finance Associate', ph.to_role = 'Financial Analyst', ph.effective_date = date('2022-02-01');
MATCH (e:Employee {full_name: 'Sunder Rao'}), (ph:PromotionHistory {history_id: 'PROMO-065'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-065'}), (d:Department {name: 'Finance'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);

MERGE (ph:PromotionHistory {history_id: 'PROMO-066'}) SET ph.from_role = 'Finance Associate', ph.to_role = 'Financial Analyst', ph.effective_date = date('2021-09-01');
MATCH (e:Employee {full_name: 'Mohan Singh'}), (ph:PromotionHistory {history_id: 'PROMO-066'}) MERGE (e)-[:PROMOTED_TO]->(ph);
MATCH (ph:PromotionHistory {history_id: 'PROMO-066'}), (d:Department {name: 'Finance'}) MERGE (ph)-[:IN_DEPARTMENT]->(d);
