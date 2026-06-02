"""
Conversation memory service.

Stores the last 2 Q&A pairs per session in Redis so the LLM can answer
follow-up questions like "why?" with context from the previous response.

Key format: okh:memory:{session_id}
Value:      JSON list of up to 2 {question, answer} dicts
TTL:        1800s (30 minutes)
"""

import json
import logging
from typing import Any

from services.cache import get_client

log = logging.getLogger(__name__)

_MEMORY_TTL = 1800       # 30 minutes
_MAX_HISTORY = 2         # keep last 2 Q&A pairs
_KEY_PREFIX = "okh:memory:"


def _key(session_id: str) -> str:
    return f"{_KEY_PREFIX}{session_id}"


def get_history(session_id: str) -> list[dict[str, Any]]:
    """Return last 2 Q&A pairs for the session. Returns [] if none or Redis is down."""
    client = get_client()
    if not client:
        return []
    try:
        raw = client.get(_key(session_id))
        if not raw:
            return []
        return json.loads(raw)
    except Exception as e:
        log.warning(f"Memory GET failed for session {session_id}: {e}")
        return []


def save(session_id: str, question: str, answer: str) -> None:
    """Append Q&A to history, keeping only the last 2 entries."""
    client = get_client()
    if not client:
        return
    try:
        history = get_history(session_id)
        history.append({"question": question, "answer": answer})
        history = history[-_MAX_HISTORY:]   # keep last 2 only
        client.set(_key(session_id), json.dumps(history), ex=_MEMORY_TTL)
    except Exception as e:
        log.warning(f"Memory SAVE failed for session {session_id}: {e}")


def clear(session_id: str) -> None:
    """Delete the memory for a session (e.g. on logout)."""
    client = get_client()
    if not client:
        return
    try:
        client.delete(_key(session_id))
    except Exception as e:
        log.warning(f"Memory CLEAR failed for session {session_id}: {e}")
