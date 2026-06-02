"""POST /auth/login — exchange email+password for a JWT token."""

from fastapi import APIRouter

from controllers import auth_controller
from models.auth import LoginRequest, TokenResponse


router = APIRouter(prefix="/auth", tags=["Auth"])


@router.post("/login", response_model=TokenResponse)
async def login(request: LoginRequest):
    return await auth_controller.login(request)
