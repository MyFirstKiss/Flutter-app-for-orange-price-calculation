# 🍊 Orange Calculator App (Flutter)

แอปพลิเคชัน Flutter สำหรับจัดการข้อมูลและคำนวณราคาผลส้ม พร้อมระบบ Backend ที่ดึงราคาจากตลาดไทแบบ Real-time

## ✨ ฟีเจอร์หลัก

- 📊 **ข้อมูลที่จัดเก็บ** - แสดงข้อมูลมิติและขนาดของส้ม 3 ชนิด
- 🧮 **คำนวณราคา** - คำนวณราคาตามน้ำหนัก (กิโลกรัม)
- 💰 **ราคาล่าสุด** - ดึงราคาแบบ Real-time จาก Talaadthai.com
- 🌐 **Web Scraping** - ดึงข้อมูลราคาจริงจากเว็บตลาดไท
- 📱 **Cross-platform** - รองรับ Web, Android, iOS

## 🍊 ชนิดผลส้มที่รองรับ

1. **ส้มสายน้ำผึ้ง** - รสชาติหวานฉ่ำ เนื้อนุ่ม น้ำมาก
2. **ส้มเขียวหวาน** - หวานกรอบ สดชื่น ไม่เปรี้ยว
3. **ส้มแมนดาริน** - ��วานหอม ปอกง่าย เนื้อละเอียด

## 🛠️ เทคโนโลยีที่ใช้

### Frontend (Flutter)
- **Flutter** 3.0+ - UI Framework
- **Dart** - Programming Language
- **Material Design 3** - UI/UX Design System
- **HTTP Package** - API Communication

### Backend (Python)
- **FastAPI** 0.115.0 - Web Framework
- **BeautifulSoup4** 4.12.3 - Web Scraping
- **Uvicorn** 0.32.0 - ASGI Server
- **Requests** 2.32.3 - HTTP Library
- **Pydantic** 2.9.2 - Data Validation

## 📦 การติดตั้ง

### ความต้องการของระบบ

- **Flutter SDK** 3.0.0 หรือสูงกว่า
- **Python** 3.11+
- **Git**

### 1. Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/orange-calculator-app-flutter.git
cd orange-calculator-app-flutter
```

### 2. ติดตั้ง Flutter Dependencies

```bash
flutter pub get
```

### 3. ติดตั้ง Python Dependencies

```bash
cd backend
pip install -r requirements.txt
```

## 🚀 การรันแอป

### 1. เริ่ม Backend Server

```bash
python backend/main.py
```

Backend จะทำงานที่: `http://localhost:8000`

### 2. เริ่ม Flutter App

```bash
# รันบน Chrome
flutter run -d chrome

# รันบน Android
flutter run -d android

# รันบน iOS
flutter run -d ios
```

## 📡 API Endpoints

Backend มี 5 endpoints หลัก:

- `GET /` - Health check
- `GET /oranges` - ราคาส้มจาก Talaadthai (filtered)
- `GET /api/oranges` - ข้อมูลส้มสำหรับ Flutter
- `GET /api/oranges/{id}` - ข้อมูลส้มรายตัว
- `POST /api/calculate` - คำนวณราคา
- `GET /api/prices` - ราคา real-time

## 📁 โครงสร้างโปรเจกต์

```
orange-calculator-app-flutter/
├── lib/
│   ├── main.dart                 # Entry point
│   ├── models/
│   │   └── orange_type.dart      # Data model
│   ├── screens/
│   │   ├── home_screen.dart      # หน้าแรก
│   │   ├── data_screen.dart      # หน้าข้อมูล
│   │   ├── calculator_screen.dart # หน้าคำนวณ
│   │   └── live_prices_screen.dart # หน้าราคาล่าสุด
│   ├── services/
│   │   └── api_service.dart      # HTTP service
│   ├── utils/
│   │   └── app_theme.dart        # Theme constants
│   └── widgets/
│       └── common_widgets.dart   # Reusable widgets
├── backend/
│   ├── main.py                   # FastAPI server
│   ├── requirements.txt          # Python dependencies
│   └── README.md                 # Backend docs
├── pubspec.yaml                  # Flutter config
└── README.md                     # Project docs
```

## 🎨 UI/UX Features

- ✅ Material Design 3
- ✅ Gradient backgrounds
- ✅ Emoji icons (🍊)
- ✅ Loading indicators
- ✅ Empty states
- ✅ Status badges
- ✅ Responsive design
- ✅ Consistent theming

## 🧪 การทดสอบ

```bash
# Analyze code
flutter analyze

# Run tests
flutter test
```

## 📄 License

MIT License - สามารถใช้งานได้อย่างอิสระ

## 👨‍💻 ผู้พัฒนา

Converted from Next.js/React to Flutter with Backend Integration

## 🤝 การมีส่วนร่วม

Pull requests are welcome! สำหรับการเปลี่ยนแปลงใหญ่ กรุณาเปิด issue เพื่อหารือก่อน

## 📝 หมายเหตุ

- ข้อมูลราคาดึงจาก Talaadthai.com แบบ real-time
- Cache ราคา 1 ชั่วโมงเพื่อลดการ scrape
- มี fallback data กรณี API ไม่พร้อมใช้งาน
- รองรับ CORS สำหรับการพัฒนาบน localhost

## 🔗 Links

- [Flutter Documentation](https://docs.flutter.dev)
- [FastAPI Documentation](https://fastapi.tiangolo.com)
- [Talaadthai.com](https://talaadthai.com)

---

Made with ❤️ and 🍊
