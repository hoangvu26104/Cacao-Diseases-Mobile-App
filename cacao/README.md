# Ứng Dụng Phân Loại Bệnh Lá Cây Cacao (PyTorch Mobile)

Ứng dụng Flutter sử dụng PyTorch Mobile để phân loại các bệnh trên lá cây cacao.

## Tính Năng
- Chụp ảnh hoặc chọn ảnh từ thư viện
- Phân loại bệnh lá cacao sử dụng mô hình MobileViT-XS
- Giao diện người dùng trực quan và dễ sử dụng
- Hỗ trợ đa nền tảng (iOS, Android)

## Cấu Trúc Mô Hình
- Framework: PyTorch Mobile
- Mô hình: MobileViT-XS (được tối ưu hóa cho thiết bị di động)
- File mô hình: `assets/mobilevit_xs_scripted.pt`
- File nhãn: `assets/labels.txt`

## Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^1.1.2
  image: ^4.5.4
  # Uncomment dòng sau và chạy flutter pub get
  # pytorch_lite: ^1.0.4
```

## Cài Đặt
1. Đảm bảo đã cài đặt Flutter SDK và Dart SDK
2. Clone repository này
3. Mở terminal trong thư mục dự án
4. Chạy các lệnh sau:
   ```bash
   flutter pub get
   flutter run
   ```

## Cấu Trúc Thư Mục
```
cacao/
  ├── assets/
  │   ├── mobilevit_xs_scripted.pt   # Mô hình PyTorch
  │   └── labels.txt                 # File nhãn phân loại
  ├── lib/
  │   └── main.dart                  # Mã nguồn chính
  └── ...
```

## Sử Dụng
1. Mở ứng dụng
2. Chọn "Chụp ảnh" hoặc "Chọn ảnh từ thư viện"
3. Đợi ứng dụng phân tích và hiển thị kết quả
4. Xem kết quả phân loại bệnh
