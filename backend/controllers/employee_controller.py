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
from models.rating import RatingExplanation, RatingDimensionBreakdown
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


async def get_rating_explanation(
    employee_id: str,
    project_id: str,
    period: Optional[str],
    user: UserPayload,
) -> RatingExplanation:
    """Get detailed rating explanation with breakdown for employee on project."""

    # Fetch employee name
    emp_result = run_query_single("""
        MATCH (e:Employee {employee_id: $emp_id})
        RETURN e.full_name AS name
    """, {"emp_id": employee_id})

    if not emp_result:
        raise HTTPException(status_code=404, detail="Employee not found")

    employee_name = emp_result.get("name", "Unknown")

    # Fetch project name
    proj_result = run_query_single("""
        MATCH (p:Project {project_id: $proj_id})
        RETURN p.name AS name
    """, {"proj_id": project_id})

    if not proj_result:
        raise HTTPException(status_code=404, detail="Project not found")

    project_name = proj_result.get("name", "Unknown")

    # Fetch overall rating and period (if not specified, get latest)
    if period:
        rating_result = run_query_single("""
            MATCH (e:Employee {employee_id: $emp_id})-[r:HAS_PROJECT_RATING {period: $period}]->(p:Project {project_id: $proj_id})
            RETURN r.overall_stars AS overall_stars,
                   r.period AS period,
                   r.calculation_date AS calculation_date,
                   r.calculation_method AS calculation_method
        """, {"emp_id": employee_id, "proj_id": project_id, "period": period})
    else:
        rating_result = run_query_single("""
            MATCH (e:Employee {employee_id: $emp_id})-[r:HAS_PROJECT_RATING]->(p:Project {project_id: $proj_id})
            RETURN r.overall_stars AS overall_stars,
                   r.period AS period,
                   r.calculation_date AS calculation_date,
                   r.calculation_method AS calculation_method
            ORDER BY r.calculation_date DESC
            LIMIT 1
        """, {"emp_id": employee_id, "proj_id": project_id})

    if not rating_result:
        raise HTTPException(
            status_code=404,
            detail=f"No rating found for employee {employee_id} on project {project_id}"
        )

    overall_stars = rating_result.get("overall_stars", 3.0)
    period = rating_result.get("period", "Unknown")
    calculation_date = rating_result.get("calculation_date")
    calculation_method = rating_result.get("calculation_method", "rules-v1.0")

    # Fetch rating breakdown (all dimensions)
    breakdown_results = run_query("""
        MATCH (e:Employee {employee_id: $emp_id})-[r:HAS_RATING_BREAKDOWN {period: $period}]->(p:Project {project_id: $proj_id})
        RETURN r.dimension AS dimension,
               r.dimension_stars AS dimension_stars,
               r.rule_id AS rule_id,
               r.metric_value AS metric_value,
               r.metric_type AS metric_type,
               r.weight AS weight,
               r.weighted_contribution AS weighted_contribution
        ORDER BY r.weight DESC
    """, {"emp_id": employee_id, "proj_id": project_id, "period": period})

    if not breakdown_results:
        raise HTTPException(
            status_code=404,
            detail="No rating breakdown found (database may be incomplete)"
        )

    # Map dimension to rule name and description
    dimension_info = {
        "PERFORMANCE": {
            "rule_name": "Task Completion",
            "description": "Percentage of assigned tasks completed on time"
        },
        "RELIABILITY": {
            "rule_name": "Punctuality & Attendance",
            "description": "Combined late days + absences (lower is better)"
        },
        "TEAMWORK": {
            "rule_name": "Behavior & Collaboration",
            "description": "Manager feedback on teamwork and communication"
        },
        "DEVELOPMENT": {
            "rule_name": "Learning & Growth",
            "description": "Certifications and new skills acquired"
        },
        "CRAFTSMANSHIP": {
            "rule_name": "Work Quality",
            "description": "Bug ratio (reported bugs / tasks completed)"
        },
    }

    # Format metric labels based on metric type
    breakdown = []
    for result in breakdown_results:
        dimension = result.get("dimension", "UNKNOWN")
        info = dimension_info.get(dimension, {
            "rule_name": dimension,
            "description": "Unknown rating dimension"
        })

        # Format metric label based on metric type
        metric_type = result.get("metric_type", "unknown")
        metric_value = result.get("metric_value", 0)

        if metric_type == "percentage":
            metric_label = f"{metric_value*100:.0f}% completion"
        elif metric_type == "days":
            metric_label = f"{int(metric_value)} penalty days"
        elif metric_type == "score":
            metric_label = f"Score: {int(metric_value)}/100"
        elif metric_type == "count":
            metric_label = f"{int(metric_value)} certifications/skills"
        elif metric_type == "ratio":
            metric_label = f"{metric_value*100:.1f}% bug ratio"
        else:
            metric_label = str(metric_value)

        breakdown.append(RatingDimensionBreakdown(
            dimension=dimension,
            rule_name=info["rule_name"],
            description=info["description"],
            dimension_stars=float(result.get("dimension_stars", 3)),
            metric_value=float(result.get("metric_value", 0)),
            metric_label=metric_label,
            metric_type=metric_type,
            weight=float(result.get("weight", 0.2)),
            weighted_contribution=float(result.get("weighted_contribution", 0))
        ))

    # Fetch RatingExplanation node for comments
    explanation_result = run_query_single("""
        MATCH (re:RatingExplanation {employee_id: $emp_id, project_id: $proj_id, period: $period})
        RETURN re.manager_comment AS manager_comment,
               re.system_comment AS system_comment
    """, {"emp_id": employee_id, "proj_id": project_id, "period": period})

    manager_comment = explanation_result.get("manager_comment") if explanation_result else None
    system_comment = explanation_result.get("system_comment") if explanation_result else None

    return RatingExplanation(
        employee_id=employee_id,
        employee_name=employee_name,
        project_id=project_id,
        project_name=project_name,
        period=period,
        overall_stars=overall_stars,
        breakdown=breakdown,
        calculation_date=calculation_date,
        calculation_method=calculation_method,
        manager_comment=manager_comment,
        system_comment=system_comment
    )
