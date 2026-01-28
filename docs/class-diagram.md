# Class Diagram - Orange Calculator App

```mermaid
classDiagram
    %% Main Application
    class OrangeCalculatorApp {
        +build(BuildContext) Widget
    }
    
    class MainScreen {
        -String currentScreen
        -navigateTo(String) void
        +build(BuildContext) Widget
    }
    
    %% Models
    class OrangeType {
        +String id
        +String name
        +double pricePerKg
        +double height
        +double radius
        +double diameter
        +double? weightAvgG
        +String? color
        +String? grade
        +List~Color~ colors
        +String description
        +fromJson(Map) OrangeType
        +toJson() Map
        -_parseDouble(dynamic) double
    }
    
    class PriceCalculation {
        +int id
        +String orangeType
        +String orangeName
        +double weightKg
        +double pricePerKg
        +double totalPrice
        +DateTime date
        +fromJson(Map) PriceCalculation
        +toJson() Map
    }
    
    %% Services
    class ApiService {
        +String baseUrl
        +fetchOranges() Future~List~OrangeType~~
        +fetchOrangeById(String) Future~OrangeType?~
        +calculatePrice(String, double) Future~Map?~
        +fetchLivePrices() Future~List~Map~~
        +checkApiStatus() Future~bool~
        +fetchCalculations(int) Future~List~PriceCalculation~~
        +fetchStatistics() Future~Map?~
    }
    
    %% Screens
    class HomeScreen {
        +Function(String) onNavigate
        +build(BuildContext) Widget
        -_buildMenuCard() Widget
    }
    
    class DataScreen {
        +Function(String) onNavigate
        -ApiService _apiService
        -List~OrangeType~ oranges
        -bool isLoading
        -initState() void
        -_loadOranges() Future~void~
        +build(BuildContext) Widget
    }
    
    class CalculatorScreen {
        +Function(String) onNavigate
        -ApiService _apiService
        -OrangeType selectedOrange
        -List~OrangeType~ availableOranges
        -TextEditingController weightController
        -double? totalPrice
        -bool isLoading
        -bool isCalculating
        -initState() void
        -_loadOranges() Future~void~
        -handleCalculate() Future~void~
        -handleClear() void
        +build(BuildContext) Widget
    }
    
    class LivePricesScreen {
        +Function(String) onNavigate
        -ApiService _apiService
        -List~Map~ prices
        -bool isLoading
        -bool isApiConnected
        -initState() void
        -_checkApiConnection() Future~void~
        -_loadPrices() Future~void~
        +build(BuildContext) Widget
    }
    
    class HistoryScreen {
        +Function(String) onNavigate
        -ApiService _apiService
        -List~PriceCalculation~ calculations
        -Map? statistics
        -bool isLoading
        -initState() void
        -_loadHistory() Future~void~
        -_loadStatistics() Future~void~
        +build(BuildContext) Widget
    }
    
    %% Backend Models (Python)
    class DBOrangeType {
        +int id
        +String orange_id
        +String name
        +float price_per_kg
        +float height
        +float radius
        +float diameter
        +float weight_avg_g
        +String color
        +String grade
        +String description
        +DateTime created_at
    }
    
    class DBOrangeMeasurement {
        +int id
        +String orange_id
        +float height
        +float radius
        +float diameter
        +DateTime measured_at
    }
    
    class DBPriceCalculation {
        +int id
        +String orange_type
        +String orange_name
        +float weight_kg
        +float price_per_kg
        +float total_price
        +DateTime date
    }
    
    class OrangePrice {
        +String name
        +String grade
        +float price_min
        +float price_max
        +String unit
    }
    
    %% Backend API (Python)
    class FastAPIBackend {
        +get_oranges(Session) List~OrangeType~
        +get_orange_by_id(String, Session) OrangeType
        +create_orange(OrangeType, Session) OrangeType
        +update_orange(String, OrangeType, Session) OrangeType
        +delete_orange(String, Session) dict
        +calculate_price(String, float, Session) dict
        +get_calculations(int, Session) List~PriceCalculation~
        +get_statistics(Session) dict
        +scrape_prices() List~OrangePrice~
        +get_prices() List~dict~
        -extract_price_range(String) tuple
        -contains_orange_keyword(String) bool
        -get_mock_data() List~OrangePrice~
    }
    
    class DatabaseSession {
        +get_db() Generator
        +init_db() void
    }
    
    %% Utilities
    class AppTheme {
        <<utility>>
        +Color primaryColor
        +Color secondaryColor
        +Color surfaceColor
        +TextStyle heading1
        +TextStyle heading2
        +TextStyle bodyLarge
        +double spacingXS
        +double spacingS
        +double spacingM
        +double spacingL
        +double spacingXL
    }
    
    class CommonWidgets {
        <<utility>>
        +buildNavigationBar(Function) Widget
        +buildStatCard() Widget
        +buildOrangeCard() Widget
    }
    
    %% Relationships
    OrangeCalculatorApp --> MainScreen : creates
    MainScreen --> HomeScreen : navigates
    MainScreen --> DataScreen : navigates
    MainScreen --> CalculatorScreen : navigates
    MainScreen --> LivePricesScreen : navigates
    MainScreen --> HistoryScreen : navigates
    
    DataScreen --> ApiService : uses
    CalculatorScreen --> ApiService : uses
    LivePricesScreen --> ApiService : uses
    HistoryScreen --> ApiService : uses
    
    DataScreen --> OrangeType : displays
    CalculatorScreen --> OrangeType : uses
    HistoryScreen --> PriceCalculation : displays
    
    ApiService --> OrangeType : fetches/creates
    ApiService --> PriceCalculation : fetches/creates
    
    FastAPIBackend --> DBOrangeType : queries
    FastAPIBackend --> DBOrangeMeasurement : queries
    FastAPIBackend --> DBPriceCalculation : queries
    FastAPIBackend --> OrangePrice : scrapes
    FastAPIBackend --> DatabaseSession : uses
    
    ApiService ..> FastAPIBackend : HTTP calls
    
    HomeScreen --> AppTheme : uses
    DataScreen --> AppTheme : uses
    CalculatorScreen --> AppTheme : uses
    
    HomeScreen --> CommonWidgets : uses
    DataScreen --> CommonWidgets : uses
    CalculatorScreen --> CommonWidgets : uses
    LivePricesScreen --> CommonWidgets : uses
    HistoryScreen --> CommonWidgets : uses
```

## Class Descriptions

### Frontend (Flutter/Dart)

#### Application Layer
- **OrangeCalculatorApp**: Main application entry point, sets up MaterialApp and theme
- **MainScreen**: Root navigation screen managing screen transitions

#### Model Layer
- **OrangeType**: Domain model representing orange variety with properties and measurements
- **PriceCalculation**: Domain model for price calculation history records

#### Service Layer
- **ApiService**: HTTP client service for communicating with FastAPI backend
  - Handles API calls, error handling, and fallback to local data
  - Manages network requests and response parsing

#### Presentation Layer (Screens)
- **HomeScreen**: Landing page with navigation menu
- **DataScreen**: Displays list of orange varieties with details
- **CalculatorScreen**: Price calculation interface with orange selection and weight input
- **LivePricesScreen**: Real-time price display from web scraping
- **HistoryScreen**: Shows calculation history and statistics

#### Utility Layer
- **AppTheme**: Centralized theme configuration (colors, text styles, spacing)
- **CommonWidgets**: Reusable UI components (navigation bar, cards)

### Backend (FastAPI/Python)

#### Database Models
- **DBOrangeType**: SQLAlchemy model for orange varieties stored in database
- **DBOrangeMeasurement**: Physical measurements of oranges
- **DBPriceCalculation**: Calculation history records

#### API Models
- **OrangePrice**: Pydantic model for scraped price data from Talaadthai.com

#### API Layer
- **FastAPIBackend**: REST API endpoints
  - CRUD operations for oranges
  - Price calculation endpoint
  - Web scraping functionality
  - Statistics and history endpoints
- **DatabaseSession**: Database connection and session management

## Key Design Patterns

1. **Repository Pattern**: ApiService acts as repository for data access
2. **MVC Pattern**: Separation of Models, Views (Screens), and Controllers (State)
3. **Singleton**: ApiService instances
4. **Factory Pattern**: fromJson() methods for object creation
5. **Fallback Pattern**: Local data fallback when API unavailable
6. **RESTful API**: HTTP methods for CRUD operations

## Data Flow
```
Flutter UI → ApiService → HTTP Request → FastAPI Backend → SQLite Database
         ←              ← JSON Response ←                 ← Query Result
```
