// Create clients for client projects
MERGE (c:Client {client_id: 'CLIENT-001', name: 'TechVentures Inc', industry: 'Venture Capital', country: 'United States'}) SET c.created_at = datetime();
MERGE (c:Client {client_id: 'CLIENT-002', name: 'SecureBank AG', industry: 'Banking', country: 'Switzerland'}) SET c.created_at = datetime();
MERGE (c:Client {client_id: 'CLIENT-003', name: 'RetailGlobal Ltd', industry: 'Retail', country: 'United Kingdom'}) SET c.created_at = datetime();
MERGE (c:Client {client_id: 'CLIENT-004', name: 'MediCare Solutions', industry: 'Healthcare', country: 'Canada'}) SET c.created_at = datetime();
MERGE (c:Client {client_id: 'CLIENT-005', name: 'DataInsights Corp', industry: 'Analytics', country: 'United States'}) SET c.created_at = datetime();
