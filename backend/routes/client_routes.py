"""Client routes — the XYZ client scenario lives here."""

from fastapi import APIRouter, Depends

from controllers import client_controller
from models.client import ClientResponse, ClientDetail
from models.auth import UserPayload
from routes.dependencies import get_current_user


router = APIRouter(prefix="/clients", tags=["Clients"])


@router.get("", response_model=list[ClientResponse])
async def list_clients(
    user: UserPayload = Depends(get_current_user),
):
    return await client_controller.list_clients(user)


@router.get("/{client_id}", response_model=ClientDetail)
async def get_client(
    client_id: str,
    user: UserPayload = Depends(get_current_user),
):
    """Returns the client + all their projects + all employees on those projects."""
    return await client_controller.get_client_detail(client_id, user)
