from pydantic import BaseModel

class CartBase(BaseModel):
    user_id: int
    product_id: int
    quantity: int = 1

class CartCreate(CartBase):
    pass

class Cart(CartBase):
    id: int

    class Config:
        orm_mode = True
