"""
Shared FastAPI dependencies — JWT validation middleware.

Every protected route uses `Depends(get_current_user)` to extract the user
from the Authorization header. If the token is missing/invalid/expired,
returns 401 automatically.
"""

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from services.auth import decode_token
from models.auth import UserPayload


security = HTTPBearer(auto_error=False)


async def get_current_user(
    creds: HTTPAuthorizationCredentials = Depends(security),
) -> UserPayload:
    """Validate JWT and return the decoded user payload."""

    if creds is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing Authorization header",
            headers={"WWW-Authenticate": "Bearer"},
        )

    payload = decode_token(creds.credentials)
    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    try:
        return UserPayload(
            user_id=payload["user_id"],
            full_name=payload["full_name"],
            email=payload["email"],
            department=payload["department"],
            access_level=payload["access_level"],
        )
    except KeyError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Token missing required field: {e}",
        )
