# แผนภาพลำดับการทำงาน - แอปคำนวณราคาส้ม

## แผนภาพรวมระบบทั้งหมด

```mermaid
sequenceDiagram
    actor User as ผู้ใช้งาน
    participant Home as หน้าหลัก
    participant CalcUI as หน้าจอคำนวณ
    participant DataUI as หน้าจอข้อมูล
    participant PriceUI as หน้าจอราคาปัจจุบัน
    participant HistUI as หน้าจอประวัติ
    participant API as ตัวจัดการ API
    participant Backend as เซิร์ฟเวอร์ FastAPI
    participant Web as เว็บตลาดไทย
    participant DB as ฐานข้อมูล SQLite
    participant Local as ข้อมูลท้องถิ่น
    
    Note over User,Local: ระบบแอปพลิเคชันคำนวณราคาส้ม
    
    %% Flow 1: คำนวณราคา
    rect rgb(255, 240, 240)
    Note over User,DB: 1. การคำนวณราคาส้ม
    User->>Home: เปิดแอป
    User->>CalcUI: เลือกเมนูคำนวณ
    User->>CalcUI: เลือกชนิดส้ม + ใส่น้ำหนัก
    User->>CalcUI: กดปุ่ม "คำนวณ"
    
    activate CalcUI
    CalcUI->>API: calculatePrice(orangeId, weight)
    activate API
    API->>Backend: POST /api/calculate
    activate Backend
    Backend->>DB: ดึงข้อมูลส้ม + คำนวณ
    activate DB
    DB-->>Backend: ข้อมูล + บันทึกประวัติ
    deactivate DB
    Backend-->>API: ผลการคำนวณ
    deactivate Backend
    API-->>CalcUI: ราคารวม
    deactivate API
    CalcUI->>User: แสดงราคารวม
    deactivate CalcUI
    end
    
    %% Flow 2: ดูข้อมูลส้ม
    rect rgb(240, 255, 240)
    Note over User,DB: 2. การดูข้อมูลส้ม
    User->>DataUI: เลือกเมนูข้อมูลส้ม
    activate DataUI
    DataUI->>API: fetchOranges()
    activate API
    
    alt เซิร์ฟเวอร์พร้อมใช้งาน
        API->>Backend: GET /api/oranges
        activate Backend
        Backend->>DB: SELECT ข้อมูลทั้งหมด
        activate DB
        DB-->>Backend: รายการส้ม
        deactivate DB
        Backend-->>API: JSON ข้อมูลส้ม
        deactivate Backend
        API-->>DataUI: รายการชนิดส้ม
    else เซิร์ฟเวอร์ไม่พร้อม
        API->>Local: ใช้ข้อมูลท้องถิ่น
        Local-->>API: ข้อมูลสำรอง
        API-->>DataUI: รายการส้มท้องถิ่น
    end
    
    deactivate API
    DataUI->>User: แสดงรายการส้ม
    deactivate DataUI
    end
    
    %% Flow 3: ดูราคาปัจจุบัน
    rect rgb(240, 240, 255)
    Note over User,DB: 3. การดูราคาปัจจุบัน (Web Scraping)
    User->>PriceUI: เลือกเมนูราคาปัจจุบัน
    activate PriceUI
    PriceUI->>API: fetchLivePrices()
    activate API
    API->>Backend: GET /api/prices
    activate Backend
    Backend->>Web: ดึงข้อมูลจากเว็บไซต์
    activate Web
    Web-->>Backend: HTML ราคาส้ม
    deactivate Web
    Backend->>Backend: แปลง + ประมวลผล HTML
    Backend->>DB: อัพเดทราคา
    activate DB
    DB-->>Backend: สำเร็จ
    deactivate DB
    Backend-->>API: ราคาล่าสุด
    deactivate Backend
    API-->>PriceUI: รายการราคา
    deactivate API
    PriceUI->>User: แสดงราคาปัจจุบัน
    deactivate PriceUI
    end
    
    %% Flow 4: ดูประวัติ
    rect rgb(255, 255, 240)
    Note over User,DB: 4. การดูประวัติการคำนวณ
    User->>HistUI: เลือกเมนูประวัติ
    activate HistUI
    HistUI->>API: fetchCalculations(limit: 50)
    activate API
    API->>Backend: GET /api/calculations?limit=50
    activate Backend
    Backend->>DB: SELECT ประวัติล่าสุด
    activate DB
    DB-->>Backend: รายการประวัติ
    deactivate DB
    Backend-->>API: JSON ประวัติ
    deactivate Backend
    API-->>HistUI: รายการประวัติการคำนวณ
    deactivate API
    HistUI->>User: แสดงประวัติ (วันที่, ส้ม, น้ำหนัก, ราคา)
    deactivate HistUI
    end
```

## จุดสำคัญ

1. **การทำงานแบบอะซิงโครนัส**: ทุก API call ใช้ async/await pattern
2. **การจัดการข้อผิดพลาด**: มีระบบสำรองใช้ข้อมูลท้องถิ่นเมื่อเซิร์ฟเวอร์ไม่พร้อม
3. **การจัดการสถานะ**: ใช้ setState() สำหรับอัพเดท UI
4. **การบันทึกข้อมูล**: บันทึกทุกการคำนวณลงฐานข้อมูล SQLite
5. **การดึงข้อมูลจากเว็บ**: ดึงราคาจากเว็บตลาดไทยแบบเรียลไทม์
6. **สถาปัตยกรรม**: แยก UI, API Service, Backend และ Database ชัดเจน
7. **การทำงานแบบ Real-time**: อัพเดทราคาจากแหล่งภายนอกและบันทึกลงฐานข้อมูล
8. **ประสบการณ์ผู้ใช้**: มี Loading indicators และ Error messages ที่ชัดเจน
