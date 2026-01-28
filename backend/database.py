"""
Database models for Orange Calculator App
Uses SQLAlchemy with SQLite
"""

from sqlalchemy import create_engine, Column, Integer, String, Float, Date, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from datetime import datetime

# Database setup
SQLALCHEMY_DATABASE_URL = "sqlite:///./orange_calculator.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, 
    connect_args={"check_same_thread": False}
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


class OrangeType(Base):
    """ตาราง orange_types - ข้อมูลชนิดส้ม"""
    __tablename__ = "orange_types"
    
    id = Column(Integer, primary_key=True, index=True)
    orange_id = Column(String, unique=True, index=True, nullable=False)
    name = Column(String, nullable=False)
    price_per_kg = Column(Float, nullable=False)
    color = Column(String)
    grade = Column(String)
    
    # Relationships
    measurements = relationship("OrangeMeasurement", back_populates="orange_type")
    calculations = relationship("PriceCalculation", back_populates="orange")


class OrangeMeasurement(Base):
    """ตาราง orange_measurements - ข้อมูลการวัด"""
    __tablename__ = "orange_measurements"
    
    id = Column(Integer, primary_key=True, index=True)
    orange_id = Column(String, ForeignKey("orange_types.orange_id"), nullable=False)
    height_cm = Column(Float, nullable=False)
    radius_cm = Column(Float, nullable=False)
    diameter_cm = Column(Float, nullable=False)
    weight_avg_g = Column(Float, nullable=False)
    
    # Relationship
    orange_type = relationship("OrangeType", back_populates="measurements")


class PriceCalculation(Base):
    """ตาราง price_calculations - ประวัติการคำนวณราคา"""
    __tablename__ = "price_calculations"
    
    id = Column(Integer, primary_key=True, index=True)
    orange_type = Column(String, ForeignKey("orange_types.orange_id"), nullable=False)
    weight_kg = Column(Float, nullable=False)
    price_per_kg = Column(Float, nullable=False)
    total_price = Column(Float, nullable=False)
    date = Column(Date, default=datetime.now().date, nullable=False)
    
    # Relationship
    orange = relationship("OrangeType", back_populates="calculations")


# Database dependency
def get_db():
    """Get database session"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def init_db():
    """Initialize database - create all tables"""
    Base.metadata.create_all(bind=engine)
    print("✅ Database tables created successfully!")
