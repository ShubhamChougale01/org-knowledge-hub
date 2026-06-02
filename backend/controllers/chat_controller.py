"""
Chat Controller — orchestrates the 3-tool chatbot pipeline.

User question → Cypher → Neo4j → Natural language answer.
This is the only file that knows about the full pipeline order.
"""

import time
import uuid
import logging

from langsmith import traceable

from models.chat import ChatRequest, ChatResponse
from models.auth import UserPayload
from tools import cypher_generator, graph_executor, answer_formatter
from services.langsmith_setup import get_latest_trace_url
from services import memory

log = logging.getLogger(__name__)


@traceable(name="chat_pipeline", run_type="chain")
async def handle_chat(request: ChatRequest, user: UserPayload) -> ChatResponse:
    """
    Main chatbot pipeline.

    Args:
        request: User's natural language question
        user: Decoded JWT payload — provides access_level for RBAC

    Returns:
        ChatResponse with answer, cypher used, latency, and trace URL.
    """
    pipeline_start = time.time()
    run_id = str(uuid.uuid4())

    # ─── Conversation memory ─────────────────────────────────────────
    history = memory.get_history(request.session_id) if request.session_id else []

    # ─── Tool 1: Generate Cypher ─────────────────────────────────────
    try:
        cypher_result = await cypher_generator.generate_cypher(request.query, history=history)
    except Exception as e:
        log.error(f"Cypher generation crashed: {e}")
        return ChatResponse(
            answer="I had trouble understanding your question. Please try rephrasing it.",
            cypher_used="",
            execution_ms=int((time.time() - pipeline_start) * 1000),
            success=False,
            error=str(e),
        )

    if not cypher_result.valid:
        return ChatResponse(
            answer=("I could not generate a valid query for your question. "
                    "Try asking something like 'Who works on NeuraVault?' or "
                    "'How many employees in Tech?'"),
            cypher_used=cypher_result.cypher,
            execution_ms=int((time.time() - pipeline_start) * 1000),
            success=False,
            error=cypher_result.reason,
        )

    cypher = cypher_result.cypher

    # ─── Tool 2: Execute on Neo4j ────────────────────────────────────
    try:
        exec_result = await graph_executor.execute(cypher, user.access_level, cypher_result.params)
    except Exception as e:
        log.error(f"Graph execution crashed: {e}")
        return ChatResponse(
            answer="I had trouble fetching data from the knowledge graph. Please try again.",
            cypher_used=cypher,
            execution_ms=int((time.time() - pipeline_start) * 1000),
            success=False,
            error=str(e),
        )

    # ─── Tool 3: Format answer ───────────────────────────────────────
    try:
        answer = await answer_formatter.format_answer(request.query, exec_result, history=history)
    except Exception as e:
        log.error(f"Answer formatting crashed: {e}", exc_info=True)
        answer = ("I found the data but had trouble formatting the response. "
                  "Please try again or rephrase your question.")

    # ─── Save to memory ──────────────────────────────────────────────
    if request.session_id:
        memory.save(request.session_id, request.query, answer)

    elapsed_ms = int((time.time() - pipeline_start) * 1000)

    return ChatResponse(
        answer=answer,
        cypher_used=cypher,
        execution_ms=elapsed_ms,
        trace_url=get_latest_trace_url(run_id),
        from_cache=exec_result.from_cache,
        row_count=exec_result.row_count,
        success=True,
    )
