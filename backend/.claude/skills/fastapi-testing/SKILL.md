---
name: fastapi-testing
description: FastAPI testing patterns, pytest setup, Neo4j fixtures, and API endpoint tests. Use when writing or modifying tests in backend/.
---

## Testing Framework & Setup

**FastAPI recommends pytest** for testing. Required packages (add to requirements-dev.txt):
```
pytest>=8.0.0
pytest-asyncio>=0.23.0
httpx>=0.25.0
```

Run tests:
```bash
pytest                      # all tests
pytest -v                   # verbose output
pytest tests/test_auth.py   # single file
pytest -k "test_login"      # by name pattern
pytest --cov=.             # with coverage
```

## Test Structure

```
backend/
├── tests/
│   ├── conftest.py             # fixtures (db, client, auth)
│   ├── test_auth_routes.py     # auth endpoints
│   ├── test_chat_routes.py     # chat endpoint
│   ├── test_employee_routes.py # employee endpoints
│   ├── test_project_routes.py  # project endpoints
│   └── test_client_routes.py   # client endpoints
├── requirements-dev.txt
├── main.py
└── ...
```

## FastAPI Test Client & Fixtures

Example `tests/conftest.py`:

```python
import pytest
from fastapi.testclient import TestClient
from main import app

@pytest.fixture
def client():
    """Returns a TestClient for the app."""
    return TestClient(app)

@pytest.fixture
def auth_headers(client):
    """Returns Authorization headers with a valid JWT token."""
    # Login or create a test token
    response = client.post("/auth/login", json={
        "email": "test@coditas.com",
        "password": "password123"
    })
    token = response.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}
```

## Testing Endpoints

```python
def test_login_success(client):
    response = client.post("/auth/login", json={
        "email": "test@coditas.com",
        "password": "password123"
    })
    assert response.status_code == 200
    assert "access_token" in response.json()

def test_login_invalid_email(client):
    response = client.post("/auth/login", json={
        "email": "invalid@test.com",
        "password": "password123"
    })
    assert response.status_code == 401

def test_chat_authenticated(client, auth_headers):
    response = client.post(
        "/chat",
        headers=auth_headers,
        json={"message": "Who works on Project A?"}
    )
    assert response.status_code == 200
    assert "response" in response.json()

def test_chat_unauthorized(client):
    response = client.post("/chat", json={"message": "test"})
    assert response.status_code == 401
```

## Neo4j Testing Best Practices

When testing with Neo4j:

1. **Use test database** — Set `NEO4J_URI` in `.env.test` to a test instance
2. **Clean up between tests** — Use a pytest fixture to wipe data:
   ```python
   @pytest.fixture(autouse=True)
   def cleanup_neo4j(graph_service):
       yield
       # Delete all nodes after test
       with graph_service.driver.session() as session:
           session.run("MATCH (n) DETACH DELETE n")
   ```
3. **Mock external services** — Mock Groq API calls, Redis (optional):
   ```python
   from unittest.mock import patch
   
   @patch("tools.cypher_generator.groq_client.invoke")
   def test_chat_with_mocked_groq(mock_groq, client, auth_headers):
       mock_groq.return_value = "MATCH (n) RETURN n LIMIT 5"
       response = client.post("/chat", headers=auth_headers, ...)
       assert response.status_code == 200
   ```

## Key Testing Patterns

- **Test endpoints directly** — Use FastAPI TestClient, not raw HTTP
- **Always test auth** — Check 401 on missing/expired token
- **Mock external APIs** — Groq, LangSmith (not Neo4j in tests — use real test db)
- **Test error paths** — Invalid input, missing data, database failures
- **Use fixtures** — Avoid repeating setup code; fixtures are reusable
- **Check status codes first** — Then validate response structure and data

## Common Issues

| Issue | Solution |
|---|---|
| `pytest not found` | Install: `pip install pytest pytest-asyncio httpx` |
| Async test errors | Use `@pytest.mark.asyncio` on async test functions |
| Neo4j connection fails in tests | Ensure test DB is running; set `NEO4J_URI` in `.env.test` |
| Token invalid in tests | Re-login in fixture or use a long-lived test token |

