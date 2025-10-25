from pydantic import BaseModel
from typing import List, ClassVar

class OrderItemOut(BaseModel):
    product_id: int
    quantity: int

    model_config: ClassVar[dict] = {"from_attributes": True}


class OrderOut(BaseModel):
    id: int
    user_id: int
    total: float
    status: str
    items: List[OrderItemOut]

    model_config: ClassVar[dict] = {"from_attributes": True}
