from sqlalchemy.orm import Session
from backend.app.models import cart as models
from backend.app.schemas import cart as schemas

def add_to_cart(db: Session, cart_item: schemas.CartCreate):
    db_cart = models.Cart(**cart_item.dict())
    db.add(db_cart)
    db.commit()
    db.refresh(db_cart)
    return db_cart

def get_cart(db: Session, user_id: int):
    return db.query(models.Cart).filter(models.Cart.user_id == user_id).all()
