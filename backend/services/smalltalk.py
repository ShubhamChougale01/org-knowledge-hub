"""
Small-talk / general-query handler.

The chat pipeline's only job is NL -> Cypher -> graph -> answer. But users also
send conversational messages that have no graph query behind them ("hi",
"thanks", "what can you do?"). Those can never produce a valid Cypher query, so
without this they fall through to the generic "I could not generate a valid
query" error, which reads as a failure.

`detect()` recognises these messages up front and returns a friendly canned
reply (or None if the message is a real data question and should go to the LLM).
No LLM call, no graph hit — it's pure pattern matching, so it's instant and free.
"""

import re

# What the bot can actually answer — kept in sync with the example questions in
# tools/cypher_generator.py. Reused by both the greeting and the help replies.
_CAPABILITIES = (
    "I answer questions about Coditas's org knowledge graph. You can ask me about:\n"
    "• **People** — \"Who works on NeuraVault?\", \"Who does Shubham Chougale report to?\"\n"
    "• **Departments** — \"How many employees are in Tech?\", \"Who are the department heads?\"\n"
    "• **Skills & certifications** — \"Who has AWS certification?\", \"Who knows Neo4j?\"\n"
    "• **Projects & clients** — \"Who works on TechVentures?\", \"What projects does SecureBank have?\"\n"
    "• **Ratings & performance** — \"What is Ravi Shankar's rating?\", \"Who has 5 stars?\", "
    "\"Why does Ashok Desai have 1 star?\"\n"
    "• **Tasks** — \"Which tasks did Pooja Verma complete?\", \"What's pending for Ravi Shankar?\""
)

_GREETING_REPLY = "Hi! 👋 " + _CAPABILITIES + "\n\nWhat would you like to know?"

_HELP_REPLY = _CAPABILITIES + "\n\nJust ask in plain English and I'll look it up."

_THANKS_REPLY = "You're welcome! Ask me anything else about the organization."

_BYE_REPLY = "Goodbye! Come back anytime you need to look something up about the team."

_IDENTITY_REPLY = (
    "I'm the Org Knowledge Hub assistant — I answer factual questions about Coditas "
    "by querying a live Neo4j knowledge graph (no guessing).\n\n" + _CAPABILITIES
)

# Single-word / short greeting tokens. Matched only when they make up essentially
# the whole message, so "Who is in Hyderabad?" doesn't trip on a stray "hi".
_GREETING_WORDS = {
    "hi", "hii", "hiii", "hey", "heya", "hiya", "hello", "helo", "hullo",
    "yo", "sup", "howdy", "hola", "namaste", "greetings", "gm", "gn",
}

# Multi-word phrases — matched as a prefix/standalone of the cleaned message.
_GREETING_PHRASES = (
    "good morning", "good afternoon", "good evening", "good day",
    "hello there", "hey there", "hi there",
)

_THANKS_PATTERNS = ("thank you", "thanks", "thank u", "thx", "ty ", "appreciate it", "cheers")

_BYE_PATTERNS = ("bye", "goodbye", "good bye", "see you", "see ya", "cya", "later")

_HELP_PATTERNS = (
    "help", "what can you do", "what can you tell me", "what do you know",
    "what can i ask", "what can i do", "how do you work", "how does this work",
    "what are you capable", "what can you answer", "show me what you can do",
    "examples", "what should i ask", "give me examples",
)

_IDENTITY_PATTERNS = (
    "who are you", "what are you", "what is this", "what's this",
    "your name", "what are u", "who r u", "tell me about yourself",
)


def _clean(text: str) -> str:
    """Lowercase and strip surrounding punctuation/whitespace for matching."""
    return re.sub(r"[^\w\s]", " ", text.lower()).strip()


def detect(question: str) -> str | None:
    """
    Return a canned reply if `question` is conversational small-talk / a general
    capability question, otherwise None (let the Cypher pipeline handle it).
    """
    cleaned = _clean(question)
    if not cleaned:
        return None

    words = cleaned.split()

    # Greetings: the whole message is a greeting word (optionally repeated, e.g. "hi hi"),
    # or starts with a greeting phrase.
    if words and all(w in _GREETING_WORDS for w in words):
        return _GREETING_REPLY
    if any(cleaned == p or cleaned.startswith(p + " ") for p in _GREETING_PHRASES):
        return _GREETING_REPLY

    # Identity / help / thanks / bye: substring match is fine — these phrases
    # rarely appear inside a genuine data question.
    if any(p in cleaned for p in _IDENTITY_PATTERNS):
        return _IDENTITY_REPLY
    if any(p in cleaned for p in _HELP_PATTERNS):
        return _HELP_REPLY
    if any(p in cleaned for p in _THANKS_PATTERNS):
        return _THANKS_REPLY
    # Farewell words are short — require the message to be brief so "see you" inside
    # a longer real question doesn't match.
    if len(words) <= 3 and any(p in cleaned for p in _BYE_PATTERNS):
        return _BYE_REPLY

    return None
