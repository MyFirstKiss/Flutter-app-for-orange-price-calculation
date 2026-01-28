"""
Seed database with initial data
Run this script to populate the database with orange types and measurements
"""

from database import SessionLocal, OrangeType, OrangeMeasurement, init_db


def seed_data():
    """Insert initial data into database"""
    
    # Initialize database (create tables)
    init_db()
    
    db = SessionLocal()
    
    try:
        # Check if data already exists
        existing = db.query(OrangeType).first()
        if existing:
            print("⚠️  Database already has data. Skipping seed.")
            return
        
        # Seed orange types
        orange_types_data = [
            {
                "orange_id": "tangerine",
                "name": "ส้มสายน้ำผึ้ง",
                "price_per_kg": 45.0,
                "color": "ส้ม",
                "grade": "A+"
            },
            {
                "orange_id": "green-sweet",
                "name": "ส้มเขียวหวาน",
                "price_per_kg": 35.0,
                "color": "เขียว",
                "grade": "A"
            },
            {
                "orange_id": "mandarin",
                "name": "ส้มแมนดาริน",
                "price_per_kg": 55.0,
                "color": "ส้มอ่อน",
                "grade": "A+"
            }
        ]
        
        # Insert orange types
        for data in orange_types_data:
            orange_type = OrangeType(**data)
            db.add(orange_type)
        
        db.commit()
        print("✅ Inserted orange types")
        
        # Seed measurements
        measurements_data = [
            {
                "orange_id": "tangerine",
                "height_cm": 7.5,
                "radius_cm": 3.8,
                "diameter_cm": 7.6,
                "weight_avg_g": 120.0
            },
            {
                "orange_id": "green-sweet",
                "height_cm": 8.2,
                "radius_cm": 4.1,
                "diameter_cm": 8.2,
                "weight_avg_g": 150.0
            },
            {
                "orange_id": "mandarin",
                "height_cm": 6.8,
                "radius_cm": 3.5,
                "diameter_cm": 7.0,
                "weight_avg_g": 100.0
            }
        ]
        
        # Insert measurements
        for data in measurements_data:
            measurement = OrangeMeasurement(**data)
            db.add(measurement)
        
        db.commit()
        print("✅ Inserted measurements")
        
        print("\n🎉 Database seeded successfully!")
        print(f"   - {len(orange_types_data)} orange types")
        print(f"   - {len(measurements_data)} measurements")
        
    except Exception as e:
        print(f"❌ Error seeding database: {e}")
        db.rollback()
    finally:
        db.close()


if __name__ == "__main__":
    seed_data()
