"""
Seed script: Create Sprints, Tasks, and Performance Ratings for NeuraVault project.

This script:
1. Creates 2 sprints (Sprint 1 & 2) linked to NeuraVault
2. Creates 15 tasks per sprint (by feature area: Auth, Dashboard, API, Database, etc.)
3. Assigns tasks to the 35 NeuraVault employees
4. Varies completion rates to generate a spread of 1-5 star ratings
5. Stores HAS_SPRINT_RATING and HAS_PROJECT_RATING relationships with computed stars
"""

import sys
import os
from datetime import datetime, timedelta
import random

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from neo4j import GraphDatabase
from config import NEO4J_URI, NEO4J_USER, NEO4J_PASSWORD

STARS_THRESHOLD = {
    1.0: 5,
    0.8: 4,
    0.6: 3,
    0.4: 2,
}

def calc_stars(completion_pct: float) -> int:
    for threshold, stars in sorted(STARS_THRESHOLD.items(), reverse=True):
        if completion_pct >= threshold:
            return stars
    return 1

def seed_sprints_and_ratings():
    driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))

    with driver.session() as session:
        # Clean up previous seed data so re-runs are idempotent
        print("[CLEANUP] Removing old Sprint/Task/Rating data...")
        session.run("MATCH (s:Sprint) DETACH DELETE s")
        session.run("MATCH (t:Task) DETACH DELETE t")
        session.run("""
            MATCH ()-[r:HAS_PROJECT_RATING]->()
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
                for i, task in enumerate(tasks):
                    is_completed = i in completed_indices
                    session.run("""
                        MATCH (e:Employee {employee_id: $emp_id})
                        MATCH (t:Task {task_id: $task_id})
                        CREATE (e)-[:ASSIGNED_TASK {
                            assigned_date: $assigned_date,
                            completed: $completed,
                            completed_date: $completed_date
                        }]->(t)
                    """, {
                        'emp_id': emp_id,
                        'task_id': task['task_id'],
                        'assigned_date': start_date.isoformat(),
                        'completed': is_completed,
                        'completed_date': end_date.isoformat() if is_completed else None,
                    })

                # Calculate rating
                stars = calc_stars(completion_rate)

                # Create HAS_SPRINT_RATING relationship
                session.run("""
                    MATCH (e:Employee {employee_id: $emp_id})
                    MATCH (s:Sprint {sprint_id: $sprint_id})
                    CREATE (e)-[r:HAS_SPRINT_RATING {
                        stars: $stars,
                        completion_pct: $completion_pct,
                        tasks_completed: $tasks_completed,
                        tasks_total: $tasks_total
                    }]->(s)
                """, {
                    'emp_id': emp_id,
                    'sprint_id': sprint_id,
                    'stars': stars,
                    'completion_pct': round(completion_rate, 2),
                    'tasks_completed': tasks_to_complete,
                    'tasks_total': len(tasks),
                })

            print(f"  [OK] Assigned tasks to all {emp_count} employees with varied ratings")

        # Create HAS_PROJECT_RATING (aggregate across sprints)
        print(f"\n[RATING] Creating project-level ratings...")

        result = session.run("""
            MATCH (e:Employee)-[sr:HAS_SPRINT_RATING]->(s:Sprint)<-[:HAS_SPRINT]-(p:Project {name: 'NeuraVault'})
            WITH e, p,
                 collect(sr.tasks_completed) as completed_list,
                 collect(sr.tasks_total) as total_list
            WITH e, p,
                 reduce(total_completed = 0, x in completed_list | total_completed + x) as total_completed,
                 reduce(total_tasks = 0, x in total_list | total_tasks + x) as total_tasks
            RETURN e.employee_id as emp_id, total_completed, total_tasks
        """)

        for emp_record in result:
            emp_id = emp_record['emp_id']
            total_completed = emp_record['total_completed']
            total_tasks = emp_record['total_tasks']

            if total_tasks > 0:
                completion_pct = total_completed / total_tasks
                stars = calc_stars(completion_pct)

                session.run("""
                    MATCH (e:Employee {employee_id: $emp_id})
                    MATCH (p:Project {name: 'NeuraVault'})
                    MERGE (e)-[r:HAS_PROJECT_RATING]->(p)
                    SET r.stars = $stars,
                        r.completion_pct = $completion_pct,
                        r.tasks_completed = $total_completed,
                        r.tasks_total = $total_tasks
                """, {
                    'emp_id': emp_id,
                    'stars': stars,
                    'completion_pct': round(completion_pct, 2),
                    'total_completed': total_completed,
                    'total_tasks': total_tasks,
                })

        # Verify
        result = session.run("""
            MATCH (e:Employee)-[r:HAS_PROJECT_RATING]->(p:Project {name: 'NeuraVault'})
            WITH r.stars as stars, count(e) as count
            RETURN stars, count
            ORDER BY stars DESC
        """)

        print("\n[DONE] Project-level ratings created:")
        star_counts = {}
        for record in result:
            stars = record['stars']
            count = record['count']
            star_counts[stars] = count
            print(f"  {stars} stars: {count} employees")

        print(f"\n[SUCCESS] Seeding complete! {sum(star_counts.values())} employees rated on NeuraVault")

    driver.close()

if __name__ == "__main__":
    seed_sprints_and_ratings()
