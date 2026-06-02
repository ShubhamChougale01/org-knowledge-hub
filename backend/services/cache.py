"""
Redis caching service.
Caches Cypher query results to avoid hitting Neo4j on every repeated request.

Cache strategy:
- Key: hash of (cypher_query + access_level) — same query at different access
       levels must cache separately because PII filtering differs
- Value: JSON-serialized result rows
- TTL: varies by data type (set in config.py)
- Failure mode: if Redis is down, cache silently returns None/no-op
                so the app keeps working without caching
"""

import json
import hashlib
import logging
from typing import Any, Optional

import redis

from config import REDIS_URL, CACHE_TTL_EMPLOYEE

log = logging.getLogger(__name__)

# ─── Singleton client ───────────────────────────────────────────────────
_client: Optional[redis.Redis] = None
_available: bool = False


def get_client() -> Optional[redis.Redis]:
    """Get or create the singleton Redis client. Returns None if Redis is down."""
    global _client, _available
    if _client is None:
        try:
            _client = redis.from_url(
                REDIS_URL,
                decode_responses=True,
                socket_connect_timeout=2,
                socket_timeout=2,
            )
            _client.ping()
            _available = True
            log.info(f"✅ Redis connected at {REDIS_URL}")
        except Exception as e:
            log.warning(f"⚠️  Redis unavailable at {REDIS_URL}: {e}. Caching disabled.")
            _client = None
            _available = False
    return _client


def close_client() -> None:
    """Close the Redis connection on app shutdown."""
    global _client, _available
    if _client is not None:
        try:
            _client.close()
        except Exception:
            pass
        _client = None
        _available = False


def is_available() -> bool:
    """Return True if Redis is connected and reachable."""
    return _available


# ─── Cache key generation ───────────────────────────────────────────────
def cache_key(cypher: str, access_level: str = "L4", namespace: str = "query") -> str:
    """
    Build a deterministic cache key from a Cypher query and access level.
    Same query at different access levels gets different keys (PII filtering differs).
    """
    raw = f"{namespace}:{access_level}:{cypher.strip()}"
    hashed = hashlib.sha256(raw.encode()).hexdigest()[:16]
    return f"okh:{namespace}:{access_level}:{hashed}"


# ─── Core operations ────────────────────────────────────────────────────
def get(key: str) -> Optional[Any]:
    """Read a cached value. Returns None on miss or if Redis is down."""
    client = get_client()
    if client is None:
        return None
    try:
        raw = client.get(key)
        if raw is None:
            return None
        return json.loads(raw)
    except Exception as e:
        log.warning(f"Cache GET failed for {key}: {e}")
        return None


def set(key: str, value: Any, ttl: int = CACHE_TTL_EMPLOYEE) -> bool:
    """Store a value with TTL (in seconds). Returns False if Redis is down."""
    client = get_client()
    if client is None:
        return False
    try:
        # default=str handles Neo4j Date/DateTime objects
        client.setex(key, ttl, json.dumps(value, default=str))
        return True
    except Exception as e:
        log.warning(f"Cache SET failed for {key}: {e}")
        return False


def delete(key: str) -> bool:
    """Delete a single key."""
    client = get_client()
    if client is None:
        return False
    try:
        client.delete(key)
        return True
    except Exception as e:
        log.warning(f"Cache DELETE failed for {key}: {e}")
        return False


def invalidate(pattern: str) -> int:
    """
    Delete all keys matching a pattern. Returns count deleted.
    Use sparingly — SCAN is more efficient than KEYS for large datasets.
    """
    client = get_client()
    if client is None:
        return 0
    try:
        deleted = 0
        for key in client.scan_iter(match=pattern):
            client.delete(key)
            deleted += 1
        return deleted
    except Exception as e:
        log.warning(f"Cache INVALIDATE failed for pattern {pattern}: {e}")
        return 0


def flush_all() -> bool:
    """Clear all cached entries for this app. Use only for admin actions."""
    return invalidate("okh:*") >= 0


# ─── Health check ───────────────────────────────────────────────────────
def health_check() -> dict[str, Any]:
    """Return Redis connection status."""
    client = get_client()
    if client is None:
        return {"redis": False, "url": REDIS_URL, "error": "unavailable"}
    try:
        info = client.info(section="server")
        return {
            "redis": True,
            "url": REDIS_URL,
            "version": info.get("redis_version", "unknown"),
        }
    except Exception as e:
        return {"redis": False, "url": REDIS_URL, "error": str(e)}
