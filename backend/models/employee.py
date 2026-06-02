"""Employee response models."""

from typing import Optional
from datetime import date
from pydantic import BaseModel, Field


class EmployeeResponse(BaseModel):
    """List view — PII never included regardless of access level."""
    employee_id: str
    full_name: str
    email: str
    department: Optional[str] = None
    role: Optional[str] = None
    joining_date: Optional[date] = None
    current_status: Optional[str] = None


class EmployeeSkill(BaseModel):
    name: str
    category: Optional[str] = None
    proficiency: str
    years: Optional[float] = None


class EmployeeCertification(BaseModel):
    name: str
    issuer: Optional[str] = None
    issued_date: Optional[date] = None
    expiry_date: Optional[date] = None


class EmployeeProject(BaseModel):
    name: str
    role_in_project: Optional[str] = None
    is_current: bool = False
    start_date: Optional[date] = None
    end_date: Optional[date] = None


class EmployeePromotion(BaseModel):
    from_role: str
    to_role: str
    effective_date: date


class EmployeeDetail(BaseModel):
    """Full profile — PII fields hidden unless access_level permits."""
    employee_id: str
    full_name: str
    email: str
    department: Optional[str] = None
    role: Optional[str] = None
    joining_date: Optional[date] = None
    total_experience_years: Optional[float] = None
    org_experience_years: Optional[float] = None
    current_status: Optional[str] = None
    gender: Optional[str] = None

    # PII — hidden for L3 (unless own profile) and L4
    phone: Optional[str] = None
    dob: Optional[date] = None
    address: Optional[str] = None

    # Relationships
    reports_to: Optional[str] = None
    skills: list[EmployeeSkill] = Field(default_factory=list)
    certifications: list[EmployeeCertification] = Field(default_factory=list)
    projects: list[EmployeeProject] = Field(default_factory=list)
    promotions: list[EmployeePromotion] = Field(default_factory=list)
