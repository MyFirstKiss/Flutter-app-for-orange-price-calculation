# Sequence Diagrams - Orange Calculator App

## 1. Sequence Diagram: คำนวณราคาส้ม (Calculate Orange Price)

```mermaid
sequenceDiagram
    actor User as ผู้ใช้งาน
    participant UI as Calculator Screen
    participant API as ApiService
    participant Backend as FastAPI Backend
    participant DB as SQLite Database
    
    User->>UI: เลือกชนิดส้ม
    User->>UI: ใส่น้ำหนัก (kg)
    User->>UI: กดปุ่ม "คำนวณ"
    
    activate UI
    UI->>UI: setState(isCalculating: true)
    UI->>API: calculatePrice(orangeId, weight)
    
    activate API
    API->>Backend: POST /api/calculate?orange_id=xxx&weight=xxx
    
    activate Backend
    Backend->>DB: SELECT orange data
    activate DB
    DB-->>Backend: OrangeType data
    deactivate DB
    
    Backend->>Backend: totalPrice = weight * pricePerKg
    Backend->>DB: INSERT calculation record
    activate DB
    DB-->>Backend: success
    deactivate DB
    
    Backend-->>API: {orange_id, weight, price_per_kg, total_price}
    deactivate Backend
    
    API-->>UI: calculation result
    deactivate API
    
    UI->>UI: setState(totalPrice: result, isCalculating: false)
    UI->>User: แสดงราคารวม
    deactivate UI
```

## 2. Sequence Diagram: ดูข้อมูลส้ม (Fetch Orange Data)

```mermaid
sequenceDiagram
    actor User as ผู้ใช้งาน
    participant UI as Data Screen
    participant API as ApiService
    participant Backend as FastAPI Backend
    participant DB as SQLite Database
    
    User->>UI: เปิดหน้าข้อมูลส้ม
    
    activate UI
    UI->>UI: initState() / setState(isLoading: true)
    UI->>API: fetchOranges()
    
    activate API
    API->>Backend: GET /api/oranges
    
    activate Backend
    Backend->>DB: SELECT * FROM orange_types
    activate DB
    DB-->>Backend: List of OrangeType
    deactivate DB
    
    Backend-->>API: JSON Array of oranges
    deactivate Backend
    
    API->>API: OrangeType.fromJson() for each
    API-->>UI: List<OrangeType>
    deactivate API
    
    UI->>UI: setState(oranges: data, isLoading: false)
    UI->>User: แสดงรายการส้มพร้อมรายละเอียด
    deactivate UI
```

## 3. Sequence Diagram: ดูราคาปัจจุบัน (Live Prices from Web Scraping)

```mermaid
sequenceDiagram
    actor User as ผู้ใช้งาน
    participant UI as Live Prices Screen
    participant API as ApiService
    participant Backend as FastAPI Backend
    participant Web as Talaadthai.com
    participant DB as SQLite Database
    
    User->>UI: เปิดหน้าราคาปัจจุบัน
    
    activate UI
    UI->>UI: setState(isLoading: true)
    UI->>API: fetchLivePrices()
    
    activate API
    API->>Backend: GET /api/prices
    
    activate Backend
    Backend->>Web: HTTP GET talaadthai.com/fruits
    activate Web
    Web-->>Backend: HTML Response
    deactivate Web
    
    Backend->>Backend: BeautifulSoup parse HTML
    Backend->>Backend: filter orange keywords<br/>(แมนดาริน, เขียวหวาน, สายน้ำผึ้ง)
    Backend->>Backend: extract_price_range()
    
    Backend->>DB: UPDATE orange prices
    activate DB
    DB-->>Backend: success
    deactivate DB
    
    Backend-->>API: JSON Array of live prices
    deactivate Backend
    
    API-->>UI: List<Map<String, dynamic>>
    deactivate API
    
    UI->>UI: setState(prices: data, isLoading: false)
    UI->>User: แสดงราคาล่าสุด
    deactivate UI
```

## 4. Sequence Diagram: ดูประวัติการคำนวณ (View History)

```mermaid
sequenceDiagram
    actor User as ผู้ใช้งาน
    participant UI as History Screen
    participant API as ApiService
    participant Backend as FastAPI Backend
    participant DB as SQLite Database
    
    User->>UI: เปิดหน้าประวัติ
    
    activate UI
    UI->>API: fetchCalculations(limit: 50)
    
    activate API
    API->>Backend: GET /api/calculations?limit=50
    
    activate Backend
    Backend->>DB: SELECT * FROM price_calculations<br/>ORDER BY date DESC LIMIT 50
    activate DB
    DB-->>Backend: List of calculations
    deactivate DB
    
    Backend-->>API: JSON Array of history
    deactivate Backend
    
    API->>API: PriceCalculation.fromJson()
    API-->>UI: List<PriceCalculation>
    deactivate API
    
    UI->>UI: setState(history: data)
    UI->>User: แสดงประวัติการคำนวณ<br/>(วันที่, ชนิดส้ม, น้ำหนัก, ราคา)
    deactivate UI
```

## 5. Sequence Diagram: Error Handling with Fallback

```mermaid
sequenceDiagram
    actor User as ผู้ใช้งาน
    participant UI as Screen
    participant API as ApiService
    participant Backend as FastAPI Backend
    participant Local as Local Data (orangeTypes)
    
    User->>UI: ร้องขอข้อมูล
    UI->>API: fetchOranges()
    
    activate API
    API->>Backend: GET /api/oranges
    
    alt Backend Available
        Backend-->>API: Success response
        API-->>UI: Remote data
    else Backend Unavailable
        Backend--xAPI: Error / Timeout
        API->>Local: Use orangeTypes array
        Local-->>API: Local orange data
        API-->>UI: Fallback local data
    end
    deactivate API
    
    UI->>User: แสดงข้อมูล<br/>(จากเซิร์ฟเวอร์หรือข้อมูลท้องถิ่น)
```

## Key Points

1. **Asynchronous Operations**: ทุก API call ใช้ async/await pattern
2. **Error Handling**: มี fallback ไปใช้ข้อมูลท้องถิ่นเมื่อ Backend ไม่พร้อม
3. **State Management**: ใช้ setState() สำหรับอัพเดท UI
4. **Database Persistence**: บันทึกทุกการคำนวณลง SQLite
5. **Web Scraping**: ดึงราคาจาก Talaadthai.com แบบ real-time
