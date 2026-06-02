"""
Tool 3 — Answer Formatter

Converts raw Neo4j query results into a natural language answer.

Edge cases handled:
  - 0 rows  → "No data found"
  - 1-70 rows → full natural language formatting via LLM
  - 70+ rows → "Found N results, showing first 70..."
  - Null values → skipped gracefully
"""

import json
import logging
from typing import Any

from langchain_groq import ChatGroq
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

from config import GROQ_API_KEY, GROQ_MODEL, RESULT_SUMMARY_THRESHOLD
from models.chat import GraphExecutionResult

log = logging.getLogger(__name__)


# ─── LLM (slightly more creative for natural language) ───────────────────
_llm = ChatGroq(
    model=GROQ_MODEL,
    api_key=GROQ_API_KEY,
    temperature=0.2,
    max_tokens=2000,   # enough room to list up to ~100 names
)


# ─── Prompt template ─────────────────────────────────────────────────────
_NO_DATA_SYSTEM_PROMPT = """You are a friendly HR assistant for Coditas organization.
The user asked a question but no matching data was found in the knowledge graph.

Your job is to:
1. Briefly acknowledge that you couldn't find the specific information they asked for.
2. If the question mentions a person, project, or sprint — suggest they double-check the spelling.
3. Suggest a related question they could ask instead (e.g., if asking about tasks → suggest asking about ratings or sprint performance).
4. Keep the tone helpful and concise (2-3 sentences max).

Never mention Neo4j, Cypher, queries, or technical details.
Never say "I don't know" — always offer a helpful next step.
"""

_NO_DATA_USER_PROMPT = """Question: {question}

No data was found. Generate a helpful response."""

_no_data_prompt = ChatPromptTemplate.from_messages([
    ("system", _NO_DATA_SYSTEM_PROMPT),
    ("user", _NO_DATA_USER_PROMPT),
])

_no_data_chain = _no_data_prompt | _llm | StrOutputParser()


_SYSTEM_PROMPT = """You are a friendly HR assistant for Coditas organization.
Your job is to take raw data from a Neo4j query and present it as a clear, factual answer.

GUIDELINES:
1. Always answer based ONLY on the data provided — never invent names, numbers, or facts.
2. Use the data EXACTLY as given. Do not skip names. Do not summarize lists with "and X others"
   unless the data was explicitly truncated by the system.
3. For results — answer in natural, conversational form. For example, if there is 1 CEO, say
   "The CEO of the company is [Name]."
4. For multiple results from "who" or "list" questions — present a clear summary line, then a
   bullet/numbered list of EVERY person. Do not abbreviate.
5. If a question asks "how many" — give the number first, then optionally the names.
6. If the data shows numbers, state them clearly.
7. Never mention SQL, Cypher, queries, or technical details.
8. Group people by role/designation if that information is present and makes the list readable.

FORMAT EXAMPLES:

Q: What is the CEO?
Data: [{{"full_name": "Rajesh Sharma", "title": "CEO"}}]
Answer: The CEO of the company is Rajesh Sharma.

Q: How many employees in Tech?
Data: [{{"headcount": 60}}]
Answer: The Tech department has 60 employees.

Q: Who works on OrgPulse?
Data: [{{"name": "Shubham Chougale", "role": "Senior Engineer"}}, {{"name": "Rahul Singh", "role": "Engineer"}}]
Answer: 2 employees currently work on OrgPulse:
• Shubham Chougale — Senior Engineer
• Rahul Singh — Engineer

Q: Who is the CFO?
Data: [{{"name": "Ananya Gupta", "title": "CFO", "department": "Finance"}}]
Answer: Ananya Gupta is the CFO of the Finance department.

Q: How many projects for TechVentures Inc and who works on them?
Data: [{{"client": "TechVentures Inc", "project": "NeuraVault", "team_size": 37, "employees": [...37 names...]}}]
Answer: TechVentures Inc has 1 active project — NeuraVault — with 37 team members:
• Priya Verma (Tech Lead)
• Ananya Gupta (PM/Architect)
• ... (list ALL 37 names from the data)

Q: Who has Neo4j certification?
Data: [{{"name": "Shubham Chougale", "cert": "Neo4j Certified Professional"}}, {{"name": "Priya Verma", "cert": "Neo4j Certified Professional"}}]
Answer: The following employees hold Neo4j certifications:
• Shubham Chougale — Neo4j Certified Professional
• Priya Verma — Neo4j Certified Professional

Q: How many stars does Ashok Desai have on NeuraVault?
Data: [{{"full_name": "Ashok Desai", "stars": 1, "completion_pct": 0.17, "tasks_completed": 5, "tasks_total": 30}}]
Answer: Ashok Desai has 1 star on NeuraVault, completing 5 out of 30 tasks (17%).

Q: What is Pooja Verma's performance on NeuraVault?
Data: [{{"full_name": "Pooja Verma", "stars": 2, "completion_pct": 0.4, "tasks_completed": 12, "tasks_total": 30}}]
Answer: Pooja Verma has earned 2 stars on NeuraVault, completing 12 out of 30 tasks (40%). She completed 40% of her assigned tasks.

Q: Who has 4 stars on NeuraVault?
Data: [{{"full_name": "Ravi Shankar", "stars": 4, "completion_pct": 0.93, "tasks_completed": 28, "tasks_total": 30}}, {{"full_name": "Satish Rao", "stars": 4, "completion_pct": 0.9, "tasks_completed": 27, "tasks_total": 30}}, {{"full_name": "Meena Yadav", "stars": 4, "completion_pct": 0.87, "tasks_completed": 26, "tasks_total": 30}}]
Answer: 3 employees have earned 4 stars on NeuraVault:
• Ravi Shankar (93% completion, 28/30 tasks)
• Satish Rao (90% completion, 27/30 tasks)
• Meena Yadav (87% completion, 26/30 tasks)

IMPORTANT: When data contains keys like "stars", "completion_pct", "tasks_completed", "tasks_total" — these are performance ratings. Always present them as star ratings with completion percentage. Never say "rating not available" when stars data is present.

TASK + RATING EXPLANATION — When the question asks both "which tasks did X complete" AND "how is the rating calculated":
- First list the completed tasks
- Then briefly explain: "The rating is based on task completion percentage — completing ≥80% earns 4 stars, ≥60% earns 3 stars, ≥40% earns 2 stars, and below 40% earns 1 star."

Q: Which tasks did Pooja Verma complete and on task basis we are rating them?
Data: [{{"full_name": "Pooja Verma", "task": "API Gateway", "feature_area": "API Gateway", "sprint": "Sprint 1", "completed_date": "2024-02-15"}}, ...]
Answer: Pooja Verma completed the following tasks on NeuraVault:

Sprint 1:
• API Gateway
• Analytics Engine
• (... list all tasks ...)

The rating is calculated based on task completion percentage across all sprints — completing ≥80% earns 4 stars, ≥60% earns 3 stars, ≥40% earns 2 stars, and below 40% earns 1 star.
"""

_USER_PROMPT = """{history_block}Question: {question}

Data returned ({row_count} rows{truncation_note}):
{data}

Provide a natural language answer."""


_prompt = ChatPromptTemplate.from_messages([
    ("system", _SYSTEM_PROMPT),
    ("user", _USER_PROMPT),
])

_chain = _prompt | _llm | StrOutputParser()


# ─── Helpers ─────────────────────────────────────────────────────────────
def _clean_rows(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """Remove null values to keep the LLM context clean."""
    cleaned = []
    for row in rows:
        clean_row = {k: v for k, v in row.items() if v is not None and v != []}
        if clean_row:
            cleaned.append(clean_row)
    return cleaned


# ─── Public entry point ──────────────────────────────────────────────────
async def format_answer(
    question: str,
    result: GraphExecutionResult,
    history: list[dict] = [],
) -> str:
    """
    Format the query result as a natural-language answer.

    Args:
        question: original user question (gives LLM context)
        result: GraphExecutionResult from graph_executor
        history: last 2 Q&A pairs for follow-up context (optional)

    Returns:
        Natural language answer string.
    """
    # Edge case: zero results — use LLM for a helpful, context-aware response
    if result.row_count == 0:
        try:
            no_data_answer = await _no_data_chain.ainvoke({"question": question})
            return no_data_answer.strip()
        except Exception:
            return ("I couldn't find any matching data for that question. "
                    "Try checking the spelling or rephrasing your query.")

    # Build history block to inject into prompt
    history_block = ""
    if history:
        lines = ["Previous conversation:"]
        for entry in history:
            lines.append(f"Q: {entry['question']}")
            lines.append(f"A: {entry['answer']}")
            lines.append("")
        lines.append("---\n")
        history_block = "\n".join(lines)

    # Clean nulls and serialize
    cleaned_rows = _clean_rows(result.rows)

    truncation_note = ""
    if result.truncated:
        truncation_note = (f" — showing first {RESULT_SUMMARY_THRESHOLD} "
                           f"of {result.row_count} total")

    data_str = json.dumps(cleaned_rows, default=str, indent=2)

    if len(data_str) > 12000:
        data_str = data_str[:12000] + "\n... (data truncated for context length)"

    answer = await _chain.ainvoke({
        "question": question,
        "history_block": history_block,
        "row_count": result.row_count,
        "truncation_note": truncation_note,
        "data": data_str,
    })

    return answer.strip()
