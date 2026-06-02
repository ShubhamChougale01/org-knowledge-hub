"""
Auth controller — login by email lookup against Neo4j.

For PoC: we authenticate by email only (no password storage yet — all employees
have a default password 'coditas2026' that we verify against here as a stand-in).
In production, hashed passwords would live in Neo4j as Employee.password_hash.
"""

import logging
from fastapi import HTTPException, status

from services.graph import run_query_single
from services.auth import create_token, derive_access_level
from models.auth import LoginRequest, TokenResponse

log = logging.getLogger(__name__)


# Default PoC password for all employees
_DEFAULT_PASSWORD = "coditas2026"


async def login(request: LoginRequest) -> TokenResponse:
    """
    Authenticate an employee by email + password.
    Returns a JWT token containing user identity + access level.
    """
    # PoC: password check is hardcoded — replace with bcrypt in production
    if request.password != _DEFAULT_PASSWORD:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
        )

    # Look up the employee in Neo4j
    employee = run_query_single("""
        MATCH (e:Employee {email: $email})
        OPTIONAL MATCH (e)-[:BELONGS_TO]->(d:Department)
        OPTIONAL MATCH (e)-[:HAS_ROLE {is_current: true}]->(r:Role)
        RETURN e.employee_id AS employee_id,
               e.full_name   AS full_name,
               e.email       AS email,
               d.name        AS department,
               r.title       AS role_title
    """, {"email": request.email})

    if not employee:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
        )

    access_level = derive_access_level(
        department=employee.get("department") or "",
        role_title=employee.get("role_title") or "",
    )

    token, expires_in = create_token(
        user_id=employee["employee_id"],
        full_name=employee["full_name"],
        email=employee["email"],
        department=employee.get("department") or "",
        access_level=access_level,
    )

    return TokenResponse(
        access_token=token,
        expires_in=expires_in,
        user_id=employee["employee_id"],
        full_name=employee["full_name"],
        access_level=access_level,
    )
