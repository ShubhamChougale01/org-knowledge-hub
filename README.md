# Org Knowledge Hub 🧠📊

An AI-powered knowledge graph system for [Coditas](https://coditas.com) that answers plain English questions about company structure, employee skills, projects, and clients using a live Neo4j database.

**Ask:** "Who works on Project A?" → **Get:** Real-time answer from the knowledge graph (no hallucinations, no guessing).

---

## 🚀 Quick Start (5 Minutes)

### TL;DR for Experienced Developers

```bash
# Clone & Setup
git clone https://github.com/ShubhamChougale01/org-knowledge-hub.git
cd org-knowledge-hub

# Environment Setup
cp .env.example .env
# Edit .env with API keys (see step 3 below)

# Start Services
docker-compose up -d

# Install & Run
pip install -r backend/requirements.txt  # Backend
npm install                               # Frontend
python data/load_data.py                 # Load data

# Start Dev Servers (in 2 terminals)
# Terminal 1:
cd backend && uvicorn main:app --reload --port 8001

# Terminal 2:
cd frontend && npm run dev

# Visit http://localhost:5173
```

---

## 📋 Prerequisites

### Required Software

Before starting, install these on your machine:

| Software | Version | Purpose | Download |
|---|---|---|---|
| **Node.js** | 18+ | Frontend (React, npm) | [nodejs.org](https://nodejs.org/) |
| **Python** | 3.10+ | Backend (FastAPI) | [python.org](https://www.python.org/) |
| **Docker** | Latest | Neo4j, Redis containers | [docker.com](https://www.docker.com/) |
| **Git** | Latest | Version control | [git-scm.com](https://git-scm.com/) |

### Verify Installation

```bash
# Check Node.js
node --version          # Should be v18.0.0 or higher
npm --version           # Should be 9.0.0 or higher

# Check Python
python --version        # Should be Python 3.10 or higher
# (On macOS/Linux, might be 'python3' instead of 'python')

# Check Docker
docker --version        # Should be latest stable
docker run hello-world  # Should print "Hello from Docker!"

# Check Git
git --version           # Should be latest stable
```

**Having issues?** See [Troubleshooting Prerequisites](#troubleshooting-prerequisites) below.

---

## 🛠️ Step-by-Step Setup

### Step 1: Clone the Repository

```bash
# Clone the repo
git clone https://github.com/ShubhamChougale01/org-knowledge-hub.git
cd org-knowledge-hub

# Verify you're in the right directory
ls  # Should show: backend/ frontend/ data/ docker/ README.md etc.
```

### Step 2: Get API Keys & Credentials

You need 2 API keys. **Ask your team lead to provide these** (they're not in the repo for security):

#### **A. Groq API Key** (for LLM queries)
1. Go to https://console.groq.com
2. Sign up (free account)
3. Create an API key
4. Copy it (looks like: `gsk_...`)

#### **B. LangSmith API Key** (for tracing/monitoring — optional but recommended)
1. Go to https://smith.langchain.com
2. Sign up with GitHub
3. Create a project named `org-knowledge-hub`
4. Copy the API key

#### **C. JWT Secret** (generate locally)
```bash
# Generate a random 32-character string
# Windows PowerShell:
-join ((1..32) | ForEach-Object { [char]((48..90) + (97..122) | Get-Random) })

# macOS/Linux:
openssl rand -hex 16
```

### Step 3: Create & Configure `.env` File

1. **Copy the template:**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env`** with your credentials:
   ```bash
   # Open .env in your editor
   # On Windows: code .env  (or open in Notepad)
   # On Mac/Linux: nano .env (or code .env)
   ```

3. **Fill in these fields:**
   ```env
   # Neo4j Database (leave as-is for local dev)
   NEO4J_URI=bolt://localhost:7687
   NEO4J_USER=neo4j
   NEO4J_PASSWORD=coditas123

   # LLM (Groq) - PASTE YOUR API KEY HERE
   GROQ_API_KEY=gsk_YOUR_API_KEY_HERE

   # LangSmith (optional) - PASTE YOUR API KEY HERE
   LANGSMITH_API_KEY=lsv2_pt_YOUR_API_KEY_HERE
   LANGSMITH_PROJECT=org-knowledge-hub

   # Caching (leave as-is for local dev)
   REDIS_URL=redis://localhost:6379

   # JWT Auth (PASTE YOUR GENERATED SECRET HERE)
   JWT_SECRET=your_32_character_random_string_here
   JWT_ALGORITHM=HS256
   JWT_EXPIRES_HOURS=8

   # Server (leave as-is for local dev)
   BACKEND_PORT=8001
   BACKEND_HOST=0.0.0.0
   FRONTEND_PORT=5173
   VITE_API_BASE_URL=http://localhost:8001

   # Logging (leave as-is)
   LOG_LEVEL=INFO
   ```

4. **Save the file** (Ctrl+S or Cmd+S)

⚠️ **IMPORTANT:** Never commit `.env` to git. It's in `.gitignore` — keep it local!

### Step 4: Start Database & Cache Services

Docker will start Neo4j (graph database) and Redis (caching):

```bash
# Start containers
cd docker
docker-compose up -d

# Verify they started
docker ps

# You should see 2 containers:
# - neo4j:latest
# - redis:latest
```

✅ **Neo4j Browser** will be at: http://localhost:7474 (username: `neo4j`, password: `coditas123`)

### Step 5: Load Sample Data

This loads 155 employees, 7 projects, 36 roles, and 62 skills into the database:

```bash
cd ../data

# Install Python dependencies
pip install -r requirements.txt

# Load the data
python load_data.py

# You should see:
# ✅ Loading: 01_constraints.cypher
# ✅ Loading: 02_departments.cypher
# ... (all 11 files)
# ✅ Data loaded successfully!
```

⏱️ **Time:** ~30 seconds. If it takes longer, check that Docker is running.

### Step 6: Install Backend Dependencies

```bash
cd ../backend

# Create Python virtual environment (optional but recommended)
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Verify installation
pip list | grep fastapi
# Should show: fastapi 0.115.0 (or higher)
```

### Step 7: Install Frontend Dependencies

```bash
cd ../frontend

# Install npm packages
npm install

# Verify installation
npm list react
# Should show: react@18.3.1 (or similar)
```

### Step 8: Start the Development Servers

You'll need **3 terminals** (or terminal tabs):

#### **Terminal 1: Backend API Server**
```bash
cd backend

# If you created venv, activate it first
# Windows: venv\Scripts\activate
# macOS/Linux: source venv/bin/activate

# Start the server
uvicorn main:app --reload --port 8001

# You should see:
# INFO:     Uvicorn running on http://127.0.0.1:8001
# INFO:     Application startup complete
```

✅ **API Docs:** http://localhost:8001/docs

#### **Terminal 2: Frontend Dev Server**
```bash
cd frontend

# Start Vite dev server
npm run dev

# You should see:
# VITE v5.4.10  ready in 500 ms
# ➜  Local:   http://localhost:5173/
```

✅ **Frontend:** http://localhost:5173

#### **Terminal 3: Watch Logs (Optional)**
```bash
cd docker
docker-compose logs -f

# Shows live logs from Neo4j and Redis
# Press Ctrl+C to stop
```

### Step 9: Test the Application

1. **Open the app:**
   - Go to http://localhost:5173 in your browser

2. **Log in:**
   - Email: `shubham.chougale@coditas.com`
   - Password: (any password will work in dev)

3. **Try the chatbot:**
   - Ask: "Who works on NeuraVault?"
   - Ask: "Show me all employees with Python skills"
   - Ask: "Who reports to the CEO?"

4. **Verify all components:**
   - ✅ Can log in
   - ✅ Chat works (get responses)
   - ✅ No console errors (check browser DevTools: F12)
   - ✅ No backend errors (check Terminal 1)

---

## ✅ Verification Checklist

| Component | How to Verify | Expected Result |
|---|---|---|
| **Node.js** | `node --version` | v18.0.0 or higher |
| **Python** | `python --version` | Python 3.10 or higher |
| **Docker** | `docker ps` | Neo4j and Redis containers running |
| **Backend** | http://localhost:8001/docs | FastAPI Swagger UI loads |
| **Frontend** | http://localhost:5173 | React app loads, login page visible |
| **Database** | http://localhost:7474 | Neo4j Browser loads |
| **Chat** | Login → Ask a question | Get a real answer about employees |

---

## 🐛 Troubleshooting

### Common Setup Errors

#### **"Python command not found"**
```bash
# You might have Python 3 but command is 'python3'
python3 --version
python3 -m venv venv

# Or add Python to PATH:
# Windows: https://docs.python.org/3/using/windows.html
# macOS: Install via Homebrew: brew install python
# Linux: sudo apt install python3
```

#### **"npm ERR! code ENOENT"**
```bash
# Clear npm cache and reinstall
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

#### **"Docker daemon not running"**
```bash
# Docker must be running
# Windows/Mac: Open Docker Desktop app
# Linux: sudo systemctl start docker
```

#### **"Connection refused" errors on backend startup**
```bash
# Neo4j or Redis isn't running
docker-compose up -d
docker ps  # Verify both containers are running

# Wait 10 seconds for services to fully start
sleep 10
```

#### **"GROQ_API_KEY not found" error**
```bash
# .env file not created or missing GROQ_API_KEY
cp .env.example .env
# Edit .env and add your Groq API key
```

#### **"Port 5173 already in use"**
```bash
# Another app is using port 5173
# Kill the process on that port:

# Windows:
netstat -ano | findstr :5173
taskkill /PID <PID> /F

# macOS/Linux:
lsof -i :5173
kill -9 <PID>

# Or change the port in frontend/vite.config.ts
```

#### **"ModuleNotFoundError: No module named 'fastapi'"**
```bash
# Python dependencies not installed
pip install -r backend/requirements.txt

# Verify:
pip list | grep fastapi
```

#### **Data loading fails ("Connection refused")**
```bash
# Make sure Neo4j is running
docker-compose up -d
docker logs neo4j  # Check Neo4j logs

# Wait for Neo4j to fully start (~30 seconds)
# Then try again:
python data/load_data.py
```

### Troubleshooting Prerequisites

#### **"Command not found: node"**
- Install Node.js: https://nodejs.org/
- After installing, restart your terminal
- Verify: `node --version`

#### **"Command not found: python"**
- Install Python 3.10+: https://www.python.org/
- After installing, restart your terminal
- Verify: `python --version` (or `python3 --version`)

#### **"Docker: command not found"**
- Install Docker Desktop: https://www.docker.com/products/docker-desktop
- After installing, restart your computer
- Verify: `docker --version`

#### **"Command not found: git"**
- Install Git: https://git-scm.com/
- Windows: Use Git Bash after installing
- After installing, restart your terminal
- Verify: `git --version`

### Getting Help

If you're stuck:

1. **Check the error message** — read it carefully, it usually tells you what's wrong
2. **Check Troubleshooting section** above — your error likely has a solution
3. **Check backend logs** — errors often appear in Terminal 1 (backend)
4. **Check browser console** — press F12, look for red errors
5. **Ask your team lead** — include:
   - Your OS (Windows/Mac/Linux)
   - The exact error message
   - What you were trying to do

---

## 📁 Project Structure

```
org-knowledge-hub/
├── backend/                    # FastAPI server
│   ├── main.py                # App entry point
│   ├── requirements.txt        # Python dependencies
│   ├── models/                # Data schemas (Pydantic)
│   ├── routes/                # API endpoints (/auth, /chat, /employees, etc.)
│   ├── controllers/           # Business logic
│   ├── services/              # Database, auth, cache, tracing
│   └── tools/                 # LangChain tools (NL→Cypher pipeline)
│
├── frontend/                   # React app
│   ├── src/
│   │   ├── pages/            # Full pages (LoginPage, ChatPage, etc.)
│   │   ├── components/       # Reusable React components
│   │   ├── services/         # API client (Axios)
│   │   ├── store/            # State management (Zustand)
│   │   └── types/            # TypeScript interfaces
│   ├── package.json          # JavaScript dependencies
│   └── vite.config.ts        # Build config
│
├── data/                       # Database seeds
│   ├── seeds/                 # Cypher migration files (11 total)
│   ├── load_data.py           # Script to load all seeds
│   └── requirements.txt       # Python dependencies
│
├── docker/                     # Container setup
│   └── docker-compose.yml     # Neo4j + Redis config
│
├── .env.example               # Template for environment variables
├── .gitignore                 # Git ignore rules
├── README.md                  # This file
├── CLAUDE.md                  # Claude Code guidance
├── CONTRIBUTING.md            # Contribution guide
└── GIT_WORKFLOW.md            # Git workflow & conventions
```

---

## 🔧 Development Workflow

### Making Changes

1. **Create a feature branch:**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   ```

2. **Make changes** (backend and/or frontend)

3. **Test locally** (both backend tests and manual UI testing)

4. **Commit with clear message:**
   ```bash
   git commit -m "feat(backend): add new endpoint"
   ```

5. **Push and create a PR:**
   ```bash
   git push -u origin feature/your-feature-name
   # Then create PR on GitHub
   ```

See [CONTRIBUTING.md](CONTRIBUTING.md) for full details.

---

## 📚 Documentation

| Document | Purpose |
|---|---|
| **README.md** (this file) | Setup & quickstart |
| **CONTRIBUTING.md** | How to contribute, coding standards |
| **GIT_WORKFLOW.md** | Git Flow, commit conventions, PR process |
| **GIT_STRATEGY.md** | What gets committed vs ignored for security |
| **CLAUDE.md** | Claude Code guidance for developers |

---

## 🎯 First Steps After Setup

### Option 1: Explore the App
- Log in at http://localhost:5173
- Try the chatbot with different questions
- Browse employees, projects, clients pages
- Check the org chart visualization

### Option 2: Read the Docs
- Open [CONTRIBUTING.md](CONTRIBUTING.md) — how to contribute
- Open [GIT_WORKFLOW.md](GIT_WORKFLOW.md) — Git conventions
- Read through the backend code (`backend/main.py`, `backend/controllers/`)

### Option 3: Run Tests
```bash
cd backend
pytest                    # Run all tests
pytest -v               # Verbose output
pytest tests/test_auth.py  # Test specific file
```

### Option 4: Start Coding
- Pick an issue from GitHub
- Create a feature branch
- Make changes
- Submit a PR

---

## 🔐 Security Notes

- **Never commit `.env`** — it contains API keys and secrets
- **Never commit `node_modules/` or `venv/`** — they're auto-generated
- **Never commit build output** (`dist/`, `build/`, `__pycache__/`)
- All these are in `.gitignore` — git will refuse to commit them

---

## 📞 Getting Help

### Common Questions

**Q: Which Python version do I need?**  
A: Python 3.10 or higher. Check with `python --version`

**Q: Can I use Python on Mac/Linux?**  
A: Yes! Setup is the same. Use `python3` if `python` doesn't work.

**Q: Do I need paid API keys?**  
A: No! Groq has a free tier. LangSmith tracing is optional.

**Q: Can I use a different database?**  
A: No, the app is built for Neo4j. But you can contribute support for others!

**Q: How do I stop the servers?**  
A: Press Ctrl+C in each terminal. For Docker: `docker-compose down`

### Contact

- **Questions about setup?** Create an issue on GitHub
- **Found a bug?** Create a GitHub issue with error details
- **Want to contribute?** See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📦 Tech Stack

| Layer | Technology | Version |
|---|---|---|
| **Frontend** | React + TypeScript + Vite | 18.3 / 5.6 / 5.4 |
| **Backend** | FastAPI + Pydantic | 0.115 / 2.9 |
| **LLM** | Groq + LangChain | llama-3.3-70b |
| **Database** | Neo4j | 5.18 |
| **Cache** | Redis | 7.0 |
| **Auth** | JWT (python-jose) | 3.3 |
| **Observability** | LangSmith | Latest |

---

## 🚀 Ready?

**You're all set!** Start with Step 1 above, and you'll have the app running in under 15 minutes.

Happy coding! 🎉

---

**Last Updated:** June 2, 2026  
**Repository:** https://github.com/ShubhamChougale01/org-knowledge-hub  
**Team:** Coditas
