/// Dữ liệu demo dùng chung trong bộ nhớ của ứng dụng.
/// Dữ liệu sẽ được đặt lại khi ứng dụng khởi động lại; cần backend/CSDL cho môi trường thật.
class DemoStore {
  DemoStore._();

  static final List<Map<String, String>> accounts = [
    {'name': 'Nguyễn Minh Anh', 'email': 'sv@university.edu.vn', 'password': '123456', 'role': 'Sinh viên', 'status': 'Đang hoạt động'},
    {'name': 'Trần Thu Hà', 'email': 'qlktx@university.edu.vn', 'password': '123456', 'role': 'Quản lý KTX', 'status': 'Đang hoạt động'},
    {'name': 'Lê Quang Huy', 'email': 'kt@university.edu.vn', 'password': '123456', 'role': 'Kỹ thuật viên', 'status': 'Đang hoạt động'},
    {'name': 'Nguyễn Hoàng Nam', 'email': 'admin@university.edu.vn', 'password': '123456', 'role': 'Quản trị viên', 'status': 'Đang hoạt động'},
  ];

  static final List<Map<String, String>> students = [
    {'id': 'SV2026001', 'name': 'Nguyễn Minh Anh', 'email': 'sv@university.edu.vn', 'room': 'A-203', 'status': 'Đang ở'},
    {'id': 'SV2026002', 'name': 'Trần Quốc Bảo', 'email': 'sv2026002@university.edu.vn', 'room': 'B-105', 'status': 'Đang ở'},
    {'id': 'SV2026003', 'name': 'Phạm Thu Hà', 'email': 'sv2026003@university.edu.vn', 'room': 'C-402', 'status': 'Chờ nhận phòng'},
    {'id': 'SV2026004', 'name': 'Lê Tuấn Kiệt', 'email': 'sv2026004@university.edu.vn', 'room': 'D-201', 'status': 'Đang ở'},
    {'id': 'SV2026005', 'name': 'Vũ Khánh Linh', 'email': 'sv2026005@university.edu.vn', 'room': 'A-105', 'status': 'Đang ở'},
  ];

  static final List<Map<String, String>> applications = [
    {'id': 'DK-2026-031', 'name': 'Nguyễn Minh Anh', 'code': 'SV2026001', 'email': 'sv@university.edu.vn', 'room': 'A-203', 'type': 'Phòng 4 người', 'date': '20/10/2026', 'status': 'Đã duyệt'},
    {'id': 'DK-2026-030', 'name': 'Trần Quốc Bảo', 'code': 'SV2026002', 'email': 'sv2026002@university.edu.vn', 'room': 'B-105', 'type': 'Phòng 6 người', 'date': '19/10/2026', 'status': 'Chờ duyệt'},
    {'id': 'DK-2026-029', 'name': 'Phạm Thu Hà', 'code': 'SV2026003', 'email': 'sv2026003@university.edu.vn', 'room': 'C-402', 'type': 'Phòng 4 người', 'date': '18/10/2026', 'status': 'Đã duyệt'},
    {'id': 'DK-2026-028', 'name': 'Lê Tuấn Kiệt', 'code': 'SV2026004', 'email': 'sv2026004@university.edu.vn', 'room': 'D-201', 'type': 'Phòng 8 người', 'date': '17/10/2026', 'status': 'Từ chối'},
  ];

  static final List<Map<String, String>> repairs = [
    {'id': 'SC-1024', 'title': 'Vòi nước bị rò rỉ', 'room': 'A-203', 'student': 'Nguyễn Minh Anh', 'email': 'sv@university.edu.vn', 'date': '20/10/2026', 'status': 'Mới'},
    {'id': 'SC-1023', 'title': 'Đèn phòng không sáng', 'room': 'B-105', 'student': 'Trần Quốc Bảo', 'email': 'sv2026002@university.edu.vn', 'date': '19/10/2026', 'status': 'Đã gán'},
    {'id': 'SC-1022', 'title': 'Điều hòa phát tiếng ồn', 'room': 'C-402', 'student': 'Phạm Thu Hà', 'email': 'sv2026003@university.edu.vn', 'date': '19/10/2026', 'status': 'Đang xử lý'},
    {'id': 'SC-1021', 'title': 'Khóa cửa khó mở', 'room': 'A-312', 'student': 'Lê Tuấn Kiệt', 'email': 'sv2026004@university.edu.vn', 'date': '18/10/2026', 'status': 'Hoàn thành'},
  ];

  static final List<Map<String, String>> bills = [
    {'id': 'HD-1026-015', 'title': 'Hóa đơn lưu trú tháng 10', 'period': '10/2026', 'amount': '745.000 ₫', 'email': 'sv@university.edu.vn', 'status': 'Chưa thanh toán', 'room': 'A-203', 'rentAmount': '600000', 'electricKwh': '120', 'electricRate': '1000', 'waterM3': '5', 'waterRate': '5000', 'sanitationAmount': '0', 'dueDate': '15/11/2026'},
    {'id': 'HD-1026-014', 'title': 'Điện nước tháng 9', 'period': '09/2026', 'amount': '185.000 ₫', 'email': 'sv@university.edu.vn', 'status': 'Đã thanh toán'},
    {'id': 'HD-1026-013', 'title': 'Phí lưu trú tháng 9', 'period': '09/2026', 'amount': '850.000 ₫', 'email': 'sv@university.edu.vn', 'status': 'Đã thanh toán'},
  ];

  static final List<Map<String, String>> violations = [
    {'id': 'VP-026', 'student': 'Trần Quốc Bảo', 'description': 'Để xe sai khu vực', 'date': '20/10/2026', 'status': 'Chờ xác minh'},
    {'id': 'VP-025', 'student': 'Lê Tuấn Kiệt', 'description': 'Gây ồn sau giờ quy định', 'date': '18/10/2026', 'status': 'Đã nhắc nhở'},
  ];

  static final List<Map<String, String>> inventory = [
    {'id': 'VT-001', 'name': 'Bóng đèn LED', 'quantity': '08', 'status': 'Sắp hết'},
    {'id': 'VT-002', 'name': 'Vòi nước', 'quantity': '15', 'status': 'Còn hàng'},
    {'id': 'VT-003', 'name': 'Khóa cửa', 'quantity': '03', 'status': 'Sắp hết'},
  ];


    static final List<Map<String, String>> contracts = [
    {
      'id': 'HD-KTX-2025-0312',
      'student': 'Nguyễn Văn An',
      'studentCode': 'SV20210001',
      'room': 'A301',
      'building': 'Tòa A',
      'startDate': '01/09/2025',
      'endDate': '31/05/2026',
      'monthlyFee': '600.000 đ',
      'deposit': '1.200.000 đ',
      'status': 'Đang hiệu lực',
    },
    {
      'id': 'HD-KTX-2025-0298',
      'student': 'Trần Thị Bích',
      'studentCode': 'SV20210045',
      'room': 'B204',
      'building': 'Tòa B',
      'startDate': '01/09/2025',
      'endDate': '28/02/2026',
      'monthlyFee': '600.000 đ',
      'deposit': '1.200.000 đ',
      'status': 'Sắp hết hạn',
    },
    {
      'id': 'HD-KTX-2024-0155',
      'student': 'Lê Văn Cường',
      'studentCode': 'SV20200112',
      'room': 'C102',
      'building': 'Tòa C',
      'startDate': '01/09/2024',
      'endDate': '31/05/2025',
      'monthlyFee': '550.000 đ',
      'deposit': '1.100.000 đ',
      'status': 'Đã thanh lý',
    },
    {
      'id': 'HD-KTX-2024-0102',
      'student': 'Phạm Thu Trang',
      'studentCode': 'SV20200088',
      'room': 'A205',
      'building': 'Tòa A',
      'startDate': '01/09/2024',
      'endDate': '31/05/2025',
      'monthlyFee': '550.000 đ',
      'deposit': '1.100.000 đ',
      'status': 'Hết hạn',
    },
    {
      'id': 'HD-KTX-2025-0401',
      'student': 'Hoàng Minh Đức',
      'studentCode': 'SV20220190',
      'room': 'D101',
      'building': 'Tòa D',
      'startDate': '01/10/2025',
      'endDate': '30/06/2026',
      'monthlyFee': '700.000 đ',
      'deposit': '1.400.000 đ',
      'status': 'Đang hiệu lực',
    },
  ];

  static final List<Map<String, String>> auditLogs = [
    {'action': 'Đăng nhập thành công', 'actor': 'Quản lý KTX', 'time': '20/10/2026 08:15'},
    {'action': 'Cập nhật trạng thái yêu cầu', 'actor': 'Kỹ thuật viên', 'time': '19/10/2026 16:40'},
    {'action': 'Rà soát quyền người dùng', 'actor': 'Quản trị viên', 'time': '19/10/2026 14:05'},
  ];

  static void addAudit(String action, String actor) {
    final now = DateTime.now();
    final date = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final time = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    auditLogs.insert(0, {'action': action, 'actor': actor, 'time': '$date $time'});
    if (auditLogs.length > 100) auditLogs.removeRange(100, auditLogs.length);
  }

  static String dateToday() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  static String nextId(String prefix) => '$prefix-${DateTime.now().microsecondsSinceEpoch % 1000000}';
}
