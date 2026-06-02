"""
Seed script: Create Sprints, Tasks, and Performance Ratings for NeuraVault project.

This script:
1. Creates 2 sprints (Sprint 1 & 2) linked to NeuraVault
2. Creates 15 tasks per sprint (by feature area: Auth, Dashboard, API, Database, etc.)
3. Assigns tasks to the 35 NeuraVault employees
4. Varies completion rates to generate a spread of 1-5 star ratings
5. Uses new RatingCalculator to compute multi-dimensional ratings
6. Stores HAS_PROJECT_RATING and HAS_RATING_BREAKDOWN relationships with full breakdown
"""

import sys
import os
from datetime import datetime, timedelta
import random

# Force UTF-8 on Windows so the star/check glyphs printed below don't crash the
# console (cp1252 can't encode ★ ✓ ✗). Mirrors data/load_data.py.
if sys.stdout.encoding and sys.stdout.encoding.lower() != "utf-8":
    try:
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    except Exception:
        pass

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from neo4j import GraphDatabase
from config import NEO4J_URI, NEO4J_USER, NEO4J_PASSWORD
from services.rating_calculator import RatingCalculator

def seed_sprints_and_ratings():
    driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
    calculator = RatingCalculator(driver)

    with driver.session() as session:
        # Clean up previous seed data so re-runs are idempotent
        print("[CLEANUP] Removing old Sprint/Task/Rating/Metric data...")
        session.run("MATCH (s:Sprint) DETACH DELETE s")
        session.run("MATCH (t:Task) DETACH DELETE t")
        session.run("MATCH (a:Attendance) DETACH DELETE a")
        session.run("MATCH (mf:ManagerFeedback) DETACH DELETE mf")
        session.run("MATCH (br:BugRatio) DETACH DELETE br")
        session.run("MATCH (re:RatingExplanation) DETACH DELETE re")
        session.run("MATCH ()-[r:HAS_SKILL_ACQUIRED]->() DELETE r")
        session.run("""
            MATCH ()-[r:HAS_PROJECT_RATING]->()
            DELETE r
        """)
        session.run("""
            MATCH ()-[r:HAS_RATING_BREAKDOWN]->()
            DELETE r
        """)
        print("[CLEANUP] Done.")

        # Get NeuraVault project & employees
        result = session.run("""
            MATCH (p:Project {name: 'NeuraVault'})<-[a:ASSIGNED_TO {is_current: true}]-(e:Employee)
            RETURN p, collect(e) as employees, count(e) as employee_count
        """)

        record = result.single()
        if not record:
            print("[ERROR] NeuraVault project not found or no active employees assigned")
            driver.close()
            return

        project = record['p']
        employees = record['employees']
        employee_count = record['employee_count']

        print(f"[OK] Found NeuraVault with {employee_count} active employees")

        # Define sprint periods and task features
        sprint_1_start = datetime(2024, 1, 1)
        sprint_1_end = datetime(2024, 2, 15)
        sprint_2_start = datetime(2024, 2, 16)
        sprint_2_end = datetime(2024, 3, 31)

        feature_areas = [
            "Authentication Module", "User Dashboard", "API Gateway", "Database Schema",
            "Real-time Notifications", "Analytics Engine", "Admin Panel", "Mobile Integration",
            "Payment Integration", "Reporting Module", "Search Indexing", "Caching Layer",
            "Security Audit", "Documentation", "Performance Optimization"
        ]

        sprints_data = [
            ("SPRINT-001", "Sprint 1", sprint_1_start, sprint_1_end),
            ("SPRINT-002", "Sprint 2", sprint_2_start, sprint_2_end),
        ]

        # Create sprints and tasks
        for sprint_id, sprint_name, start_date, end_date in sprints_data:
            print(f"\n[SPRINT] Creating {sprint_name}...")

            # Create sprint node
            session.run("""
                CREATE (s:Sprint {
                    sprint_id: $sprint_id,
                    name: $sprint_name,
                    start_date: $start_date,
                    end_date: $end_date,
                    status: 'Completed'
                })
                WITH s
                MATCH (p:Project {name: 'NeuraVault'})
                CREATE (p)-[:HAS_SPRINT]->(s)
            """, {
                'sprint_id': sprint_id,
                'sprint_name': sprint_name,
                'start_date': start_date.isoformat(),
                'end_date': end_date.isoformat(),
            })

            # Create 15 tasks
            tasks = []
            for i, feature in enumerate(feature_areas, 1):
                task_id = f"{sprint_id}-TASK-{i:02d}"
                tasks.append({"task_id": task_id, "feature": feature})

                session.run("""
                    CREATE (t:Task {
                        task_id: $task_id,
                        title: $feature,
                        feature_area: $feature,
                        status: 'Not-Started'
                    })
                    WITH t
                    MATCH (s:Sprint {sprint_id: $sprint_id})
                    CREATE (s)-[:HAS_TASK]->(t)
                """, {
                    'task_id': task_id,
                    'feature': feature,
                    'sprint_id': sprint_id,
                })

            print(f"  [OK] Created 15 tasks for {sprint_name}")

            # Assign tasks to employees with varied completion
            emp_count = len(employees)
            for emp_idx, emp in enumerate(employees):
                emp_id = emp['employee_id']
                emp_name = emp['full_name']

                # Vary completion rate per employee to get spread of ratings
                # 1st 7 employees: ~100% (5 stars)
                # Next 7 employees: ~80% (4 stars)
                # Next 7 employees: ~60% (3 stars)
                # Next 7 employees: ~40% (2 stars)
                # Last 7 employees: ~20% (1 star)

                if emp_idx < 7:
                    completion_rate = random.uniform(0.95, 1.0)
                elif emp_idx < 14:
                    completion_rate = random.uniform(0.75, 0.85)
                elif emp_idx < 21:
                    completion_rate = random.uniform(0.55, 0.65)
                elif emp_idx < 28:
                    completion_rate = random.uniform(0.35, 0.45)
                else:
                    completion_rate = random.uniform(0.15, 0.25)

                # Assign & mark tasks as completed based on rate
                tasks_to_complete = int(len(tasks) * completion_rate)
                completed_indices = set(random.sample(range(len(tasks)), tasks_to_complete))

                # Assign all tasks to employee with per-employee completion flag on the relationship
                # Add period to support RatingCalculator's metric calculation
                period = f"{start_date.year}-Q{(start_date.month - 1) // 3 + 1}"
                for i, task in enumerate(tasks):
                    is_completed = i in completed_indices
                    session.run("""
                        MATCH (e:Employee {employee_id: $emp_id})
                        MATCH (t:Task {task_id: $task_id})
                        CREATE (e)-[:ASSIGNED_TASK {
                            assigned_date: $assigned_date,
                            completed: $completed,
                            completed_date: $completed_date,
                            period: $period
                        }]->(t)
                    """, {
                        'emp_id': emp_id,
                        'task_id': task['task_id'],
                        'assigned_date': start_date.isoformat(),
                        'completed': is_completed,
                        'completed_date': end_date.isoformat() if is_completed else None,
                        'period': period
                    })

            print(f"  [OK] Assigned tasks to all {emp_count} employees with varied ratings")

        # Get NeuraVault project ID (needed for both metric seeding and ratings)
        result = session.run("MATCH (p:Project {name: 'NeuraVault'}) RETURN p.project_id as project_id")
        project_id = result.single()['project_id']

        # ─── Seed the 4 non-PERFORMANCE dimension metrics ────────────────
        # Each employee's metrics are correlated to their performance tier
        # (emp_idx // 7: tier 0 = top performers, tier 4 = lowest) with random
        # intra-band noise, so the overall rating spreads across the full 1-5 stars.
        period = "2024-Q1"  # same period the sprints fall in
        print(f"\n[METRICS] Seeding Attendance / ManagerFeedback / BugRatio / skills ({period})...")

        # Pull some skills once so we can attach "acquired" skills per employee
        skill_rows = session.run("MATCH (s:Skill) RETURN s.skill_id AS skill_id LIMIT 25")
        skill_ids = [r["skill_id"] for r in skill_rows]

        # Per-tier metric bands: (penalty_days, feedback_score, bug_ratio, skills_acquired)
        # Bands map directly onto the threshold cutoffs in 12_rating_rules.cypher.
        tier_bands = [
            {"penalty": (0, 5),   "feedback": (90, 100), "bug": (0.00, 0.05), "skills": 3},  # tier 0 → 5★
            {"penalty": (6, 10),  "feedback": (80, 89),  "bug": (0.05, 0.10), "skills": 2},  # tier 1 → 4★
            {"penalty": (11, 15), "feedback": (70, 79),  "bug": (0.10, 0.20), "skills": 1},  # tier 2 → 3★
            {"penalty": (16, 20), "feedback": (60, 69),  "bug": (0.20, 0.40), "skills": 1},  # tier 3 → 2★
            {"penalty": (21, 28), "feedback": (45, 59),  "bug": (0.40, 0.55), "skills": 0},  # tier 4 → 1★
        ]

        for emp_idx, emp in enumerate(employees):
            emp_id = emp['employee_id']
            tier = min(emp_idx // 7, 4)
            band = tier_bands[tier]

            # --- RELIABILITY: Attendance ---
            penalty = random.randint(*band["penalty"])
            late = random.randint(0, penalty)
            absence = penalty - late
            session.run("""
                MATCH (e:Employee {employee_id: $emp_id})
                MERGE (a:Attendance {attendance_id: $att_id})
                SET a.period = $period,
                    a.total_penalty_days = $penalty,
                    a.late_days = $late,
                    a.absence_days = $absence
                MERGE (e)-[:HAS_ATTENDANCE]->(a)
            """, {
                'emp_id': emp_id,
                'att_id': f"ATT-{emp_id}-{period}",
                'period': period, 'penalty': penalty, 'late': late, 'absence': absence,
            })

            # --- TEAMWORK: ManagerFeedback ---
            score = random.randint(*band["feedback"])
            session.run("""
                MATCH (e:Employee {employee_id: $emp_id})
                MERGE (mf:ManagerFeedback {feedback_id: $fb_id})
                SET mf.period = $period,
                    mf.feedback_score = $score,
                    mf.feedback_comment = $comment
                MERGE (mf)-[:RATED_EMPLOYEE]->(e)
            """, {
                'emp_id': emp_id,
                'fb_id': f"FB-{emp_id}-{period}",
                'period': period, 'score': score,
                'comment': f"Manager feedback score {score}/100 for {period}",
            })

            # --- CRAFTSMANSHIP: BugRatio ---
            ratio = round(random.uniform(*band["bug"]), 3)
            tasks_completed = random.randint(10, 30)
            bugs_reported = int(round(ratio * tasks_completed))
            session.run("""
                MATCH (e:Employee {employee_id: $emp_id})
                MERGE (br:BugRatio {bug_ratio_id: $br_id})
                SET br.period = $period,
                    br.project_id = $project_id,
                    br.bug_ratio = $ratio,
                    br.bugs_reported = $bugs,
                    br.tasks_completed = $tasks
                MERGE (e)-[:HAS_BUG_RATIO {period: $period}]->(br)
            """, {
                'emp_id': emp_id,
                'br_id': f"BUG-{emp_id}-{period}",
                'period': period, 'project_id': project_id,
                'ratio': ratio, 'bugs': bugs_reported, 'tasks': tasks_completed,
            })

            # --- DEVELOPMENT: HAS_SKILL_ACQUIRED (skills gained within the period) ---
            n_skills = min(band["skills"], len(skill_ids))
            if n_skills > 0:
                acquired = random.sample(skill_ids, n_skills)
                for sk in acquired:
                    session.run("""
                        MATCH (e:Employee {employee_id: $emp_id})
                        MATCH (s:Skill {skill_id: $skill_id})
                        MERGE (e)-[r:HAS_SKILL_ACQUIRED]->(s)
                        SET r.acquired_date = date($acquired_date)
                    """, {
                        'emp_id': emp_id, 'skill_id': sk,
                        'acquired_date': '2024-01-15',
                    })

        print(f"  [OK] Seeded metrics for all {len(employees)} employees across 5 tiers")

        # Create HAS_PROJECT_RATING using RatingCalculator
        print(f"\n[RATING] Creating multi-dimensional project-level ratings...")

        # Get all employees assigned to NeuraVault — eagerly fetch before rating loop
        # to avoid cursor conflict when RatingCalculator opens its own sessions
        emp_result = session.run("""
            MATCH (e:Employee)-[:ASSIGNED_TO {is_current: true}]->(p:Project {name: 'NeuraVault'})
            RETURN e.employee_id as emp_id, e.full_name as emp_name
        """)
        emp_list = [{"emp_id": r["emp_id"], "emp_name": r["emp_name"]} for r in emp_result]

        period = "2024-Q1"  # Use same period as sprints
        ratings_count = 0

        for emp_record in emp_list:
            emp_id = emp_record['emp_id']
            emp_name = emp_record['emp_name']

            try:
                # Calculate multi-dimensional rating using RatingCalculator
                rating_result = calculator.calculate_overall_rating(emp_id, project_id, period)
                overall_stars = rating_result['overall_stars']
                breakdown = rating_result['breakdown']

                # Store rating and breakdown in Neo4j
                success = calculator.store_rating_with_breakdown(
                    employee_id=emp_id,
                    project_id=project_id,
                    period=period,
                    overall_stars=overall_stars,
                    breakdown=breakdown,
                    system_comment=f"Auto-generated rating based on {len(breakdown)} dimensions"
                )

                if success:
                    ratings_count += 1
                    print(f"  ✓ {emp_name}: {overall_stars}★")

            except Exception as e:
                print(f"  ✗ {emp_name}: Error - {str(e)}")

        # Verify ratings created
        result = session.run("""
            MATCH (e:Employee)-[r:HAS_PROJECT_RATING {period: $period}]->(p:Project {name: 'NeuraVault'})
            WITH r.overall_stars as stars, count(e) as count
            RETURN stars, count
            ORDER BY stars DESC
        """, period=period)

        print("\n[DONE] Multi-dimensional ratings created:")
        star_counts = {}
        for record in result:
            stars = record['stars']
            count = record['count']
            star_counts[stars] = count
            print(f"  {stars}★: {count} employees")

        total_rated = sum(star_counts.values())
        print(f"\n[SUCCESS] Seeding complete!")
        print(f"  • Created {len(sprints_data)} sprints with {len(sprints_data) * len(feature_areas)} tasks")
        print(f"  • Assigned tasks to {employee_count} employees")
        print(f"  • Generated {total_rated} multi-dimensional ratings with breakdown")
        print(f"  • Rating dimensions: Task Completion, Punctuality, Behavior, Learning, Quality")

    driver.close()

if __name__ == "__main__":
    seed_sprints_and_ratings()
