# Git Repository Structure & Commit Strategy

This document clarifies what will be pushed to GitHub and what will stay local/ignored for security.

---

## 📦 What Gets Committed to GitHub ✅

These files are **safe and necessary** for team collaboration:

### 1. **Source Code** (Core)
```
backend/
├── main.py ✅
├── config.py ✅
├── backtest.py ✅
├── models/ ✅
├── routes/ ✅
├── controllers/ ✅
├── services/ ✅ (EXCEPT: services with secrets)
├── tools/ ✅
└── requirements.txt ✅

frontend/
├── src/ ✅ (all React code)
├── public/ ✅
├── package.json ✅
├── tsconfig.json ✅
└── vite.config.ts ✅
```

### 2. **Data & Seeds**
```
data/
├── seeds/ ✅ (all .cypher files)
├── load_data.py ✅
└── requirements.txt ✅
```

### 3. **Infrastructure & Config**
```
docker/
├── docker-compose.yml ✅ (NO secrets in this file)
└── Dockerfile ✅

.github/
├── workflows/ ✅ (CI/CD pipelines)
├── CODEOWNERS ✅
├── ISSUE_TEMPLATE/ ✅
└── pull_request_template.md ✅
```

### 4. **Documentation** (Critical for Developers)
```
README.md ✅
CLAUDE.md ✅ (root + package-specific)
CONTRIBUTING.md ✅
GIT_WORKFLOW.md ✅
GIT_STRATEGY.md ✅ (this file)
CHANGELOG.md ✅ (release notes)

backend/CLAUDE.md ✅
frontend/CLAUDE.md ✅

.claude/ ✅
├── settings.json ✅ (team-wide config)
├── skills/ ✅ (reusable guidance)
└── rules/ ✅ (if any)
```

### 5. **Gitignore Files**
```
.gitignore ✅
.dockerignore ✅
.env.example ✅ (template, NO actual secrets)
```

### 6. **Project Config**
```
.editorconfig ✅
tsconfig.json ✅
.eslintrc.json ✅ (frontend linting)
.prettierrc.json ✅ (code formatting)
pytest.ini ✅ (backend testing)
```

---

## 🚫 What Does NOT Get Committed (Ignored) ❌

These files are excluded by `.gitignore` for security & practicality:

### 1. **Secrets & Credentials**
```
❌ .env                    (API keys, JWT_SECRET, DB passwords)
❌ .env.local              (personal overrides)
❌ .env.*.local            (environment-specific secrets)
❌ *.key, *.pem            (SSH/TLS keys)
❌ docker-compose.override.yml (local DB credentials)
```

### 2. **Dependencies** (Large, can be reinstalled)
```
❌ node_modules/           (frontend dependencies)
❌ venv/, .venv/, env/     (Python virtual environments)
❌ package-lock.json       (lock files)
❌ yarn.lock, pnpm-lock.yaml
❌ *.egg-info/, dist/, build/
```

### 3. **Build Output & Cache**
```
❌ frontend/dist/          (production build)
❌ backend/__pycache__/    (Python cache)
❌ .pytest_cache/
❌ .eslintcache
❌ .mypy_cache/
❌ .coverage, htmlcov/
```

### 4. **IDE & Editor Files**
```
❌ .vscode/                (VS Code workspace settings)
❌ .idea/                  (JetBrains IDE settings)
❌ *.swp, *.swo            (Vim temporary files)
❌ .DS_Store               (macOS)
❌ Thumbs.db               (Windows)
```

### 5. **Logs & Temporary Files**
```
❌ *.log                   (application logs)
❌ logs/
❌ npm-debug.log, yarn-error.log
❌ *.tmp, tmp/, temp/
```

### 6. **Claude Code Local Files**
```
❌ .claude/settings.local.json (personal Claude Code settings)
❌ .claude/transcripts/
❌ .claude/plans/
❌ .claude/worktrees/
```

### 7. **Database Data** (Dev only)
```
❌ neo4j_data/             (local Neo4j database files)
❌ neo4j-data/
```

---

## 🔐 Security Checklist: Before Every Push

Before pushing code to GitHub, verify:

- [ ] **NO `.env` files** — Only `.env.example` is committed
- [ ] **NO `*.key` or `*.pem`** — SSH/TLS keys stay local
- [ ] **NO hardcoded API keys** in code — Use `os.getenv()` / environment variables
- [ ] **NO database passwords** in code or config files
- [ ] **NO JWT_SECRET** or similar secrets in commits
- [ ] **NO `node_modules/` or `venv/`** — These are in `.gitignore`
- [ ] **NO build artifacts** (dist/, build/) — These are in `.gitignore`
- [ ] **NO IDE config** (.vscode/, .idea/) — These are in `.gitignore` (use `.env.example` template)

### Quick Security Scan Before Push

```bash
# 1. Check for secrets in staged changes (before commit)
git diff --cached | grep -i "secret\|password\|api_key\|jwt\|token"

# 2. Verify .gitignore is working
git status  # should NOT show node_modules, .venv, .env, etc.

# 3. Check for large files (>50 MB indicates accidental binary/data)
git ls-files -o -i --exclude-standard
```

---

## 📂 Initial Repository Structure

```
org-knowledge-hub/                          # Root (public GitHub)
├── .git/                                   # Git metadata (auto-created)
├── .github/                                # GitHub-specific files
│   ├── workflows/                          # CI/CD pipelines (committed)
│   ├── CODEOWNERS                          # Code review assignments (committed)
│   └── pull_request_template.md            # PR template (committed)
│
├── .claude/                                # Claude Code config (committed)
│   ├── settings.json                       # Root config (committed)
│   ├── settings.local.json                 # Personal settings (IGNORED)
│   ├── skills/                             # Shared skills (committed)
│   └── rules/                              # Custom rules (committed)
│
├── .gitignore                              # Ignore rules (committed)
├── .env.example                            # Template, NO secrets (committed)
│
├── README.md                               # Project overview (committed)
├── CLAUDE.md                               # Claude Code guide (committed)
├── CONTRIBUTING.md                         # Developer guide (committed)
├── GIT_WORKFLOW.md                         # Git strategy (committed)
├── GIT_STRATEGY.md                         # This file (committed)
├── CHANGELOG.md                            # Release notes (committed)
│
├── backend/                                # Python FastAPI
│   ├── .env                                # Backend secrets (IGNORED)
│   ├── .claude/                            # Backend config (committed)
│   │   ├── settings.json
│   │   └── skills/
│   ├── main.py                             # App entry (committed)
│   ├── config.py                           # Configuration (committed)
│   ├── models/                             # Pydantic schemas (committed)
│   ├── routes/                             # API endpoints (committed)
│   ├── controllers/                        # Business logic (committed)
│   ├── services/                           # Infrastructure (committed)
│   ├── tools/                              # LangChain tools (committed)
│   ├── requirements.txt                    # Dependencies (committed)
│   ├── tests/                              # Test suite (committed)
│   ├── venv/                               # Virtual env (IGNORED)
│   ├── __pycache__/                        # Python cache (IGNORED)
│   └── .pytest_cache/                      # Test cache (IGNORED)
│
├── frontend/                               # React + Vite
│   ├── .env.local                          # Frontend secrets (IGNORED)
│   ├── .claude/                            # Frontend config (committed)
│   │   ├── settings.json
│   │   └── skills/
│   ├── src/                                # React source (committed)
│   │   ├── pages/                          # Page components
│   │   ├── components/                     # Reusable components
│   │   ├── services/                       # API client
│   │   ├── store/                          # Zustand state
│   │   └── types/                          # TypeScript interfaces
│   ├── public/                             # Static assets (committed)
│   ├── package.json                        # Dependencies (committed)
│   ├── vite.config.ts                      # Build config (committed)
│   ├── tsconfig.json                       # TS config (committed)
│   ├── .eslintrc.json                      # Linting (committed)
│   ├── node_modules/                       # Dependencies (IGNORED)
│   ├── dist/                               # Build output (IGNORED)
│   └── .eslintcache                        # Cache (IGNORED)
│
├── data/                                   # Database seeding
│   ├── .env                                # DB credentials (IGNORED)
│   ├── seeds/                              # Cypher migration files (committed)
│   ├── load_data.py                        # Loader script (committed)
│   └── requirements.txt                    # Dependencies (committed)
│
├── docker/                                 # Container orchestration
│   ├── docker-compose.yml                  # Compose config (committed)
│   ├── docker-compose.override.yml         # Local overrides (IGNORED)
│   └── Dockerfile                          # Image definition (committed)
│
├── reference/                              # Documentation & examples
│   ├── STEP1_README.md                     # Setup guide (committed)
│   ├── PROJECT_PLAN_V2.md                  # Build plan (committed)
│   ├── cypher_query_reference.md           # Query examples (committed)
│   └── *.md                                # All reference docs (committed)
│
└── neo4j_data/                             # Local DB files (IGNORED)
```

---

## 🚀 Initial Commit to GitHub

### Files Staged for First Commit:

```
✅ Added:
  .claude/settings.json
  .claude/skills/
  .gitignore
  .env.example
  GIT_WORKFLOW.md
  CONTRIBUTING.md
  backend/
  frontend/
  data/
  docker/
  reference/
  CLAUDE.md
  README.md (if exists)

❌ Not included (via .gitignore):
  .env, .env.local
  node_modules/, venv/
  dist/, build/, __pycache__/
  .vscode/, .idea/
  *.log
  neo4j_data/
```

### First Commit Message:

```
chore: initialize repository with Docker, backend, frontend, and Claude Code config

- Set up Git Flow branching strategy (main, develop, feature/*, release/*)
- Configure Claude Code with .claude/settings.json (deny rules, sparse paths)
- Add .claude/skills/ for backend and frontend guidance
- Create GIT_WORKFLOW.md documenting commit conventions and PR process
- Add CONTRIBUTING.md for developer onboarding
- Initialize .gitignore to exclude secrets, dependencies, and build artifacts
- Create .env.example template for team reference
```

---

## 👥 Team Setup (After First Push)

Once pushed to GitHub:

1. **Clone for new team members**:
   ```bash
   git clone https://github.com/coditas/org-knowledge-hub.git
   cd org-knowledge-hub
   cp .env.example .env
   # Edit .env with actual credentials (from secure team source)
   ```

2. **Setup locally**:
   ```bash
   docker-compose up -d          # Start Neo4j, Redis
   pip install -r backend/requirements.txt  # Python deps
   npm install                   # Node deps
   python data/load_data.py      # Seed database
   ```

3. **Start developing**:
   ```bash
   # Terminal 1: Backend
   cd backend && uvicorn main:app --reload --port 8001
   
   # Terminal 2: Frontend
   cd frontend && npm run dev
   
   # Terminal 3: Watch logs
   docker-compose logs -f
   ```

---

## 🔄 After Every Commit

Verify nothing sensitive was accidentally committed:

```bash
git log -1 -p | head -100  # Show last commit changes
git show HEAD | grep -i "secret\|password\|key"  # Search for secrets
```

If a secret was committed:

1. **Immediately:**
   - Revoke/rotate the secret (API key, password, etc.)
   - Do NOT push if still local
   
2. **Remove from history** (if pushed):
   ```bash
   # Use `git filter-branch` or `BFG Repo-Cleaner`
   # (Advanced — consult team lead)
   ```

---

## Summary

| Category | What's Committed | What's Ignored |
|---|---|---|
| **Source Code** | ✅ All .py, .tsx, .json files | ❌ Compiled/cache files |
| **Configuration** | ✅ .env.example, docker-compose.yml | ❌ .env, secrets, local overrides |
| **Dependencies** | ❌ node_modules/, venv/ | ✅ package.json, requirements.txt |
| **Documentation** | ✅ All .md files | ❌ IDE-specific docs (.vscode/) |
| **Builds** | ❌ dist/, build/ | ✅ Source files |
| **Claude Code** | ✅ .claude/settings.json, .claude/skills/ | ❌ .claude/settings.local.json, transcripts |

---

**Ready to commit?** Ensure:
1. ✅ All secrets in `.env` (not .env.example)
2. ✅ All source code in git
3. ✅ All deps/artifacts ignored
4. ✅ `.env.example` template created for team
