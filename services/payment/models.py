from sqlalchemy import Column, Integer, String, DECIMAL, DateTime, BigInteger
from database import Base
import datetime

class Transaction(Base):
    __tablename__ = "transactions"

    transaction_id = Column(BigInteger, primary_key=True, index=True)

    booking_id = Column(BigInteger, nullable=False, index=True)

    amount = Column(DECIMAL(10, 2), nullable=False)

    transaction_type = Column(String(50), nullable=False)

    status = Column(String(50), default="PENDING")

    gateway_ref_id = Column(String(100), nullable=True)

    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    payment_method = Column(String(50), nullable=True)