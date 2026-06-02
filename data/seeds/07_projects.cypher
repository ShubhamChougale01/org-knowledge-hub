// Rule: MERGE only on project_id. SET all other properties (including nullable end_date, client_name).
MERGE (p:Project {project_id: 'PROJ-001'})
SET p.name = 'NeuraVault', p.description = 'Advanced neural network knowledge vault for enterprise', p.type = 'Client', p.status = 'Active', p.start_date = date('2023-01-15'), p.end_date = null, p.tech_stack = ['Python', 'LangChain', 'Neo4j', 'FastAPI', 'React', 'AWS'], p.client_name = 'TechVentures Inc', p.team_size = 35, p.created_at = datetime();

MERGE (p:Project {project_id: 'PROJ-002'})
SET p.name = 'SentinelAI', p.description = 'Security threat detection using AI', p.type = 'Client', p.status = 'Active', p.start_date = date('2023-06-01'), p.end_date = null, p.tech_stack = ['Python', 'OpenAI', 'Pinecone', 'Node.js'], p.client_name = 'SecureBank AG', p.team_size = 12, p.created_at = datetime();

MERGE (p:Project {project_id: 'PROJ-003'})
SET p.name = 'OrgPulse', p.description = 'Internal organizational knowledge hub and employee collaboration platform', p.type = 'Internal', p.status = 'Active', p.start_date = date('2024-08-01'), p.end_date = null, p.tech_stack = ['Neo4j', 'LangChain', 'React', 'FastAPI'], p.client_name = null, p.team_size = 8, p.created_at = datetime();

MERGE (p:Project {project_id: 'PROJ-004'})
SET p.name = 'DataBridge', p.description = 'Enterprise data pipeline and ETL solution', p.type = 'Client', p.status = 'Completed', p.start_date = date('2022-03-01'), p.end_date = date('2023-12-31'), p.tech_stack = ['Spark', 'Airflow', 'dbt', 'Snowflake'], p.client_name = 'DataInsights Corp', p.team_size = 10, p.created_at = datetime();

MERGE (p:Project {project_id: 'PROJ-005'})
SET p.name = 'MarketLens', p.description = 'Market analytics and business intelligence platform', p.type = 'Client', p.status = 'Completed', p.start_date = date('2023-02-01'), p.end_date = date('2023-10-31'), p.tech_stack = ['Python', 'Tableau', 'FastAPI'], p.client_name = 'RetailGlobal Ltd', p.team_size = 6, p.created_at = datetime();

MERGE (p:Project {project_id: 'PROJ-006'})
SET p.name = 'TalentFlow', p.description = 'Internal talent management and HR workflow system', p.type = 'Internal', p.status = 'On-hold', p.start_date = date('2024-01-15'), p.end_date = null, p.tech_stack = ['React', 'Node.js', 'PostgreSQL'], p.client_name = null, p.team_size = 4, p.created_at = datetime();

MERGE (p:Project {project_id: 'PROJ-007'})
SET p.name = 'CipherSec', p.description = 'Cybersecurity infrastructure and monitoring', p.type = 'Client', p.status = 'Active', p.start_date = date('2023-09-01'), p.end_date = null, p.tech_stack = ['Python', 'Docker', 'Kubernetes', 'AWS'], p.client_name = 'MediCare Solutions', p.team_size = 9, p.created_at = datetime();
