# DormHub Flutter — phiên bản giao diện 1.4

Ứng dụng demo quản lý ký túc xá sinh viên, gồm đăng nhập/đăng ký và 4 khu vực chức năng riêng theo vai trò. Phiên bản 1.4 làm mới hệ thống giao diện theo hướng hiện đại, đồng bộ và responsive; mã nguồn được chia thành các file để dễ chỉnh sửa trong Visual Studio Code.

## Điểm mới về giao diện (1.4)
- Đồng bộ bảng màu xanh navy – xanh dương, nền sáng và độ tương phản chữ.
- Làm mới sidebar theo vai trò, trạng thái menu đang chọn và nhận diện DormHub.
- Thiết kế lại thẻ thống kê, thẻ nội dung, trạng thái và tiêu đề trang.
- Tạo điểm nhấn cho khu vực chào mừng trên dashboard và màn hình đăng nhập.
- Cải thiện khoảng cách, bo góc, đổ bóng và bố cục ở màn hình nhỏ.
- Giữ lại cấu trúc chức năng và dữ liệu demo hiện có.
- Làm mới trang **Đăng ký phòng** theo bố cục thẻ tòa nhà A–D, số phòng trống và chú giải trạng thái.
- Gộp danh sách **Đơn đăng ký của tôi** xuống ngay trang đăng ký phòng; bổ sung xem chi tiết, hủy đơn đang chờ duyệt và gửi đơn theo tòa/loại phòng.
- Thiết kế lại trang **Theo dõi hợp đồng** theo ảnh mẫu: hợp đồng hiện tại, thông tin phòng/loại phòng/thời hạn/chi phí, các nút tải/gia hạn/chấm dứt và bảng lịch sử hợp đồng.
- Tách các màn hình sinh viên (đăng ký phòng, hợp đồng, hóa đơn/thanh toán, báo sự cố/theo dõi sự cố) thành widget riêng; dữ liệu hợp đồng đi qua `ContractRepository` để sẵn sàng thay bằng API backend.

## Công nghệ
- Flutter + Dart
- Material 3
- Dữ liệu demo dùng chung trong `lib/data/demo_store.dart`
- Không yêu cầu gói ngoài ngoài Flutter SDK

## Chạy dự án
1. Cài Flutter SDK, Google Chrome và extension **Flutter** + **Dart** trong Visual Studio Code.
2. Giải nén ZIP và mở thư mục `dormhub_flutter_dart`.
3. Mở Terminal tại thư mục dự án, chạy:

   ```bash
   flutter doctor
   flutter pub get
   flutter run -d chrome
   ```

## Tài khoản demo
Mật khẩu ban đầu của các tài khoản mẫu là `123456`.

| Vai trò | Email |
|---|---|
| Sinh viên | `sv@university.edu.vn` |
| Quản lý KTX | `qlktx@university.edu.vn` |
| Kỹ thuật viên | `kt@university.edu.vn` |
| Quản trị viên | `admin@university.edu.vn` |

Trang đăng nhập không cho chọn vai trò. Hệ thống xác định vai trò từ tài khoản đã đăng nhập. Đăng ký công khai chỉ tạo tài khoản **Sinh viên**; quyền Quản lý KTX, Kỹ thuật viên và Quản trị viên chỉ do quản trị viên cấp trong khu vực quản lý tài khoản.

## Các thao tác đã nối trong bản demo

### Sinh viên
- Xem tình trạng phòng trống của 4 tòa, nộp đơn theo tòa/loại phòng và theo dõi các đơn ngay trong trang **Đăng ký phòng**.
- Xem chi tiết hoặc hủy đơn đang chờ duyệt; trạng thái được cập nhật trong phiên demo.
- Gửi yêu cầu sửa chữa, chọn loại sự cố và theo dõi tiến độ.
- Xem hóa đơn thuộc email của mình và xác nhận trạng thái thanh toán demo.
- Xem/cập nhật tên trong hồ sơ.

### Quản lý KTX
- Duyệt hoặc từ chối đơn đăng ký. Khi duyệt đơn chưa có phòng, bản demo thử gán một phòng mẫu còn trống.
- Thêm sinh viên, tạo hóa đơn, ghi nhận vi phạm.
- Gán yêu cầu sửa chữa cho đội kỹ thuật và cập nhật trạng thái xử lý.
- Xem số liệu tổng quan từ danh sách demo.

### Kỹ thuật viên
- Nhận xử lý và đánh dấu hoàn thành yêu cầu sửa chữa.
- Nhập vật tư; khi mã vật tư đã tồn tại, số lượng được cộng vào tồn kho.
- Xem lịch bảo trì mẫu và số liệu sự cố/tồn kho.

### Quản trị viên
- Tạo tài khoản, khóa hoặc mở khóa tài khoản.
- Xem bảng quyền theo vai trò, nhật ký thao tác và cấu hình demo.
- Khi tạo tài khoản từ khu vực quản trị, mật khẩu ban đầu là `123456`.

## Đăng ký và quên mật khẩu
- Đăng ký kiểm tra họ tên, định dạng email, email trùng và mật khẩu xác nhận.
- Tài khoản tự đăng ký luôn có quyền Sinh viên; không có bộ chọn vai trò trên màn hình đăng nhập/đăng ký.
- Quên mật khẩu cho phép đặt mật khẩu mới trong bộ nhớ demo sau khi nhập email tài khoản. Đây không phải quy trình an toàn cho môi trường thực vì chưa có xác minh email.

## Cấu trúc chính

```text
lib/
├── main.dart
├── data/
│   ├── demo_store.dart                 # Dữ liệu demo dùng chung
│   └── contracts/
│       └── contract_repository.dart    # Giao diện repository + nguồn dữ liệu demo hợp đồng
├── models/
│   └── dorm_contract.dart              # Model hợp đồng, tách khỏi UI
├── theme/
│   └── app_theme.dart
├── pages/
│   ├── login_page.dart
│   ├── home_page.dart                  # Khung điều hướng, nhận diện vai trò
│   ├── dashboards/                     # Dashboard tách theo từng vai trò
│   │   ├── dashboard_common.dart
│   │   ├── student_dashboard.dart
│   │   ├── manager_dashboard.dart
│   │   ├── technician_dashboard.dart
│   │   └── admin_dashboard.dart
│   └── student/                        # Các màn hình nghiệp vụ sinh viên
│       ├── room_booking_page.dart
│       ├── contract_page.dart
│       ├── billing_page.dart
│       └── issue_pages.dart
└── widgets/
    ├── app_sidebar.dart
    └── common_widgets.dart
```

### Chuẩn bị cho backend
- `StudentContractPage` nhận `ContractRepository` qua constructor; hiện mặc định dùng `DemoContractRepository`. Khi có API, tạo implementation mới gọi REST endpoint rồi truyền vào widget.
- `DormContract` là model giao tiếp giữa UI và nguồn dữ liệu; có thể ánh xạ JSON từ backend vào model.
- Giữ `HomePage` làm khung điều hướng/kiểm tra vai trò; các màn hình sinh viên được tách riêng để không trộn UI với logic lưu dữ liệu.
- Các thao tác trong bản hiện tại vẫn là demo, chưa gọi API thật hoặc triển khai phân quyền bảo mật phía máy chủ.

## Giới hạn của bản demo
Các dữ liệu và thao tác hiện được lưu trong bộ nhớ ứng dụng và sẽ mất khi tải lại hoặc khởi động lại. Xác nhận thanh toán không chuyển tiền thật; email không được gửi; đặt lại mật khẩu chưa xác minh email. Để triển khai thực tế cần API/CSDL, xác thực an toàn, kiểm soát quyền ở backend và lưu nhật ký phía máy chủ.
