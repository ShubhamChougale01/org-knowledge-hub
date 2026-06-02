"""Employee routes."""

from typing import Optional
from fastapi import APIRouter, Depends, Query

from controllers import employee_controller
from models.employee import EmployeeResponse, EmployeeDetail
from models.auth import UserPayload
from routes.dependencies import get_current_user


router = APIRouter(prefix="/employees", tags=["Employees"])


@router.get("", response_model=list[EmployeeResponse])
async def list_employees(
    department: Optional[str] = Query(None),
    project: Optional[str] = Query(None),
    skill: Optional[str] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(70, ge=1, le=100),
    user: UserPayload = Depends(get_current_user),
):
    return await employee_controller.list_employees(
        user=user, department=department, project=project,
        skill=skill, skip=skip, limit=limit,
    )


@router.get("/{employee_id}", response_model=EmployeeDetail)
async def get_employee(
    employee_id: str,
    user: UserPayload = Depends(get_current_user),
):
    return await employee_controller.get_employee_detail(employee_id, user)


@router.get("/{employee_id}/reporting-chain")
async def get_reporting_chain(
    employee_id: str,
    user: UserPayload = Depends(get_current_user),
):
    chain = await employee_controller.get_reporting_chain(employee_id, user)
    return {"employee_id": employee_id, "chain": chain, "levels": len(chain) - 1}
