"""Chatbot request/response models."""

from typing import Optional, Any
from pydantic import BaseModel, Field


class ChatRequest(BaseModel):
    query: str = Field(..., min_length=1, max_length=1000,
                       description="The user's natural language question")
    session_id: Optional[str] = Field(None, description="Optional session ID for grouping conversations")


class ChatResponse(BaseModel):
    answer: str
    cypher_used: str
    execution_ms: int
    trace_url: Optional[str] = None
    from_cache: bool = False
    row_count: int = 0
    success: bool = True
    error: Optional[str] = None


class CypherValidationResult(BaseModel):
    valid: bool
    cypher: str
    reason: Optional[str] = None
    params: dict = Field(default_factory=dict)


class GraphExecutionResult(BaseModel):
    rows: list[dict[str, Any]]
    row_count: int
    from_cache: bool
    execution_ms: int
    truncated: bool = False
