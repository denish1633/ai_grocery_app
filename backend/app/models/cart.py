from sqlalchemy import Column, Integer, Boolean, JSON, ForeignKey
from sqlalchemy.orm import relationship
from backend.app.db.base import Base


class Cart(Base):
    __tablename__ = "carts"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    products = Column(JSON, nullable=False)  # [{"product_code": str, "quantity": int}]
    checkout_status = Column(Boolean, default=False)

    user = relationship("User", back_populates="carts", lazy="joined")
