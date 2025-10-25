from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from backend.app.db.session import get_db
from backend.app.schemas import order as schemas
from backend.app.crud import order as crud

router = APIRouter(prefix="/orders", tags=["Orders"])


@router.post("/{user_id}/checkout", response_model=schemas.OrderOut)
def checkout_cart(user_id: int, db: Session = Depends(get_db)):
    order = crud.create_order_from_cart(db, user_id)
    if not order:
        raise HTTPException(status_code=404, detail="Cart is empty")
    return order


@router.get("/{user_id}", response_model=list[schemas.OrderOut])
def get_user_orders(user_id: int, db: Session = Depends(get_db)):
    orders = crud.get_orders_by_user(db, user_id)
    return orders
