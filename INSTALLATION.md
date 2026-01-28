# วิธีการติดตั้งและรันโปรเจกต์ Flutter

## 1. ติดตั้ง Flutter SDK

หากยังไม่มี Flutter ให้ติดตั้งก่อน:

### Windows
```powershell
# ดาวน์โหลด Flutter SDK จาก
https://docs.flutter.dev/get-started/install/windows

# หรือใช้ Git
git clone https://github.com/flutter/flutter.git -b stable
```

### เพิ่ม Flutter ใน PATH
เพิ่ม path ของ Flutter bin folder ใน Environment Variables

## 2. ตรวจสอบการติดตั้ง

```bash
flutter doctor
```

คำสั่งนี้จะแสดงสถานะของการติดตั้ง ให้แก้ไขปัญหาที่พบ (ถ้ามี)

## 3. ติดตั้ง Dependencies ของโปรเจกต์

ในโฟลเดอร์โปรเจกต์ให้รันคำสั่ง:

```bash
flutter pub get
```

## 4. รันโปรเจกต์

### รันบน Chrome (Web)
```bash
flutter run -d chrome
```

### รันบน Android Emulator
```bash
# เปิด Android Emulator ก่อน แล้วรัน
flutter run -d android
```

### รันบน Windows Desktop
```bash
flutter run -d windows
```

### รันบน iOS Simulator (macOS only)
```bash
flutter run -d ios
```

## 5. สร้างไฟล์สำหรับ Production

### สำหรับ Android (APK)
```bash
flutter build apk --release
```
ไฟล์จะอยู่ที่: `build/app/outputs/flutter-apk/app-release.apk`

### สำหรับ Windows
```bash
flutter build windows --release
```
ไฟล์จะอยู่ที่: `build/windows/runner/Release/`

### สำหรับ Web
```bash
flutter build web --release
```
ไฟล์จะอยู่ที่: `build/web/`

## 6. การ Debug

### รัน Debug Mode
```bash
flutter run
```

### ดู Logs
```bash
flutter logs
```

### Hot Reload
เมื่อแอปกำลังรันอยู่ กด `r` ใน terminal เพื่อ hot reload
กด `R` เพื่อ hot restart

## 7. เคล็ดลับ

- ใช้ `flutter pub upgrade` เพื่ออัพเดท packages
- ใช้ `flutter clean` เพื่อลบ build cache หากมีปัญหา
- ใช้ `flutter analyze` เพื่อตรวจสอบโค้ด

## 8. ปัญหาที่อาจพบ

### ปัญหา: "No devices found"
**แก้ไข**: ตรวจสอบว่าเปิด emulator หรือเชื่อมต่ออุปกรณ์แล้ว
```bash
flutter devices
```

### ปัญหา: Build ล้มเหลว
**แก้ไข**: ลองรันคำสั่งเหล่านี้
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

## การติดตั้ง Android Emulator (ถ้ายังไม่มี)

1. ติดตั้ง Android Studio
2. เปิด Android Studio > Tools > AVD Manager
3. Create Virtual Device
4. เลือก device และ system image
5. Finish

แล้วรัน emulator ด้วยคำสั่ง:
```bash
flutter emulators --launch <emulator-id>
```

---

**เริ่มต้นใช้งาน**

หลังจากติดตั้งเรียบร้อยแล้ว ให้รันคำสั่ง:

```bash
cd orange-calculator-app-flutter
flutter pub get
flutter run
```

เลือก device ที่ต้องการ และแอปจะเริ่มทำงาน! 🚀
