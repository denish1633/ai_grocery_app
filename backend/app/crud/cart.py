from sqlalchemy.orm import Session
from backend.app.models.cart import Cart
from backend.app.schemas import cart as schemas


def add_to_cart(db: Session, cart_data: schemas.CartCreate):
    existing = db.query(Cart).filter(
        Cart.user_id == cart_data.user_id,
        Cart.checkout_status == False
    ).first()

    if existing:
        # Merge quantities
        existing_map = {p["product_code"]: p["quantity"] for p in existing.products}
        for item in cart_data.products:
            existing_map[item.product_code] = existing_map.get(item.product_code, 0) + item.quantity
        existing.products = [
            {"product_code": code, "quantity": qty}
            for code, qty in existing_map.items()
        ]
        db.commit()
        db.refresh(existing)
        return existing

    # New cart
    new_cart = Cart(**cart_data.dict())
    db.add(new_cart)
    db.commit()
    db.refresh(new_cart)
    return new_cart


def get_cart(db: Session, user_id: int):
    return db.query(Cart).filter(Cart.user_id == user_id).all()


def checkout_cart(db: Session, user_id: int):
    cart = db.query(Cart).filter(
        Cart.user_id == user_id,
        Cart.checkout_status == False
    ).first()
    if not cart:
        return None
    cart.checkout_status = True
    db.commit()
    db.refresh(cart)
    return cart
