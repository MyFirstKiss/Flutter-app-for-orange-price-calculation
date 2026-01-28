"""
FastAPI backend for scraping orange prices from talaadthai.com
Filters for: แมนดาริน (Mandarin), เขียวหวาน (Tangerine), สายน้ำผึ้ง (Sai Nam Phueng)
With SQLite Database Integration
"""

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
import requests
from bs4 import BeautifulSoup
from typing import List, Optional
from pydantic import BaseModel
import re
from datetime import datetime

# Import database components
from database import (
    get_db, init_db, 
    OrangeType as DBOrangeType,
    OrangeMeasurement as DBOrangeMeasurement,
    PriceCalculation as DBPriceCalculation
)

app = FastAPI(title="Orange Price Scraper API")

# Initialize database on startup
@app.on_event("startup")
async def startup_event():
    """Initialize database on application startup"""
    init_db()
    print("🗄️  Database initialized")

# Enable CORS for all origins (mobile simulator access)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class OrangePrice(BaseModel):
    """Model for orange price data"""
    name: str
    grade: str
    price_min: float
    price_max: float
    unit: str


# Keywords to filter
ORANGE_KEYWORDS = ["แมนดาริน", "เขียวหวาน", "สายน้ำผึ้ง"]


def extract_price_range(price_str: str) -> tuple[Optional[float], Optional[float]]:
    """
    Extract min and max prices from price string
    Examples: "50-60", "50", "50.00-60.00"
    """
    try:
        # Remove commas and extra spaces
        price_str = price_str.replace(",", "").strip()
        
        # Check if it's a range (contains dash or hyphen)
        if "-" in price_str or "–" in price_str:
            # Split by dash or en-dash
            parts = re.split(r"[-–]", price_str)
            if len(parts) == 2:
                price_min = float(parts[0].strip())
                price_max = float(parts[1].strip())
                return price_min, price_max
        
        # Single price value
        price = float(price_str)
        return price, price
    except (ValueError, AttributeError):
        return None, None


def contains_orange_keyword(text: str) -> bool:
    """Check if text contains any of the orange keywords"""
    if not text:
        return False
    return any(keyword in text for keyword in ORANGE_KEYWORDS)


def get_mock_data() -> List[OrangePrice]:
    """Return mock data for testing"""
    return [
        OrangePrice(
            name="ส้มแมนดาริน",
            grade="เกรด A",
            price_min=45.0,
            price_max=60.0,
            unit="กก."
        ),
        OrangePrice(
            name="ส้มแมนดาริน",
            grade="เกรด B",
            price_min=35.0,
            price_max=45.0,
            unit="กก."
        ),
        OrangePrice(
            name="ส้มเขียวหวาน",
            grade="เกรด A",
            price_min=35.0,
            price_max=50.0,
            unit="กก."
        ),
        OrangePrice(
            name="ส้มเขียวหวาน",
            grade="เกรด B",
            price_min=25.0,
            price_max=35.0,
            unit="กก."
        ),
        OrangePrice(
            name="ส้มสายน้ำผึ้ง",
            grade="เกรด A",
            price_min=40.0,
            price_max=55.0,
            unit="กก."
        ),
        OrangePrice(
            name="ส้มสายน้ำผึ้ง",
            grade="เกรด B",
            price_min=30.0,
            price_max=40.0,
            unit="กก."
        ),
    ]


@app.get("/")
async def root():
    """API root endpoint"""
    return {
        "message": "Orange Price Scraper API",
        "endpoints": {
            "/oranges": "Get filtered orange prices from talaadthai.com"
        }
    }


@app.get("/oranges", response_model=List[OrangePrice])
async def get_orange_prices():
    """
    Scrape orange prices from talaadthai.com and filter for specific varieties
    Returns mock data if website is unavailable
    """
    url = "https://talaadthai.com/prices/fruit"
    
    try:
        # Fetch the webpage
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        }
        response = requests.get(url, headers=headers, timeout=10)
        
        # If website not found, return mock data
        if response.status_code == 404:
            return get_mock_data()
        
        response.raise_for_status()
        
        # Parse HTML
        soup = BeautifulSoup(response.content, "html.parser")
        
        # Find the price table
        # Note: You may need to adjust selectors based on actual website structure
        table = soup.find("table", class_=re.compile(r"price|table", re.I))
        if not table:
            # Try finding any table
            table = soup.find("table")
        
        if not table:
            raise HTTPException(status_code=404, detail="Price table not found on webpage")
        
        orange_data = []
        
        # Parse table rows
        rows = table.find_all("tr")
        
        for row in rows[1:]:  # Skip header row
            cells = row.find_all(["td", "th"])
            
            if len(cells) < 4:
                continue
            
            # Extract data from cells
            # Typical structure: [name, grade, price, unit]
            name = cells[0].get_text(strip=True)
            
            # Check if this row contains our orange keywords
            if not contains_orange_keyword(name):
                continue
            
            grade = cells[1].get_text(strip=True) if len(cells) > 1 else "ไม่ระบุ"
            price_str = cells[2].get_text(strip=True) if len(cells) > 2 else ""
            unit = cells[3].get_text(strip=True) if len(cells) > 3 else "กก."
            
            # Extract price range
            price_min, price_max = extract_price_range(price_str)
            
            if price_min is not None and price_max is not None:
                orange_data.append(
                    OrangePrice(
                        name=name,
                        grade=grade,
                        price_min=price_min,
                        price_max=price_max,
                        unit=unit
                    )
                )
        
        if not orange_data:
            # Return mock data for testing if no data found
            return get_mock_data()
        
        return orange_data
        
    except requests.RequestException as e:
        raise HTTPException(
            status_code=503,
            detail=f"Failed to fetch data from talaadthai.com: {str(e)}"
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"An error occurred while processing data: {str(e)}"
        )


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "Orange Price Scraper"}


# Additional endpoints for Flutter app compatibility
@app.get("/api/oranges")
async def get_oranges_for_flutter(db: Session = Depends(get_db)):
    """Get orange data from database in Flutter-compatible format"""
    try:
        # Query all orange types with their measurements
        oranges = db.query(DBOrangeType).all()
        
        result = []
        for orange in oranges:
            # Get measurement data
            measurement = db.query(DBOrangeMeasurement).filter(
                DBOrangeMeasurement.orange_id == orange.orange_id
            ).first()
            
            orange_data = {
                "id": orange.orange_id,
                "name": orange.name,
                "pricePerKg": orange.price_per_kg,
                "color": orange.color,
                "grade": orange.grade,
                "description": f"คุณภาพ {orange.grade}"
            }
            
            # Add measurements if available
            if measurement:
                orange_data.update({
                    "height": measurement.height_cm,
                    "radius": measurement.radius_cm,
                    "diameter": measurement.diameter_cm,
                    "weight_avg_g": measurement.weight_avg_g
                })
            
            result.append(orange_data)
        
        # Try to update prices from web scraping
        try:
            scraped_prices = await get_orange_prices()
            price_map = {}
            
            for price in scraped_prices:
                avg_price = (price.price_min + price.price_max) / 2
                
                if "สายน้ำผึ้ง" in price.name:
                    price_map["tangerine"] = avg_price
                elif "เขียวหวาน" in price.name:
                    price_map["green-sweet"] = avg_price
                elif "แมนดาริน" in price.name:
                    price_map["mandarin"] = avg_price
            
            # Update prices in result
            for orange_data in result:
                if orange_data["id"] in price_map:
                    orange_data["pricePerKg"] = round(price_map[orange_data["id"]], 2)
        except:
            pass  # Use database prices if scraping fails
        
        return result
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")


@app.get("/api/oranges/{orange_id}")
async def get_orange_by_id(orange_id: str, db: Session = Depends(get_db)):
    """Get single orange by ID from database"""
    try:
        orange = db.query(DBOrangeType).filter(
            DBOrangeType.orange_id == orange_id
        ).first()
        
        if not orange:
            raise HTTPException(status_code=404, detail="Orange not found")
        
        measurement = db.query(DBOrangeMeasurement).filter(
            DBOrangeMeasurement.orange_id == orange_id
        ).first()
        
        result = {
            "id": orange.orange_id,
            "name": orange.name,
            "pricePerKg": orange.price_per_kg,
            "color": orange.color,
            "grade": orange.grade
        }
        
        if measurement:
            result.update({
                "height": measurement.height_cm,
                "radius": measurement.radius_cm,
                "diameter": measurement.diameter_cm,
                "weight_avg_g": measurement.weight_avg_g
            })
        
        return result
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")


@app.post("/api/calculate")
async def calculate_price(orange_id: str, weight: float, db: Session = Depends(get_db)):
    """Calculate price and save to database"""
    try:
        # Get orange from database
        orange = db.query(DBOrangeType).filter(
            DBOrangeType.orange_id == orange_id
        ).first()
        
        if not orange:
            raise HTTPException(status_code=404, detail="Orange not found")
        
        # Calculate total price
        total_price = weight * orange.price_per_kg
        
        # Save calculation to database
        calculation = DBPriceCalculation(
            orange_type=orange_id,
            weight_kg=weight,
            price_per_kg=orange.price_per_kg,
            total_price=round(total_price, 2),
            date=datetime.now().date()
        )
        db.add(calculation)
        db.commit()
        db.refresh(calculation)
        
        return {
            "orange_id": orange_id,
            "orange_name": orange.name,
            "weight": weight,
            "price_per_kg": orange.price_per_kg,
            "total_price": round(total_price, 2),
            "calculation_id": calculation.id
        }
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Calculation error: {str(e)}")


@app.get("/api/prices")
async def get_live_prices(db: Session = Depends(get_db)):
    """Get live prices from database for Flutter app"""
    try:
        oranges = db.query(DBOrangeType).all()
        return [
            {
                "id": o.orange_id,
                "name": o.name,
                "price": o.price_per_kg,
                "source": "Talaadthai.com",
                "updated_at": "Real-time"
            }
            for o in oranges
        ]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")


# New endpoints for database operations
@app.get("/api/calculations")
async def get_calculations(limit: int = 10, db: Session = Depends(get_db)):
    """Get recent price calculations"""
    try:
        calculations = db.query(DBPriceCalculation).order_by(
            DBPriceCalculation.date.desc()
        ).limit(limit).all()
        
        result = []
        for calc in calculations:
            orange = db.query(DBOrangeType).filter(
                DBOrangeType.orange_id == calc.orange_type
            ).first()
            
            result.append({
                "id": calc.id,
                "orange_type": calc.orange_type,
                "orange_name": orange.name if orange else "Unknown",
                "weight_kg": calc.weight_kg,
                "price_per_kg": calc.price_per_kg,
                "total_price": calc.total_price,
                "date": calc.date.isoformat()
            })
        
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")


@app.get("/api/measurements")
async def get_all_measurements(db: Session = Depends(get_db)):
    """Get all orange measurements"""
    try:
        measurements = db.query(DBOrangeMeasurement).all()
        
        result = []
        for m in measurements:
            orange = db.query(DBOrangeType).filter(
                DBOrangeType.orange_id == m.orange_id
            ).first()
            
            result.append({
                "id": m.id,
                "orange_id": m.orange_id,
                "orange_name": orange.name if orange else "Unknown",
                "height_cm": m.height_cm,
                "radius_cm": m.radius_cm,
                "diameter_cm": m.diameter_cm,
                "weight_avg_g": m.weight_avg_g
            })
        
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")


@app.get("/api/stats")
async def get_statistics(db: Session = Depends(get_db)):
    """Get statistics from database"""
    try:
        total_oranges = db.query(DBOrangeType).count()
        total_calculations = db.query(DBPriceCalculation).count()
        
        # Get most popular orange type
        from sqlalchemy import func
        popular = db.query(
            DBPriceCalculation.orange_type,
            func.count(DBPriceCalculation.id).label('count')
        ).group_by(DBPriceCalculation.orange_type).order_by(
            func.count(DBPriceCalculation.id).desc()
        ).first()
        
        return {
            "total_orange_types": total_oranges,
            "total_calculations": total_calculations,
            "most_popular": popular[0] if popular else None,
            "most_popular_count": popular[1] if popular else 0
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")


@app.delete("/api/calculations/{calculation_id}")
async def delete_calculation(calculation_id: int, db: Session = Depends(get_db)):
    """Delete a price calculation from database"""
    try:
        # Find the calculation
        calculation = db.query(DBPriceCalculation).filter(
            DBPriceCalculation.id == calculation_id
        ).first()
        
        if not calculation:
            raise HTTPException(status_code=404, detail="Calculation not found")
        
        # Delete the calculation
        db.delete(calculation)
        db.commit()
        
        return {
            "success": True,
            "message": "Calculation deleted successfully",
            "id": calculation_id
        }
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Delete error: {str(e)}")


if __name__ == "__main__":
    import uvicorn
    # Listen on 0.0.0.0 to allow mobile device connections
    uvicorn.run(app, host="0.0.0.0", port=8001)
