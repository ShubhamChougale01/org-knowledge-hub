"""Client response models — includes the XYZ-client multi-hop view."""

from typing import Optional
from pydantic import BaseModel, Field

from models.project import ProjectTeamMember


class ClientResponse(BaseModel):
    """List view of a client."""
    client_id: str
    name: str
    industry: Optional[str] = None
    country: Optional[str] = None
    total_projects: int = 0
    total_active_projects: int = 0


class ProjectWithTeam(BaseModel):
    """A project under a client, with full team listing."""
    project_id: str
    name: str
    status: Optional[str] = None
    tech_stack: list[str] = Field(default_factory=list)
    team_size: int = 0
    team: list[ProjectTeamMember] = Field(default_factory=list)


class ClientDetail(BaseModel):
    """Full client view — answers 'XYZ client → how many projects → who works there'."""
    client_id: str
    name: str
    industry: Optional[str] = None
    country: Optional[str] = None
    total_projects: int = 0
    total_employees: int = 0
    projects: list[ProjectWithTeam] = Field(default_factory=list)
