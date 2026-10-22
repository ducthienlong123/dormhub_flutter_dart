import '../../models/dorm_contract.dart';

/// Hợp đồng giao tiếp dữ liệu. Có thể thay implementation demo bằng REST API
/// hoặc repository dùng database mà không cần sửa giao diện StudentContractPage.
abstract interface class ContractRepository {
  Future<DormContract?> getCurrentContract(String studentEmail);
  Future<List<DormContract>> getContractHistory(String studentEmail);
  Future<DormContract> renewContract(String studentEmail, String contractId);
  Future<DormContract> terminateContract(String studentEmail, String contractId);
}

/// Nguồn dữ liệu demo hiện tại; dữ liệu chỉ tồn tại trong bộ nhớ ứng dụng.
class DemoContractRepository implements ContractRepository {
  DemoContractRepository._();

  static final DemoContractRepository instance = DemoContractRepository._();

  final Map<String, DormContract> _currentByEmail = {};
  final Map<String, List<DormContract>> _historyByEmail = {};

  DormContract _newDemoCurrentContract() => const DormContract(
        id: 'HĐ-KTX-2024-0312',
        room: 'Tòa A — A301',
        roomType: '4 người',
        startDate: '01/09/2024',
        endDate: '31/05/2025',
        monthlyFee: '600.000 đ',
        deposit: '1.200.000 đ',
        status: 'Đang hiệu lực',
        isCurrent: true,
      );

  List<DormContract> _newDemoHistory() => const [
        DormContract(
          id: 'HĐ-KTX-2023-0187',
          room: 'B205',
          roomType: '4 người',
          startDate: '09/2023',
          endDate: '05/2024',
          monthlyFee: '550.000 đ',
          deposit: '1.100.000 đ',
          status: 'Hết hạn',
        ),
        DormContract(
          id: 'HĐ-KTX-2022-0094',
          room: 'B205',
          roomType: '4 người',
          startDate: '09/2022',
          endDate: '05/2023',
          monthlyFee: '500.000 đ',
          deposit: '1.000.000 đ',
          status: 'Hết hạn',
        ),
      ];

  @override
  Future<DormContract?> getCurrentContract(String studentEmail) async {
    final key = studentEmail.trim().toLowerCase();
    return _currentByEmail.putIfAbsent(key, _newDemoCurrentContract);
  }

  @override
  Future<List<DormContract>> getContractHistory(String studentEmail) async {
    final key = studentEmail.trim().toLowerCase();
    return List.unmodifiable(_historyByEmail.putIfAbsent(key, _newDemoHistory));
  }

  @override
  Future<DormContract> renewContract(String studentEmail, String contractId) async {
    final key = studentEmail.trim().toLowerCase();
    final current = await getCurrentContract(studentEmail);
    if (current == null || current.id != contractId) {
      throw StateError('Không tìm thấy hợp đồng hiện tại để gia hạn.');
    }

    final endDate = DateTime.now().add(const Duration(days: 365));
    final newEndDate = '${endDate.day.toString().padLeft(2, '0')}/'
        '${endDate.month.toString().padLeft(2, '0')}/${endDate.year}';
    final renewed = current.copyWith(endDate: newEndDate, status: 'Đang hiệu lực');
    _currentByEmail[key] = renewed;
    return renewed;
  }

  @override
  Future<DormContract> terminateContract(String studentEmail, String contractId) async {
    final key = studentEmail.trim().toLowerCase();
    final current = await getCurrentContract(studentEmail);
    if (current == null || current.id != contractId) {
      throw StateError('Không tìm thấy hợp đồng hiện tại để chấm dứt.');
    }

    final terminated = current.copyWith(status: 'Đã chấm dứt');
    _currentByEmail[key] = terminated;
    return terminated;
  }
}
