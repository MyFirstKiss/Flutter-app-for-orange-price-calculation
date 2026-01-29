# แผนภาพลำดับการทำงาน (Sequence Diagrams) - แอปคำนวณราคาส้ม

## 1. แผนภาพลำดับ: คำนวณราคาส้ม

```mermaid
sequenceDiagram
    actor User as ผู้ใช้งาน
    participant UI as หน้าจอคำนวณ
    participant API as ตัวจัดการ API
    participant Backend as เซิร์ฟเวอร์ FastAPI
    participant DB as ฐานข้อมูล SQLite
    
    User->>UI: เลือกชนิดส้ม
    User->>UI: ใส่น้ำหนัก (kg)
    User->>UI: กดปุ่ม "คำนวณ"
    
    activate UI
    UI->>UI: setState(isCalculating: true)
    UI->>API: calculatePrice(orangeId, weight)
    
    activate API
    API->>Backend: POST /api/calculate?orange_id=xxx&weight=xxx
    
    activate Backend
    Backend->>DB: ดึงข้อมูลส้ม (SELECT)
    activate DB
    DB-->>Backend: ข้อมูลชนิดส้ม
    deactivate DB
    
    Backend->>Backend: คำนวณราคารวม = น้ำหนัก × ราคาต่อ kg
    Backend->>DB: บันทึกประวัติการคำนวณ (INSERT)
    activate DB
    DB-->>Backend: สำเร็จ
    deactivate DB
    
    Backend-->>API: {รหัสส้ม, น้ำหนัก, ราคาต่อ kg, ราคารวม}
    deactivate Backend
    
    API-->>UI: ผลการคำนวณ
    deactivate API
    
    UI->>UI: อัพเดทสถานะ(ราคารวม, หยุดคำนวณ)
    UI->>User: แสดงราคารวม
    deactivate UI
```

## 2. แผนภาพลำดับ: ดูข้อมูลส้ม

```mermaid
sequenceDiagram
    actor User as ผู้ใช้งาน
    participant UI as หน้าจอข้อมูล
    participant API as ตัวจัดการ API
    participant Backend as เซิร์ฟเวอร์ FastAPI
    participant DB as ฐานข้อมูล SQLite
    
    User->>UI: เปิดหน้าข้อมูลส้ม
    
    activate UI
    UI->>UI: เริ่มต้น / ตั้งสถานะกำลังโหลด
    UI->>API: ดึงข้อมูลส้มทั้งหมด()
    
    activate API
    API->>Backend: ดึงข้อมูล /api/oranges
    
    activate Backend
    Backend->>DB: เลือกข้อมูลส้มทั้งหมด
    activate DB
    DB-->>Backend: รายการชนิดส้ม
    deactivate DB
    
    Backend-->>API: อาร์เรย์ JSON ของส้ม
    deactivate Backend
    
    API->>API: แปลง JSON เป็นออบเจกต์
    API-->>UI: รายการชนิดส้ม
    deactivate API
    
    UI->>UI: อัพเดทสถานะ(ข้อมูล, หยุดโหลด)
    UI->>User: แสดงรายการส้มพร้อมรายละเอียด
    deactivate UI
```

## 3. แผนภาพลำดับ: ดูราคาปัจจุบัน (ดึงจากเว็บไซต์)

```mermaid
sequenceDiagram
    actor User as ผู้ใช้งาน
    participant UI as หน้าจอราคาปัจจุบัน
    participant API as ตัวจัดการ API
    participant Backend as เซิร์ฟเวอร์ FastAPI
    participant Web as เว็บตลาดไทย
    participant DB as ฐานข้อมูล SQLite
    
    User->>UI: เปิดหน้าราคาปัจจุบัน
    
    activate UI
    UI->>UI: ตั้งสถานะกำลังโหลด
    UI->>API: ดึงราคาล่าสุด()
    
    activate API
    API->>Backend: ดึงราคา /api/prices
    
    activate Backend
    Backend->>Web: เรียกข้อมูลจากเว็บตลาดไทย
    activate Web
    Web-->>Backend: ตอบกลับ HTML
    deactivate Web
    
    Backend->>Backend: แปลงและประมวลผล HTML
    Backend->>Backend: กรองคำค้นส้ม<br/>(แมนดาริน, เขียวหวาน, สายน้ำผึ้ง)
    Backend->>Backend: ดึงช่วงราคา()
    
    Backend->>DB: อัพเดทราคาส้ม
    activate DB
    DB-->>Backend: สำเร็จ
    deactivate DB
    
    Backend-->>API: อาร์เรย์ JSON ราคาล่าสุด
    deactivate Backend
    
    API-->>UI: รายการราคา
    deactivate API
    
    UI->>UI: อัพเดทสถานะ(ราคา, หยุดโหลด)
    UI->>User: แสดงราคาล่าสุด
    deactivate UI
```

## 4. แผนภาพลำดับ: ดูประวัติการคำนวณ

```mermaid
sequenceDiagram
    actor User as ผู้ใช้งาน
    participant UI as หน้าจอประวัติ
    participant API as ตัวจัดการ API
    participant Backend as เซิร์ฟเวอร์ FastAPI
    participant DB as ฐานข้อมูล SQLite
    
    User->>UI: เปิดหน้าประวัติ
    
    activate UI
    UI->>API: ดึงประวัติการคำนวณ(จำกัด: 50)
    
    activate API
    API->>Backend: ดึงประวัติ /api/calculations?limit=50
    
    activate Backend
    Backend->>DB: เลือกประวัติการคำนวณ<br/>เรียงตามวันที่ล่าสุด 50 รายการ
    activate DB
    DB-->>Backend: รายการประวัติการคำนวณ
    deactivate DB
    
    Backend-->>API: อาร์เรย์ JSON ของประวัติ
    deactivate Backend
    
    API->>API: แปลง JSON เป็นออบเจกต์
    API-->>UI: รายการประวัติการคำนวณ
    deactivate API
    
    UI->>UI: อัพเดทสถานะ(ประวัติ)
    UI->>User: แสดงประวัติการคำนวณ<br/>(วันที่, ชนิดส้ม, น้ำหนัก, ราคา)
    deactivate UI
```

## 5. แผนภาพลำดับ: การจัดการข้อผิดพลาดและระบบสำรอง

```mermaid
sequenceDiagram
    actor User as ผู้ใช้งาน
    participant UI as หน้าจอ
    participant API as ตัวจัดการ API
    participant Backend as เซิร์ฟเวอร์ FastAPI
    participant Local as ข้อมูลท้องถิ่น
    
    User->>UI: ร้องขอข้อมูล
    UI->>API: ดึงข้อมูลส้ม()
    
    activate API
    API->>Backend: ดึงข้อมูล /api/oranges
    
    alt เซิร์ฟเวอร์พร้อมใช้งาน
        Backend-->>API: ตอบกลับสำเร็จ
        API-->>UI: ข้อมูลจากเซิร์ฟเวอร์
    else เซิร์ฟเวอร์ไม่พร้อมใช้งาน
        Backend--xAPI: ข้อผิดพลาด / หมดเวลา
        API->>Local: ใช้ข้อมูลท้องถิ่น
        Local-->>API: ข้อมูลส้มท้องถิ่น
        API-->>UI: ข้อมูลสำรอง
    end
    deactivate API
    
    UI->>User: แสดงข้อมูล<br/>(จากเซิร์ฟเวอร์หรือข้อมูลท้องถิ่น)
```

## จุดสำคัญ

1. **การทำงานแบบอะซิงโครนัส**: ทุก API call ใช้ async/await pattern
2. **การจัดการข้อผิดพลาด**: มีระบบสำรองใช้ข้อมูลท้องถิ่นเมื่อเซิร์ฟเวอร์ไม่พร้อม
3. **การจัดการสถานะ**: ใช้ setState() สำหรับอัพเดท UI
4. **การบันทึกข้อมูล**: บันทึกทุกการคำนวณลงฐานข้อมูล SQLite
5. **การดึงข้อมูลจากเว็บ**: ดึงราคาจากเว็บตลาดไทยแบบเรียลไทม์
