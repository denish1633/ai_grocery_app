from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from backend.app.crud import cart as crud
from backend.app.schemas import cart as schemas
from backend.app.db.session import get_db

router = APIRouter(prefix="/cart", tags=["Cart"])

@router.post("/", response_model=schemas.Cart)
def add_cart_item(item: schemas.CartCreate, db: Session = Depends(get_db)):
    return crud.add_to_cart(db, item)

@router.get("/{user_id}", response_model=list[schemas.Cart])
def get_user_cart(user_id: int, db: Session = Depends(get_db)):
    return crud.get_cart(db, user_id)
