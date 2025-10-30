# Ứng Dụng Phân Loại Bệnh Lá Cây Cacao

Dự án này bao gồm hai phiên bản của ứng dụng phân loại bệnh lá cây cacao sử dụng Flutter, mỗi phiên bản sử dụng một framework deep learning khác nhau.
![Ảnh minh họa](img_demo/Screenshot%202025-10-30%20144612.png)


## Mục Lục
1. [Tổng Quan](#tổng-quan)
2. [Phiên Bản PyTorch Mobile](cacao/README.md)
   - Sử dụng PyTorch Mobile
   - Mô hình MobileViT-XS
   - [Chi tiết và hướng dẫn](cacao/README.md#tính-năng)
3. [Phiên Bản TensorFlow Lite](cacao_tflite/README.md)
   - Sử dụng TensorFlow Lite
   - Mô hình EfficientNetB0
   - Tích hợp Firebase
   - [Chi tiết và hướng dẫn](cacao_tflite/README.md#tính-năng)
4. [Yêu Cầu Hệ Thống](#yêu-cầu-hệ-thống)
5. [Cài Đặt](#cài-đặt)

## Tổng Quan

## 1. Phiên Bản PyTorch Mobile (`cacao/`)
- Sử dụng PyTorch Mobile để thực hiện việc phân loại
- Mô hình: MobileViT-XS được tối ưu hóa cho thiết bị di động
- Phù hợp cho các ứng dụng yêu cầu độ chính xác cao và khả năng mở rộng mô hình

## 2. Phiên Bản TensorFlow Lite (`cacao_tflite/`)
- Sử dụng TensorFlow Lite để thực hiện việc phân loại
- Mô hình: EfficientNetB0 được tối ưu hóa cho thiết bị di động
- Tích hợp với Firebase để lưu trữ thông tin chi tiết về bệnh
- Phù hợp cho các ứng dụng yêu cầu kích thước nhỏ và tốc độ xử lý nhanh

## Yêu Cầu Hệ Thống
- Flutter SDK: ^3.8.1
- Dart SDK: ^3.8.1
- Android Studio hoặc VS Code với Flutter extension

## Cài Đặt
1. Clone repository này
2. Di chuyển vào thư mục dự án mong muốn (`cacao/` hoặc `cacao_tflite/`)
3. Chạy `flutter pub get` để cài đặt dependencies
4. Build và chạy ứng dụng với `flutter run`
