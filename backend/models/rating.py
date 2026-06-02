"""
Rating Model Schemas
Pydantic models for rating explanation API responses.
"""

from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime


class RatingDimensionBreakdown(BaseModel):
    """Breakdown of rating for a single dimension"""
    dimension: str              # "PERFORMANCE" | "RELIABILITY" | "TEAMWORK" | "DEVELOPMENT" | "CRAFTSMANSHIP"
    rule_name: str             # "Task Completion" | "Punctuality & Attendance" | etc.
    description: str           # "Percentage of assigned tasks completed on time"
    dimension_stars: float     # 5.0, 4.5, 4.0, etc.
    metric_value: float        # 0.93 | 3.0 | 85.0 | 2.0 | 0.133
    metric_label: str          # "28/30 tasks (93%)" | "3 penalty days" | "Score: 85/100" | etc.
    metric_type: str           # "percentage" | "days" | "score" | "count" | "ratio"
    weight: float              # 0.40 | 0.20 | 0.10 | etc.
    weighted_contribution: float # 2.0 (5.0 × 0.40)


class RatingExplanation(BaseModel):
    """Complete rating explanation with breakdown"""
    employee_id: str
    employee_name: str
    project_id: str
    project_name: str
    period: str                # "Q2-2025"
    overall_stars: float       # 4.0, 4.5, 5.0, etc.
    breakdown: List[RatingDimensionBreakdown]  # Array of 5 dimensions
    calculation_date: datetime
    calculation_method: str    # "rules-v1.0"
    manager_comment: Optional[str]      # Provided by manager
    system_comment: Optional[str]       # Auto-generated summary


class RatingResponse(BaseModel):
    """Simplified rating response (for REST endpoints)"""
    employee_id: str
    employee_name: str
    project_id: str
    project_name: str
    overall_stars: float
    period: str
    calculation_date: datetime
    explanation_available: bool = True  # Can fetch full explanation via GET /employees/{id}/rating-explanation/{project_id}
