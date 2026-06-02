"""Project controller — list and detail queries."""

import logging
from typing import Optional

from fastapi import HTTPException, status

from services.graph import run_query, run_query_single
from models.project import ProjectResponse, ProjectDetail, ProjectTeamMember
from models.auth import UserPayload

log = logging.getLogger(__name__)


async def list_projects(
    user: UserPayload,
    status_filter: Optional[str] = None,
) -> list[ProjectResponse]:
    """List all projects with team size + optional status filter."""

    where = ""
    params: dict = {}
    if status_filter:
        where = "WHERE p.status = $status"
        params["status"] = status_filter

    rows = run_query(f"""
        MATCH (p:Project)
        {where}
        OPTIONAL MATCH (e:Employee)-[:ASSIGNED_TO {{is_current: true}}]->(p)
        RETURN p.project_id AS project_id,
               p.name       AS name,
               p.type       AS type,
               p.status     AS status,
               p.client_name AS client_name,
               count(DISTINCT e) AS team_size
        ORDER BY p.status, p.name
    """, params)

    return [ProjectResponse(**row) for row in rows]


async def get_project_detail(project_id: str, user: UserPayload) -> ProjectDetail:
    """Get full project info + team list + manager."""

    base = run_query_single("""
        MATCH (p:Project {project_id: $id})
        OPTIONAL MATCH (mgr:Employee)-[:MANAGES_PROJECT]->(p)
        RETURN p.project_id   AS project_id,
               p.name         AS name,
               p.description  AS description,
               p.type         AS type,
               p.status       AS status,
               p.start_date   AS start_date,
               p.end_date     AS end_date,
               p.tech_stack   AS tech_stack,
               p.client_name  AS client_name,
               mgr.full_name  AS manager
    """, {"id": project_id})

    if not base:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"Project {project_id} not found")

    team_rows = run_query("""
        MATCH (e:Employee)-[a:ASSIGNED_TO]->(p:Project {project_id: $id})
        OPTIONAL MATCH (e)-[:HAS_ROLE {is_current: true}]->(r:Role)
        WHERE a.is_current = true
        RETURN e.employee_id AS employee_id,
               e.full_name   AS full_name,
               a.role_in_project AS role_in_project,
               r.title       AS designation
        ORDER BY e.full_name
    """, {"id": project_id})

    team = [ProjectTeamMember(**row) for row in team_rows]

    return ProjectDetail(
        **base,
        tech_stack=base.get("tech_stack") or [],
        team=team,
        team_size=len(team),
    )
