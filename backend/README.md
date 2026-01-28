# Orange Price Scraper Backend

Python FastAPI backend with SQLite database for the Orange Calculator App.

## Features

- 🍊 Real-time orange price data
- 🔍 Supports 3 orange varieties: แมนดาริน, เขียวหวาน, สายน้ำผึ้ง
- 📊 RESTful API with automatic documentation
- 💾 SQLite database for data persistence
- 🚀 FastAPI with async support
- 🌐 CORS enabled for Flutter app access

## Requirements

- Python 3.11 or higher
- pip (Python package manager)

## Installation

### 1. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 2. Initialize Database (Optional but Recommended)

```bash
python seed_db.py
```

This will create the database and populate it with initial orange data.

**Note:** If you skip this step, the database will be created automatically when you first run the server, but it won't have any initial data until you add it through the API.

## Running the Server

```bash
python main.py
```

The server will start at `http://localhost:8001`

**Important:** The server must be running before starting the Flutter app.

### For Development (with auto-reload):

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8001
```

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
