# Ứng Dụng Phân Loại Bệnh Lá Cây Cacao (TensorFlow Lite)

Ứng dụng Flutter sử dụng TensorFlow Lite để phân loại các bệnh trên lá cây cacao, tích hợp với Firebase để quản lý thông tin chi tiết về bệnh.

## Tính Năng
- Chụp ảnh hoặc chọn ảnh từ thư viện
- Phân loại bệnh lá cacao sử dụng mô hình EfficientNetB0
- Hiển thị thông tin chi tiết về bệnh từ Firebase
- Giao diện người dùng trực quan và dễ sử dụng
- Hỗ trợ đa nền tảng (iOS, Android)

## Cấu Trúc Mô Hình
- Framework: TensorFlow Lite
- Mô hình: EfficientNetB0
- File mô hình: `assets/models/efficientnetb0.tflite`
- File nhãn: `assets/labels.txt`
- Thông tin bệnh: `assets/disease_info.json`

## Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^1.0.4
  tflite_flutter: ^0.11.0
  firebase_core: ^2.30.0
  cloud_firestore: ^4.9.0
  image: ^4.5.4
```

## Cài Đặt
1. Đảm bảo đã cài đặt Flutter SDK và Dart SDK
2. Clone repository này
3. Cấu hình Firebase:
   - Tạo project trên Firebase Console
   - Tải file google-services.json và thêm vào android/app/
   - Cấu hình Firebase trong iOS (nếu cần)
4. Mở terminal trong thư mục dự án
5. Chạy các lệnh sau:
   ```bash
   flutter pub get
   flutter run
   ```

## Cấu Trúc Thư Mục
```
cacao_tflite/
  ├── assets/
  │   ├── models/
  │   │   └── efficientnetb0.tflite  # Mô hình TFLite
  │   ├── disease_info.json          # Thông tin chi tiết về bệnh
  │   └── labels.txt                 # File nhãn phân loại
  ├── lib/
  │   ├── main.dart                  # Mã nguồn chính
  │   └── screens/                   # Các màn hình ứng dụng
  └── ...
```

## Sử Dụng
1. Mở ứng dụng
2. Chọn "Chụp ảnh" hoặc "Chọn ảnh từ thư viện"
3. Đợi ứng dụng phân tích và hiển thị kết quả
4. Xem kết quả phân loại và thông tin chi tiết về bệnh

## Lưu ý Phát Triển
- Đảm bảo đã cấu hình Firebase đúng cách
- Kiểm tra file TFLite và labels.txt đã được đặt đúng vị trí
- Cập nhật disease_info.json khi có thông tin mới về bệnh
- Test ứng dụng trên cả iOS và Android
- Tối ưu kích thước ảnh trước khi đưa vào mô hình

## Yêu Cầu Thiết Bị
- iOS 11.0 trở lên
- Android 5.0 (API 21) trở lên
- RAM: tối thiểu 2GB
- Bộ nhớ trống: tối thiểu 100MB

## Cấu Trúc Firebase
Collection: `diseases`
Document structure:
```json
{
  "name": "Tên bệnh",
  "description": "Mô tả chi tiết về bệnh",
  "symptoms": ["Triệu chứng 1", "Triệu chứng 2"],
  "treatments": ["Cách điều trị 1", "Cách điều trị 2"],
  "preventions": ["Cách phòng ngừa 1", "Cách phòng ngừa 2"]
}
```
