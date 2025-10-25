from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from backend.app.db.session import get_db
from backend.app.schemas import cart as schemas
from backend.app.crud import cart as crud

router = APIRouter(prefix="/cart", tags=["Cart"])


@router.post("/", response_model=schemas.CartOut, status_code=201)
def add_cart_item(item: schemas.CartCreate, db: Session = Depends(get_db)):
    return crud.add_to_cart(db, item)


@router.get("/{user_id}", response_model=list[schemas.CartOut])
def get_user_cart(user_id: int, db: Session = Depends(get_db)):
    return crud.get_cart(db, user_id)


@router.post("/{user_id}/checkout", response_model=schemas.CartOut)
def checkout_user_cart(user_id: int, db: Session = Depends(get_db)):
    cart = crud.checkout_cart(db, user_id)
    if not cart:
        raise HTTPException(status_code=404, detail="No active cart found")
    return cart
