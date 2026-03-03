# api_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Cấu trúc dự án

Dưới đây là tổng quan về cách tổ chức mã nguồn và vai trò của từng file
hoặc thư mục chính trong ứng dụng Flutter/Firebase này:

### Các file ở cấp gốc

- `pubspec.yaml` – khai báo các phụ thuộc Dart/Flutter, tài nguyên và
  thông tin metadata.
- `analysis_options.yaml` – quy tắc phân tích tĩnh cho lint và định dạng.
- `firebase.json`, `FIREBASE_SETUP.md`, `SETUP_SUMMARY.md` – cấu hình và
  ghi chú thiết lập Firebase.
- `README.md` – file tài liệu này.

### Android / iOS / Web / macos / linux / windows

Các dự án riêng cho từng nền tảng do Flutter sinh ra. Chúng chứa mã
native và cấu hình dùng khi xây dựng app cho mỗi mục tiêu.

- `android/` – file build Gradle, manifest và mã Java/Kotlin cho phiên bản
  Android.
- `ios/` – dự án Xcode và cầu nối Swift/Obj‑C cho iOS.
- `web/` – HTML, CSS và JS bọc cho bản web.
- `windows/`, `macos/`, `linux/` – thư mục hỗ trợ cho desktop.

### Thư mục `lib/`

Trái tim của ứng dụng Dart/Flutter:

- `main.dart` – điểm vào của ứng dụng; thiết lập Firebase và điều hướng tới
  màn hình chính.
- `firebase_options.dart` – tùy chọn khởi tạo Firebase được tạo tự động.
- `models/` – các đối tượng miền sử dụng trong toàn app (ví dụ `dish.dart`,
  `post.dart`).
- `screens/` – các trang giao diện:
  - `home_screen.dart` – màn hình chính.
  - `firestore_screen.dart` – ví dụ tương tác với Firestore.
  - `dish_menu_screen.dart` – hiển thị danh sách món ăn.
- `services/` – logic nghiệp vụ và lớp bao API:
  - `api_service.dart` – thao tác HTTP cấp thấp.
  - `dish_service.dart` – xử lý dữ liệu liên quan đến món ăn.
  - `firebase_service.dart` – hỗ trợ xác thực Firebase và Firestore.

### Thư mục `test/`

Chứa các bài kiểm thử đơn vị và widget; hiện tại có `widget_test.dart` làm
mẫu ban đầu.

### Các thư mục liên quan đến build

- `build/` – các artefact sinh ra bởi quá trình build Flutter (bị git
  ignore).
- `.idea`/`*.iml` – file cấu hình IDE cho IntelliJ/Android Studio.

> **Lưu ý:** danh sách này không đầy đủ nhưng bao quát các file và thư
> mục chính bạn sẽ tương tác khi phát triển ứng dụng. Các file sinh ra
> (ví dụ bên trong `build/`) có thể bỏ qua trừ khi bạn đang gỡ lỗi lỗi
> build.
