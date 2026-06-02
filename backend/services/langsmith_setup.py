"""
LangSmith tracing setup.

LangChain automatically sends traces to LangSmith when these 4 environment
variables are set. We set them programmatically at app startup so that every
LLM call, tool invocation, and chain step is captured in the LangSmith dashboard.

View traces at: https://smith.langchain.com → project 'org-knowledge-hub'

Each chatbot run produces one parent trace with 3 child spans:
  1. CypherGeneratorTool   — input prompt + generated Cypher + tokens
  2. GraphExecutorTool     — Cypher executed + rows returned + cache hit/miss
  3. AnswerFormatterTool   — raw data input + natural language answer

To find the latest trace programmatically (for returning a trace_url in
ChatResponse), we use the LangSmith client to look up the most recent run
for the current session.
"""

import os
import logging
from typing import Optional

from langsmith import Client

from config import (
    LANGSMITH_API_KEY,
    LANGSMITH_PROJECT,
    LANGSMITH_ENDPOINT,
)

log = logging.getLogger(__name__)


_client: Optional[Client] = None
_enabled: bool = False


def setup() -> bool:
    """
    Enable LangSmith tracing globally. Called once at app startup.
    After this, every LangChain operation is automatically traced.

    Returns: True if setup succeeded, False if LangSmith is unreachable.
    """
    global _client, _enabled

    # Set the env vars that LangChain reads to enable auto-tracing
    os.environ["LANGCHAIN_TRACING_V2"] = "true"
    os.environ["LANGCHAIN_API_KEY"]    = LANGSMITH_API_KEY
    os.environ["LANGCHAIN_PROJECT"]    = LANGSMITH_PROJECT
    os.environ["LANGCHAIN_ENDPOINT"]   = LANGSMITH_ENDPOINT

    # Try to create a client to verify the key works
    try:
        _client = Client(api_url=LANGSMITH_ENDPOINT, api_key=LANGSMITH_API_KEY)
        _enabled = True
        log.info(f"✅ LangSmith tracing enabled → project '{LANGSMITH_PROJECT}'")
        return True
    except Exception as e:
        _enabled = False
        log.warning(
            f"⚠️  LangSmith setup failed: {e}. "
            f"Traces will not be captured. App will continue without tracing."
        )
        return False


def is_enabled() -> bool:
    """Return True if LangSmith tracing is active."""
    return _enabled


def get_client() -> Optional[Client]:
    """Get the LangSmith client (used to fetch trace URLs)."""
    return _client


def get_latest_trace_url(run_id: Optional[str] = None) -> Optional[str]:
    """
    Build the LangSmith dashboard URL for a specific run.
    If no run_id given, returns the project URL.

    Used by the chat controller to include a trace_url in ChatResponse,
    so frontend can show a 'View trace ↗' link next to every answer.
    """
    if not _enabled:
        return None

    # Strip the /api prefix from endpoint to get the web dashboard URL
    web_base = LANGSMITH_ENDPOINT.replace("api.", "").replace("/api", "")
    if web_base.endswith(".com"):
        web_base = web_base.replace(".com", ".com")

    # Standard LangSmith URL pattern
    if run_id:
        return f"https://smith.langchain.com/o/-/projects/p/{LANGSMITH_PROJECT}/r/{run_id}"
    return f"https://smith.langchain.com/o/-/projects/p/{LANGSMITH_PROJECT}"


def health_check() -> dict:
    """Return LangSmith tracing status for the /health endpoint."""
    return {
        "langsmith": _enabled,
        "project": LANGSMITH_PROJECT if _enabled else None,
        "endpoint": LANGSMITH_ENDPOINT if _enabled else None,
    }
