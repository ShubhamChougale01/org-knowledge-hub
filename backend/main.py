"""
FastAPI app entry point.

Startup sequence:
  1. Load config (fails fast on missing env vars)
  2. Setup LangSmith tracing
  3. Verify Neo4j connection
  4. Create performance indexes (idempotent)
  5. Verify Redis (optional, warns if down)
  6. Mount all routers
  7. Log ready
"""

import logging
import sys
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

import config
from services import graph, cache, langsmith_setup
from routes import (
    auth_routes,
    chat_routes,
    employee_routes,
    project_routes,
    client_routes,
)


# ─── Logging setup ──────────────────────────────────────────────────────
logging.basicConfig(
    level=config.LOG_LEVEL,
    format="%(asctime)s | %(levelname)-7s | %(name)s | %(message)s",
    datefmt="%H:%M:%S",
)
log = logging.getLogger("okh.main")


# ─── Lifespan handler (startup + shutdown) ───────────────────────────────
@asynccontextmanager
async def lifespan(app: FastAPI):
    log.info("=" * 60)
    log.info("🚀 Org Knowledge Hub — starting up")
    log.info("=" * 60)
    log.info(config.summary())

    # 1. LangSmith tracing
    langsmith_setup.setup()

    # 2. Neo4j connectivity
    try:
        graph.verify_connection()
        log.info("✅ Neo4j connection verified")
    except Exception as e:
        log.error(f"❌ Neo4j connection failed: {e}")
        sys.exit(1)

    # 3. Performance indexes
    try:
        count = graph.create_indexes()
        log.info(f"✅ {count} performance indexes ensured")
    except Exception as e:
        log.warning(f"⚠️  Index creation issue: {e}")

    # 4. Redis (optional)
    if cache.get_client() is not None:
        log.info("✅ Redis cache available")
    else:
        log.warning("⚠️  Redis unavailable — caching disabled, app continues")

    log.info("=" * 60)
    log.info(f"📡 API ready → http://{config.BACKEND_HOST}:{config.BACKEND_PORT}")
    log.info(f"📚 Docs      → http://localhost:{config.BACKEND_PORT}/docs")
    log.info("=" * 60)

    yield

    # ─── Shutdown ────────────────────────────────────────────────────
    log.info("Shutting down...")
    graph.close_driver()
    cache.close_client()
    log.info("✅ Clean shutdown")


# ─── App ────────────────────────────────────────────────────────────────
app = FastAPI(
    title="Org Knowledge Hub API",
    description="AI-powered knowledge graph chatbot for Coditas org data",
    version="1.0.0",
    lifespan=lifespan,
)

# CORS — allow frontend (Vite default port 5173 or 3000)
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "http://localhost:5173",
        "http://127.0.0.1:3000",
        "http://127.0.0.1:5173",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ─── Routers ────────────────────────────────────────────────────────────
app.include_router(auth_routes.router)
app.include_router(chat_routes.router)
app.include_router(employee_routes.router)
app.include_router(project_routes.router)
app.include_router(client_routes.router)


# ─── Health check (public) ──────────────────────────────────────────────
@app.get("/health", tags=["System"])
async def health():
    return {
        "status": "ok",
        "neo4j": graph.health_check(),
        "redis": cache.health_check(),
        "langsmith": langsmith_setup.health_check(),
    }


@app.get("/", tags=["System"])
async def root():
    return {
        "name": "Org Knowledge Hub API",
        "version": "1.0.0",
        "docs": "/docs",
        "health": "/health",
    }


# ─── Direct run support ─────────────────────────────────────────────────
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host=config.BACKEND_HOST,
        port=config.BACKEND_PORT,
        reload=True,
    )
