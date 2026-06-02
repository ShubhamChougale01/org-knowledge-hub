"""
Phase 2 Backtest Suite

Runs all critical scenarios end-to-end against the live graph + chatbot pipeline.
Run from the backend folder:

    cd backend
    python backtest.py

Exits 0 if all green, 1 if any check fails.
"""

import asyncio
import sys
from typing import Callable

# Force UTF-8 output on Windows so emojis don't crash the console
if sys.stdout.encoding and sys.stdout.encoding.lower() != "utf-8":
    try:
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    except Exception:
        pass

import config
from services import graph, cache, langsmith_setup
from services.auth import create_token, derive_access_level
from tools import cypher_generator, graph_executor, answer_formatter
from controllers import chat_controller, client_controller, employee_controller
from models.chat import ChatRequest
from models.auth import UserPayload


# ─── Test infrastructure ────────────────────────────────────────────────
passed = 0
failed = 0


def check(label: str, condition: bool, detail: str = "") -> None:
    global passed, failed
    if condition:
        print(f"  ✅  {label}")
        passed += 1
    else:
        print(f"  ❌  {label}")
        if detail:
            print(f"      → {detail}")
        failed += 1


async def section(title: str, fn: Callable) -> None:
    print(f"\n📦 {title}")
    try:
        await fn()
    except Exception as e:
        print(f"  ❌  Section crashed: {e}")
        global failed
        failed += 1


# ─── Test helpers ───────────────────────────────────────────────────────
def _make_user(level: str = "L4") -> UserPayload:
    return UserPayload(
        user_id="EMP-TEST",
        full_name="Test User",
        email="test@coditas.com",
        department="Tech",
        access_level=level,
    )


# ─── Test sections ──────────────────────────────────────────────────────
async def test_graph_integrity():
    rows = graph.run_query("MATCH (e:Employee) RETURN count(e) AS n")
    check("155 employees", rows[0]["n"] == 155, f"got {rows[0]['n']}")

    rows = graph.run_query("MATCH (c:Client) RETURN count(c) AS n")
    check("5 clients", rows[0]["n"] == 5)

    rows = graph.run_query("MATCH (p:Project) RETURN count(p) AS n")
    check("7 projects", rows[0]["n"] == 7)

    rows = graph.run_query("MATCH (c:Certification) RETURN count(c) AS n")
    check("120 certifications", rows[0]["n"] == 120)

    rows = graph.run_query("MATCH (ph:PromotionHistory) RETURN count(ph) AS n")
    check("66 promotions", rows[0]["n"] == 66)


async def test_shubham_profile():
    rows = graph.run_query(
        "MATCH (e:Employee {full_name: 'Shubham Chougale'}) RETURN e.org_experience_years AS y"
    )
    check("Shubham org_experience_years = 1.5",
          rows and rows[0]["y"] == 1.5, f"got {rows[0]['y'] if rows else 'none'}")

    rows = graph.run_query("""
        MATCH (e:Employee {full_name: 'Shubham Chougale'})-[:HAS_CERTIFICATION]->(c:Certification)
        WHERE c.name CONTAINS 'Neo4j'
        RETURN c.name AS n
    """)
    check("Shubham has Neo4j cert", len(rows) >= 1)

    rows = graph.run_query("""
        MATCH (e:Employee {full_name: 'Shubham Chougale'})-[:PROMOTED_TO]->(ph)
        RETURN ph.to_role AS r, ph.effective_date AS d
    """)
    check("Shubham promotion: Software Engineer 2025-06-30",
          rows and rows[0]["r"] == "Software Engineer"
          and str(rows[0]["d"]) == "2025-06-30")


async def test_indexes_created():
    n = graph.create_indexes()
    check(f"All {n} indexes created", n >= 9)


async def test_cypher_generator():
    res = await cypher_generator.generate_cypher("How many employees work in Tech?")
    check("Cypher generated for Tech headcount",
          res.valid, res.reason or "")
    check("Cypher contains MATCH and Tech",
          "MATCH" in res.cypher.upper() and "Tech" in res.cypher)

    res = await cypher_generator.generate_cypher(
        "How many projects does TechVentures Inc have and who works on them?"
    )
    check("Multi-hop Cypher generated", res.valid, res.reason or "")
    check("Cypher traverses Client and Employee",
          "Client" in res.cypher and "Employee" in res.cypher)


async def test_graph_executor():
    cypher = "MATCH (e:Employee)-[:BELONGS_TO]->(d:Department {name: 'Tech'}) RETURN count(e) AS n"
    result = await graph_executor.execute(cypher, "L4")
    check("Executor returns Tech headcount = 60",
          result.row_count >= 1 and result.rows[0].get("n") == 60,
          f"got {result.rows}")

    # Same query again — should hit cache
    result2 = await graph_executor.execute(cypher, "L4")
    check("Second call hits cache", result2.from_cache)


async def test_pii_masking():
    cypher = "MATCH (e:Employee {full_name: 'Shubham Chougale'}) RETURN e.full_name AS name, e.phone AS phone, e.dob AS dob"
    result = await graph_executor.execute(cypher, "L4")
    if result.rows:
        row = result.rows[0]
        check("L4 user does not see phone", row.get("phone") is None)
        check("L4 user does not see dob", row.get("dob") is None)


async def test_full_pipeline():
    user = _make_user("L4")

    req = ChatRequest(query="How many employees work in Tech?")
    resp = await chat_controller.handle_chat(req, user)
    check("Chat pipeline succeeds for Tech headcount", resp.success)
    check("Answer mentions a number", any(c.isdigit() for c in resp.answer))

    req = ChatRequest(query="How many projects does TechVentures Inc have?")
    resp = await chat_controller.handle_chat(req, user)
    check("Chat pipeline succeeds for client query", resp.success)


async def test_client_controller():
    user = _make_user("L4")

    clients = await client_controller.list_clients(user)
    check("List clients returns 5", len(clients) == 5)

    # Find TechVentures Inc's ID
    tv = next((c for c in clients if c.name == "TechVentures Inc"), None)
    check("TechVentures Inc exists", tv is not None)

    if tv:
        detail = await client_controller.get_client_detail(tv.client_id, user)
        check("TechVentures Inc has at least 1 project",
              detail.total_projects >= 1)
        check("TechVentures Inc detail returns project teams",
              len(detail.projects) >= 1)
        if detail.projects:
            check("NeuraVault team has members",
                  len(detail.projects[0].team) > 0,
                  f"projects: {[p.name for p in detail.projects]}")


async def test_employee_controller():
    user = _make_user("L4")

    emps = await employee_controller.list_employees(user, department="Tech", limit=10)
    check("List Tech employees returns results", len(emps) > 0)

    chain = await employee_controller.get_reporting_chain("EMP-TECH-010", user)
    check("Shubham reporting chain reaches CEO",
          "Rajesh Sharma" in chain, f"chain: {chain}")


# ─── Runner ─────────────────────────────────────────────────────────────
async def main():
    print("\n" + "=" * 60)
    print("🧪  Org Knowledge Hub — Phase 2 Backtest")
    print("=" * 60)

    langsmith_setup.setup()

    try:
        graph.verify_connection()
        print("✅ Neo4j connected\n")
    except Exception as e:
        print(f"❌ Cannot connect to Neo4j: {e}")
        sys.exit(1)

    await section("Graph Integrity",      test_graph_integrity)
    await section("Shubham Profile",      test_shubham_profile)
    await section("Performance Indexes",  test_indexes_created)
    await section("Cypher Generator",     test_cypher_generator)
    await section("Graph Executor",       test_graph_executor)
    await section("PII Masking (RBAC)",   test_pii_masking)
    await section("Full Chat Pipeline",   test_full_pipeline)
    await section("Client Controller",    test_client_controller)
    await section("Employee Controller",  test_employee_controller)

    graph.close_driver()
    cache.close_client()

    total = passed + failed
    print("\n" + "=" * 60)
    print(f"  Results: {passed}/{total} passed   |   {failed} failed")
    print("=" * 60)

    if failed == 0:
        print("  🎉 All checks passed — Phase 2 is ready!\n")
        sys.exit(0)
    else:
        print(f"  ⚠️  {failed} check(s) failed — review output above\n")
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
