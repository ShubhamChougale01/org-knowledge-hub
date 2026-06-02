"""Project response models."""

from typing import Optional
from datetime import date
from pydantic import BaseModel, Field


class ProjectResponse(BaseModel):
    """List view of a project."""
    project_id: str
    name: str
    type: Optional[str] = None         # Client / Internal
    status: Optional[str] = None       # Active / Completed / On-hold
    client_name: Optional[str] = None
    team_size: int = 0


class ProjectTeamMember(BaseModel):
    employee_id: str
    full_name: str
    role_in_project: Optional[str] = None
    designation: Optional[str] = None  # actual role title in org


class ProjectDetail(BaseModel):
    project_id: str
    name: str
    description: Optional[str] = None
    type: Optional[str] = None
    status: Optional[str] = None
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    tech_stack: list[str] = Field(default_factory=list)
    client_name: Optional[str] = None
    team_size: int = 0
    manager: Optional[str] = None
    team: list[ProjectTeamMember] = Field(default_factory=list)
