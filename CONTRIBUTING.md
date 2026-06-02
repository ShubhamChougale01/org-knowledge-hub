# Contributing to Org Knowledge Hub

Welcome! We're glad you want to contribute. This guide explains how to set up your environment, create features, and submit pull requests.

---

## Getting Started

### Prerequisites

- **Node.js** 18+ (for frontend)
- **Python** 3.10+ (for backend)
- **Docker** (for Neo4j + Redis)
- **Git** (with Git Bash on Windows, or WSL2)
- **Claude Code** (recommended for development)

### Initial Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/coditas/org-knowledge-hub.git
   cd org-knowledge-hub
   ```

2. **Copy environment files**:
   ```bash
   cp .env.example .env
   # Edit .env and add your credentials:
   # - GROQ_API_KEY (get from https://console.groq.com)
   # - LANGSMITH_API_KEY (get from https://smith.langchain.com)
   # - JWT_SECRET (generate a random string)
   ```

3. **Start the database stack**:
   ```bash
   cd docker
   docker-compose up -d
   # Neo4j Browser: http://localhost:7474 (neo4j / coditas123)
   ```

4. **Load sample data** (first time only):
   ```bash
   cd ../data
   pip install -r requirements.txt
   python load_data.py
   # Verify in Neo4j Browser: MATCH (n) RETURN count(n)  →  Should be ~280+ nodes
   ```

5. **Start backend server** (in a new terminal):
   ```bash
   cd ../backend
   pip install -r requirements.txt
   # Create .env in backend/ (should mirror root .env)
   uvicorn main:app --reload --port 8001
   # API docs: http://localhost:8001/docs
   ```

6. **Start frontend dev server** (in a new terminal):
   ```bash
   cd ../frontend
   npm install
   npm run dev
   # Opens: http://localhost:5173 (or 3000 depending on config)
   ```

You should now have:
- ✅ Neo4j running on port 7687
- ✅ Redis running on port 6379
- ✅ Backend API running on port 8001
- ✅ Frontend dev server running on port 5173
- ✅ Sample data loaded with 155 employees, 7 projects, etc.

**Test the flow**: Log in at http://localhost:5173 with `shubham.chougale@coditas.com` and any password, then ask the chatbot a question.

---

## Development Workflow

### 1. Create a Feature Branch

Always create a **feature branch** from `develop`:

```bash
git checkout develop
git pull origin develop
git checkout -b feature/your-feature-name
```

Branch names should be descriptive and lowercase:
- ✅ `feature/chat-memory`
- ✅ `feature/employee-search`
- ✅ `bugfix/auth-token-expiry`
- ❌ `my-branch`, `test`, `new-feature`

### 2. Make Changes & Commit

Edit files, test locally, then commit:

```bash
# Stage changes
git add backend/models/chat.py frontend/src/pages/ChatPage.tsx

# Commit with a clear message (see GIT_WORKFLOW.md for format)
git commit -m "feat(chat): add session memory to track conversation context

Implement SessionMemory service to maintain conversation history across
turns, enabling pronoun resolution and multi-turn follow-ups.

- Added memory.py with Redis-backed history
- Inject context into LLM system prompt
- Auto-prune messages older than 24 hours
"
```

**Commit message rules:**
- Use **Conventional Commits** format: `type(scope): subject`
- Types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `ci`
- Subject should be imperative: "add", "fix", not "added", "fixed"
- Keep subject under 50 characters
- See **GIT_WORKFLOW.md** for full details

### 3. Test Your Changes

**Before pushing**, run tests locally:

#### Backend
```bash
cd backend
pytest                         # run all tests
pytest -v                      # verbose
pytest tests/test_auth.py      # single file
pytest -k "test_login"         # by name pattern
```

If tests don't exist yet (common in active projects), at minimum:
- Manually test the feature
- Check for console errors
- Verify API responses using `/docs` Swagger UI
- Check that database queries execute without errors

#### Frontend
```bash
cd frontend
npm test                       # run jest tests
npm run lint                   # check eslint + prettier
npm run build                  # verify production build works
```

Manually test in browser:
- Navigate to affected pages
- Try the happy path (expected use case)
- Try edge cases (empty state, error state, loading state)
- Check responsive design (shrink browser)
- Open DevTools → Console (check for errors/warnings)

### 4. Push to GitHub

```bash
# Sync with latest develop before pushing
git fetch origin
git rebase origin/develop
# If rebase creates conflicts, resolve them and:
# git add .
# git rebase --continue

# Push to GitHub
git push -u origin feature/your-feature-name
```

### 5. Create a Pull Request

1. Go to GitHub repo: https://github.com/coditas/org-knowledge-hub
2. Click **"Compare & pull request"** (should appear after you push)
3. Fill in the PR template:
   ```markdown
   ## Summary
   - Added session memory service to track multi-turn conversations
   - Enables pronoun resolution ("show me their team")
   
   ## Testing
   - [x] Unit tests pass: pytest tests/test_memory.py
   - [x] Manual testing on localhost
   - [x] No new console errors
   - [x] Tested with multi-turn conversations
   
   ## Changes
   - backend/services/memory.py (new file)
   - backend/tools/chat_controller.py (inject history)
   - tests/test_memory.py (test coverage)
   
   ## Checklist
   - [x] Code follows conventions
   - [x] Tests added/passing
   - [x] Docs updated
   - [x] No secrets in commits
   ```

4. Request review from a team member
5. **Address feedback** by making commits to the same branch (CI re-runs automatically)
6. **Merge when approved** (or ask a maintainer to merge)

### 6. After Merge

Clean up your local branch:

```bash
# Switch back to develop
git checkout develop

# Sync with remote
git pull origin develop

# Delete local branch
git branch -d feature/your-feature-name

# Delete remote branch (GitHub usually offers a button, or:)
git push origin --delete feature/your-feature-name
```

---

## Code Style & Conventions

### Backend (Python)

- **Type hints**: Use for function signatures
  ```python
  def get_employee(employee_id: str) -> Employee:
      return db.query(f"MATCH (e:Employee) WHERE e.id = {employee_id} RETURN e")
  ```
- **Naming**: snake_case for functions/variables, PascalCase for classes
- **Imports**: Group standard lib, third-party, local
- **Max line length**: 100 characters (but favor readability)

Run checks:
```bash
# Format code with Black
black backend/

# Type check with mypy (if configured)
mypy backend/

# Lint with flake8 (if configured)
flake8 backend/
```

### Frontend (React/TypeScript)

- **Type safety**: Always import types, use `React.FC<Props>`
  ```tsx
  interface EmployeeCardProps {
    employee: Employee;
    onSelect?: (id: string) => void;
  }
  export const EmployeeCard: React.FC<EmployeeCardProps> = ({ employee }) => (
    <div>{employee.name}</div>
  );
  ```
- **Naming**: camelCase for variables/functions, PascalCase for components
- **Imports**: Organize by React → third-party → local (use absolute paths: `src/pages`, not `../../pages`)
- **Component structure**: 
  - Props interface at top
  - Hooks (useState, useEffect, etc.)
  - Handlers and business logic
  - Return JSX last

Run checks:
```bash
# Format code with Prettier
npm run lint -- --fix

# Type check with TypeScript
npm run build  # includes tsc

# Run tests
npm test
```

### General

- **No commented-out code** — delete it; git history preserves it
- **No console.log in production** — use proper logging
- **No magic numbers** — extract to constants with clear names
- **Comments** explain _why_, not _what_ — code shows the what

---

## Testing

### Backend Tests

Write tests for new features using **pytest**:

```python
# tests/test_chat.py
import pytest
from fastapi.testclient import TestClient
from main import app
from services.auth import create_token

@pytest.fixture
def client():
    return TestClient(app)

@pytest.fixture
def auth_headers(client):
    token = create_token(user_id="emp123", access_level=3)
    return {"Authorization": f"Bearer {token}"}

def test_chat_endpoint_returns_response(client, auth_headers):
    response = client.post(
        "/chat",
        headers=auth_headers,
        json={"message": "Who works on Project A?"}
    )
    assert response.status_code == 200
    assert "response" in response.json()

def test_chat_requires_auth(client):
    response = client.post("/chat", json={"message": "test"})
    assert response.status_code == 401
```

Run:
```bash
cd backend
pytest
```

### Frontend Tests

Write tests for React components using **Jest + React Testing Library**:

```tsx
// src/components/EmployeeCard.test.tsx
import { render, screen } from '@testing-library/react';
import { EmployeeCard } from './EmployeeCard';

describe('EmployeeCard', () => {
  it('displays employee name', () => {
    const employee = { id: '1', name: 'Alice', email: 'alice@coditas.com' };
    render(<EmployeeCard employee={employee} />);
    expect(screen.getByText('Alice')).toBeInTheDocument();
  });

  it('calls onSelect when clicked', () => {
    const employee = { id: '1', name: 'Alice', email: 'alice@coditas.com' };
    const onSelect = jest.fn();
    render(<EmployeeCard employee={employee} onSelect={onSelect} />);
    screen.getByText('Alice').click();
    expect(onSelect).toHaveBeenCalledWith('1');
  });
});
```

Run:
```bash
cd frontend
npm test
```

---

## Debugging

### Backend Debugging

Use FastAPI's interactive API docs:
```
http://localhost:8001/docs
```

Log in the browser, copy JWT token, paste in Swagger UI's "Authorize" button, then test endpoints.

Or use Python debugger:
```python
import pdb; pdb.set_trace()  # Debugger will pause here
```

### Frontend Debugging

Use React DevTools (Chrome extension):
- Inspect components
- View/edit props and state
- Track re-renders

Or use browser DevTools (F12):
- Console: see errors and logs
- Network: inspect API calls
- Sources: set breakpoints

### Database Debugging

Connect to Neo4j Browser: http://localhost:7474

Run Cypher queries:
```cypher
MATCH (e:Employee) RETURN e LIMIT 10;
MATCH (e:Employee)-[r:HAS_SKILL]->(s:Skill) WHERE s.name = "Python" RETURN e;
```

---

## Common Tasks

### Add a New API Endpoint

1. Create route in `backend/routes/new_routes.py`
2. Add controller logic in `backend/controllers/new_controller.py`
3. Add Pydantic models in `backend/models/new_model.py`
4. Register route in `backend/main.py`
5. Test in `/docs` Swagger UI
6. Add tests in `backend/tests/test_new_routes.py`

### Add a New React Page

1. Create page component in `frontend/src/pages/NewPage.tsx`
2. Add route to `frontend/src/App.tsx` router
3. Add navigation link in `frontend/src/components/Layout/Sidebar.tsx`
4. Test navigation and page rendering

### Update Database Schema

1. Create migration file in `data/seeds/` (e.g., `12_add_certifications.cypher`)
2. Edit `data/load_data.py` to run the new migration
3. Test locally: `cd data && python load_data.py`
4. Commit both files together

---

## Troubleshooting

| Issue | Solution |
|---|---|
| **Port already in use** | Kill process: `lsof -i :8001` then `kill PID` |
| **Neo4j won't start** | `docker-compose down && docker volume rm org-knowledge-hub_neo4j_data && docker-compose up -d` |
| **Backend 401 errors** | Ensure JWT_SECRET matches in .env and code; token may be expired (TTL 8 hours) |
| **Frontend can't reach backend** | Check VITE_API_BASE_URL environment variable; backend must be running on 8001 |
| **Tests failing after DB schema change** | Run migrations: `cd data && python load_data.py` |
| **Yarn/npm lock issues** | Delete lock file and reinstall: `rm package-lock.json && npm install` |

---

## Getting Help

- **Questions about workflow?** Check [GIT_WORKFLOW.md](GIT_WORKFLOW.md)
- **Questions about code?** Start Claude Code: `claude .` and ask questions
- **Stuck debugging?** Create an issue with error logs
- **Ready to contribute?** Pick an issue tagged `good first issue` or ask the team lead

---

## Code of Conduct

- **Respectful communication** in PRs and issues
- **Timely reviews** — review PRs within 24 hours if possible
- **Constructive feedback** — explain _why_ you're suggesting a change
- **No pressure** — this is a collaborative project; ask for help!

---

Thanks for contributing! 🚀
