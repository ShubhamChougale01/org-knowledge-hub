"""Authentication request/response models."""

from pydantic import BaseModel, EmailStr
from typing import Literal

AccessLevel = Literal["L1", "L2", "L3", "L4"]


class LoginRequest(BaseModel):
    email: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    expires_in: int
    user_id: str
    full_name: str
    access_level: AccessLevel


class UserPayload(BaseModel):
    """Shape of the decoded JWT — used to identify the requesting user."""
    user_id: str
    full_name: str
    email: str
    department: str
    access_level: AccessLevel
