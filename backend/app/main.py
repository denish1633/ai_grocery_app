from fastapi import FastAPI
from backend.app.db import session
from backend.app.db.base import Base
from backend.app.api.v1 import auth
from backend.app.api.v1 import products
from backend.app.api.v1 import cart
from backend.app.api.v1 import orders
from backend.app.api.v1 import external_products

app = FastAPI(title="Ecommerce API")

# create tables
Base.metadata.create_all(bind=session.engine)

# register routers
app.include_router(auth.router)
app.include_router(products.router)
app.include_router(cart.router, prefix="/api/v1")
app.include_router(orders.router, prefix="/api/v1")
app.include_router(external_products.router, prefix="/api/v1")


@app.get("/")
def root():
    return {"message": "Ecommerce API running 🚀"}
