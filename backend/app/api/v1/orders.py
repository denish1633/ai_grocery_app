from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from backend.app.crud import order as crud
from backend.app.schemas import order as schemas
from backend.app.db.session import get_db

router = APIRouter(prefix="/orders", tags=["Orders"])

@router.post("/", response_model=schemas.Order)
def create_order(order: schemas.OrderCreate, db: Session = Depends(get_db)):
    return crud.create_order(db, order)

@router.get("/{user_id}", response_model=list[schemas.Order])
def list_orders(user_id: int, db: Session = Depends(get_db)):
    return crud.get_orders(db, user_id)
