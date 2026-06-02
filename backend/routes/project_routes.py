"""Project routes."""

from typing import Optional
from fastapi import APIRouter, Depends, Query

from controllers import project_controller
from models.project import ProjectResponse, ProjectDetail
from models.auth import UserPayload
from routes.dependencies import get_current_user


router = APIRouter(prefix="/projects", tags=["Projects"])


@router.get("", response_model=list[ProjectResponse])
async def list_projects(
    status: Optional[str] = Query(None, description="Active / Completed / On-hold"),
    user: UserPayload = Depends(get_current_user),
):
    return await project_controller.list_projects(user, status)


@router.get("/{project_id}", response_model=ProjectDetail)
async def get_project(
    project_id: str,
    user: UserPayload = Depends(get_current_user),
):
    return await project_controller.get_project_detail(project_id, user)
