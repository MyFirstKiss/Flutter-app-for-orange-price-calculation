# Orange Price Scraper Backend

Python FastAPI backend that scrapes daily orange prices from talaadthai.com.

## Features

- 🍊 Scrapes fruit prices from talaadthai.com
- 🔍 Filters for specific orange varieties: แมนดาริน, เขียวหวาน, สายน้ำผึ้ง
- 📊 Returns structured JSON data
- 🚀 FastAPI with automatic API documentation
- 🌐 CORS enabled for mobile app access

## Installation

1. Create a virtual environment:
```bash
python -m venv venv
```

2. Activate the virtual environment:
```bash
# Windows
venv\Scripts\activate

# macOS/Linux
source venv/bin/activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

## Running the Server

```bash
python main.py
```

Or using uvicorn directly:
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

The server will start at `http://localhost:8000`

## API Endpoints

### GET /
Root endpoint with API information

### GET /oranges
Fetches filtered orange prices from talaadthai.com

**Response Example:**
```json
[
  {
    "name": "ส้มแมนดาริน",
    "grade": "เกรด A",
    "price_min": 45.0,
    "price_max": 60.0,
    "unit": "กก."
  }
]
```

### GET /health
Health check endpoint

## API Documentation

Once the server is running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Testing

Test the API using curl:
```bash
curl http://localhost:8000/oranges
```

Or visit http://localhost:8000/docs for interactive API testing.

## Notes

- The scraper includes mock data fallback if the website structure changes
- CORS is enabled for all origins to support mobile app development
- Timeout is set to 10 seconds for web requests
