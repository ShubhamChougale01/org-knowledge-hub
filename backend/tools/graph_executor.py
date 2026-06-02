"""
Tool 2 — Graph Executor

Executes a validated Cypher query against Neo4j with caching and PII masking.

Flow:
  1. Build cache key (cypher + access_level)
  2. Check Redis → hit → return cached result
  3. Cache miss → execute on Neo4j
  4. Apply PII masking based on access_level
  5. Check result size — if > threshold, mark as truncated
  6. Store in Redis with appropriate TTL
  7. Return GraphExecutionResult
"""

import time
import logging

from config import (
    CACHE_TTL_EMPLOYEE,
    RESULT_SUMMARY_THRESHOLD,
)
from services.graph import run_query
from services import cache
from services.auth import mask_pii_list
from models.chat import GraphExecutionResult

log = logging.getLogger(__name__)


# ─── Heuristic to pick cache TTL based on query content ──────────────────
def _pick_ttl(cypher: str) -> int:
    """Choose appropriate cache TTL based on what the query targets."""
    upper = cypher.upper()
    if "CLIENT" in upper:
        return 600       # 10 min — clients change rarely
    if "COUNT(" in upper or "AVG(" in upper:
        return 60        # 1 min — analytics
    if "REPORTS_TO" in upper:
        return 120       # 2 min — org chart
    return CACHE_TTL_EMPLOYEE  # 5 min default


# ─── Public entry point ──────────────────────────────────────────────────
async def execute(cypher: str, access_level: str = "L4") -> GraphExecutionResult:
    """
    Execute a Cypher query and return rows.

    Args:
        cypher: validated Cypher query (must come from cypher_generator)
        access_level: user's RBAC level (used for PII masking and cache key)

    Returns:
        GraphExecutionResult with rows, row_count, cache info, latency
    """
    start = time.time()

    # 1. Cache check
    key = cache.cache_key(cypher, access_level=access_level, namespace="query")
    cached = cache.get(key)
    if cached is not None:
        return GraphExecutionResult(
            rows=cached.get("rows", []),
            row_count=cached.get("row_count", 0),
            from_cache=True,
            execution_ms=int((time.time() - start) * 1000),
            truncated=cached.get("truncated", False),
        )

    # 2. Execute on Neo4j
    try:
        rows = run_query(cypher)
    except Exception as e:
        log.error(f"Neo4j execution failed for: {cypher[:100]}... → {e}")
        raise

    # 3. Apply PII masking
    rows = mask_pii_list(rows, access_level)

    # 4. Check size — cap at threshold for LLM context safety
    total = len(rows)
    truncated = total > RESULT_SUMMARY_THRESHOLD
    if truncated:
        rows = rows[:RESULT_SUMMARY_THRESHOLD]

    elapsed = int((time.time() - start) * 1000)

    # 5. Cache result
    cache.set(
        key,
        {"rows": rows, "row_count": total, "truncated": truncated},
        ttl=_pick_ttl(cypher),
    )

    return GraphExecutionResult(
        rows=rows,
        row_count=total,
        from_cache=False,
        execution_ms=elapsed,
        truncated=truncated,
    )
