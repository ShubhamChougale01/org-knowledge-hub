"""POST /chat — main chatbot endpoint."""

from fastapi import APIRouter, Depends

from controllers import chat_controller
from models.chat import ChatRequest, ChatResponse
from models.auth import UserPayload
from routes.dependencies import get_current_user


router = APIRouter(prefix="/chat", tags=["Chat"])


@router.post("", response_model=ChatResponse)
async def chat(
    request: ChatRequest,
    user: UserPayload = Depends(get_current_user),
):
    return await chat_controller.handle_chat(request, user)
