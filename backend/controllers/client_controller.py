"""
Client controller — the XYZ client scenario.

GET /clients              → list all clients with project counts
GET /clients/{id}         → full client detail: client → projects → all employees
"""

import logging
from fastapi import HTTPException, status

from services.graph import run_query, run_query_single
from models.client import ClientResponse, ClientDetail, ProjectWithTeam
from models.project import ProjectTeamMember
from models.auth import UserPayload

log = logging.getLogger(__name__)


async def list_clients(user: UserPayload) -> list[ClientResponse]:
    """List all clients with project counts."""
    rows = run_query("""
        MATCH (c:Client)
        OPTIONAL MATCH (c)<-[:FOR_CLIENT]-(p:Project)
        WITH c, count(DISTINCT p) AS total_projects,
             count(DISTINCT CASE WHEN p.status = 'Active' THEN p END) AS active
        RETURN c.client_id AS client_id,
               c.name      AS name,
               c.industry  AS industry,
               c.country   AS country,
               total_projects,
               active AS total_active_projects
        ORDER BY c.name
    """)
    return [ClientResponse(**row) for row in rows]


async def get_client_detail(client_id: str, user: UserPayload) -> ClientDetail:
    """
    Full client view — projects + all employees per project.
    This is the XYZ scenario: 'How many projects and who works on them?'
    """
    base = run_query_single("""
        MATCH (c:Client {client_id: $id})
        OPTIONAL MATCH (c)<-[:FOR_CLIENT]-(p:Project)
        OPTIONAL MATCH (e:Employee)-[:ASSIGNED_TO {is_current: true}]->(p)
        RETURN c.client_id AS client_id,
               c.name      AS name,
               c.industry  AS industry,
               c.country   AS country,
               count(DISTINCT p) AS total_projects,
               count(DISTINCT e) AS total_employees
    """, {"id": client_id})

    if not base or not base.get("name"):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"Client {client_id} not found")

    # Fetch all projects for this client with their teams
    project_rows = run_query("""
        MATCH (c:Client {client_id: $id})<-[:FOR_CLIENT]-(p:Project)
        OPTIONAL MATCH (e:Employee)-[a:ASSIGNED_TO]->(p)
        OPTIONAL MATCH (e)-[:HAS_ROLE {is_current: true}]->(r:Role)
        WHERE a.is_current = true
        RETURN p.project_id  AS project_id,
               p.name        AS name,
               p.status      AS status,
               p.tech_stack  AS tech_stack,
               collect(DISTINCT {
                   employee_id: e.employee_id,
                   full_name:   e.full_name,
                   role_in_project: a.role_in_project,
                   designation: r.title
               }) AS team
        ORDER BY p.status, p.name
    """, {"id": client_id})

    projects: list[ProjectWithTeam] = []
    for row in project_rows:
        team_raw = row.get("team") or []
        # filter out null entries from collect()
        team = [
            ProjectTeamMember(**t)
            for t in team_raw
            if t.get("employee_id") and t.get("full_name")
        ]
        projects.append(ProjectWithTeam(
            project_id=row["project_id"],
            name=row["name"],
            status=row.get("status"),
            tech_stack=row.get("tech_stack") or [],
            team_size=len(team),
            team=team,
        ))

    return ClientDetail(
        client_id=base["client_id"],
        name=base["name"],
        industry=base.get("industry"),
        country=base.get("country"),
        total_projects=base["total_projects"],
        total_employees=base["total_employees"],
        projects=projects,
    )
