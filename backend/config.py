"""
Central configuration loader.
All environment variables are read here once and exposed as module-level constants.
Every other file imports from here — no scattered os.getenv() calls anywhere else.

If a required env var is missing, the app fails at startup with a clear message
instead of failing mid-request.
"""

import os
import sys
from pathlib import Path
from dotenv import load_dotenv

# Load .env from the backend folder
BACKEND_DIR = Path(__file__).parent
load_dotenv(BACKEND_DIR / ".env")


def _required(key: str) -> str:
    """Read a required env var or exit with a clear error."""
    value = os.getenv(key)
    if not value:
        print(f"❌ Missing required environment variable: {key}")
        print(f"   Check that {BACKEND_DIR / '.env'} exists and contains {key}=...")
        sys.exit(1)
    return value


def _optional(key: str, default: str) -> str:
    """Read an optional env var with a fallback default."""
    return os.getenv(key, default)


# ─── Neo4j ──────────────────────────────────────────────────────────────
NEO4J_URI      = _required("NEO4J_URI")
NEO4J_USER     = _required("NEO4J_USER")
NEO4J_PASSWORD = _required("NEO4J_PASSWORD")

# ─── Groq LLM ────────────────────────────────────────────────────────────
GROQ_API_KEY   = _required("GROQ_API_KEY")
GROQ_MODEL     = _optional("GROQ_MODEL", "llama-3.1-8b-instant")
# llama-3.1-8b-instant (560 tps, high daily quota) — switch to llama-3.3-70b-versatile for max accuracy
# ─── LangSmith Tracing ───────────────────────────────────────────────────
LANGSMITH_API_KEY = _required("LANGSMITH_API_KEY")
LANGSMITH_PROJECT = _required("LANGSMITH_PROJECT")
LANGSMITH_ENDPOINT = _optional("LANGSMITH_ENDPOINT", "https://api.smith.langchain.com")

# ─── Redis Cache ─────────────────────────────────────────────────────────
REDIS_URL = _optional("REDIS_URL", "redis://localhost:6379")

# ─── JWT Auth ────────────────────────────────────────────────────────────
JWT_SECRET        = _required("JWT_SECRET")
JWT_ALGORITHM     = _optional("JWT_ALGORITHM", "HS256")
JWT_EXPIRES_HOURS = int(_optional("JWT_EXPIRES_HOURS", "8"))

# ─── Server ──────────────────────────────────────────────────────────────
BACKEND_PORT = int(_optional("BACKEND_PORT", "8000"))
BACKEND_HOST = _optional("BACKEND_HOST", "0.0.0.0")

# ─── Logging ─────────────────────────────────────────────────────────────
LOG_LEVEL = _optional("LOG_LEVEL", "INFO")

# ─── Cache TTLs (seconds) ────────────────────────────────────────────────
CACHE_TTL_EMPLOYEE = 300   # 5 minutes
CACHE_TTL_PROJECT  = 300
CACHE_TTL_CLIENT   = 600   # 10 minutes — clients change rarely
CACHE_TTL_ORG_CHART = 120  # 2 minutes
CACHE_TTL_ANALYTICS = 60   # 1 minute

# ─── Chatbot Behaviour ───────────────────────────────────────────────────
CYPHER_DEFAULT_LIMIT  = 70       # Default LIMIT on list queries
CYPHER_MAX_LIMIT      = 100      # Hard cap even if user asks "all"
RESULT_SUMMARY_THRESHOLD = 70    # If results > this, summarize instead of listing
CYPHER_RETRY_ON_INVALID  = True  # Retry once if first Cypher attempt is invalid


def summary() -> str:
    """Return a one-line summary of loaded config (for startup logging)."""
    return (
        f"Neo4j → {NEO4J_URI}  |  "
        f"LLM → {GROQ_MODEL}  |  "
        f"LangSmith → {LANGSMITH_PROJECT}  |  "
        f"Redis → {REDIS_URL}"
    )
