"""Employee controller — list and detail queries with RBAC filtering."""

import logging
from typing import Optional

from fastapi import HTTPException, status

from services.graph import run_query, run_query_single
from services.auth import mask_pii, can_see_pii
from models.employee import (
    EmployeeResponse,
    EmployeeDetail,
    EmployeeSkill,
    EmployeeCertification,
    EmployeeProject,
    EmployeePromotion,
)
from models.auth import UserPayload

log = logging.getLogger(__name__)


async def list_employees(
    user: UserPayload,
    department: Optional[str] = None,
    project: Optional[str] = None,
    skill: Optional[str] = None,
    skip: int = 0,
    limit: int = 70,
) -> list[EmployeeResponse]:
    """List employees with optional filters. PII never included in list view."""

    conditions = []
    params: dict = {"skip": skip, "limit": limit}

    if department:
        conditions.append("d.name = $department")
        params["department"] = department
    if project:
        conditions.append("EXISTS { MATCH (e)-[:ASSIGNED_TO]->(:Project {name: $project}) }")
        params["project"] = project
    if skill:
        conditions.append("EXISTS { MATCH (e)-[:HAS_SKILL]->(:Skill {name: $skill}) }")
        params["skill"] = skill

    where = ("WHERE " + " AND ".join(conditions)) if conditions else ""

    cypher = f"""
        MATCH (e:Employee)
        OPTIONAL MATCH (e)-[:BELONGS_TO]->(d:Department)
        OPTIONAL MATCH (e)-[:HAS_ROLE {{is_current: true}}]->(r:Role)
        {where}
        RETURN e.employee_id AS employee_id,
               e.full_name   AS full_name,
               e.email       AS email,
               d.name        AS department,
               r.title       AS role,
               e.joining_date AS joining_date,
               e.current_status AS current_status
        ORDER BY e.full_name
        SKIP $skip LIMIT $limit
    """

    rows = run_query(cypher, params)
    return [EmployeeResponse(**row) for row in rows]


async def get_employee_detail(employee_id: str, user: UserPayload) -> EmployeeDetail:
    """Get full employee profile. PII masked unless user has permission."""

    base = run_query_single("""
        MATCH (e:Employee {employee_id: $id})
        OPTIONAL MATCH (e)-[:BELONGS_TO]->(d:Department)
        OPTIONAL MATCH (e)-[:HAS_ROLE {is_current: true}]->(r:Role)
        OPTIONAL MATCH (e)-[:REPORTS_TO]->(m:Employee)
        RETURN e.employee_id AS employee_id,
               e.full_name   AS full_name,
               e.email       AS email,
               e.phone       AS phone,
               e.dob         AS dob,
               e.address     AS address,
               e.gender      AS gender,
               e.joining_date AS joining_date,
               e.total_experience_years AS total_experience_years,
               e.org_experience_years   AS org_experience_years,
               e.current_status AS current_status,
               d.name        AS department,
               r.title       AS role,
               m.full_name   AS reports_to
    """, {"id": employee_id})

    if not base:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"Employee {employee_id} not found")

    # Apply PII mask
    own_profile = user.user_id == employee_id
    base = mask_pii(base, user.access_level, viewing_own_profile=own_profile)

    # Fetch related data
    skills = run_query("""
        MATCH (e:Employee {employee_id: $id})-[hs:HAS_SKILL]->(s:Skill)
        RETURN s.name AS name, s.category AS category,
               hs.proficiency AS proficiency, hs.years AS years
        ORDER BY hs.proficiency DESC, s.name
    """, {"id": employee_id})

    certs = run_query("""
        MATCH (e:Employee {employee_id: $id})-[:HAS_CERTIFICATION]->(c:Certification)
        RETURN c.name AS name, c.issuer AS issuer,
               c.issued_date AS issued_date, c.expiry_date AS expiry_date
        ORDER BY c.issued_date DESC
    """, {"id": employee_id})

    projects = run_query("""
        MATCH (e:Employee {employee_id: $id})-[a:ASSIGNED_TO]->(p:Project)
        RETURN p.name AS name, a.role_in_project AS role_in_project,
               a.is_current AS is_current,
               a.start_date AS start_date, a.end_date AS end_date
        ORDER BY a.is_current DESC, a.start_date DESC
    """, {"id": employee_id})

    promotions = run_query("""
        MATCH (e:Employee {employee_id: $id})-[:PROMOTED_TO]->(ph:PromotionHistory)
        RETURN ph.from_role AS from_role, ph.to_role AS to_role,
               ph.effective_date AS effective_date
        ORDER BY ph.effective_date DESC
    """, {"id": employee_id})

    return EmployeeDetail(
        **base,
        skills=[EmployeeSkill(**s) for s in skills],
        certifications=[EmployeeCertification(**c) for c in certs],
        projects=[EmployeeProject(**p) for p in projects],
        promotions=[EmployeePromotion(**p) for p in promotions],
    )


async def get_reporting_chain(employee_id: str, user: UserPayload) -> list[str]:
    """Return reporting chain from employee up to CEO."""
    result = run_query_single("""
        MATCH path = (e:Employee {employee_id: $id})-[:REPORTS_TO*]->(top:Employee)
        WHERE NOT (top)-[:REPORTS_TO]->()
        RETURN [n IN nodes(path) | n.full_name] AS chain
    """, {"id": employee_id})

    if not result:
        return []
    return result.get("chain", [])
