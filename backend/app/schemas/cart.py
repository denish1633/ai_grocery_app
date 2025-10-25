from pydantic import BaseModel
from typing import List, Optional


class ProductItem(BaseModel):
    product_code: str
    quantity: int


class CartBase(BaseModel):
    user_id: int
    products: List[ProductItem]
    checkout_status: bool = False


class CartCreate(CartBase):
    pass


class CartUpdate(BaseModel):
    checkout_status: Optional[bool] = None
    products: Optional[List[ProductItem]] = None


class CartOut(CartBase):
    id: int

    class Config:
        orm_mode = True
