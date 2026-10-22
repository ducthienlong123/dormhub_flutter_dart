/// Mô hình hợp đồng lưu trú độc lập với giao diện và nguồn dữ liệu.
/// Khi nối backend, ánh xạ JSON API vào model này.
class DormContract {
  final String id;
  final String room;
  final String roomType;
  final String startDate;
  final String endDate;
  final String monthlyFee;
  final String deposit;
  final String status;
  final bool isCurrent;

  const DormContract({
    required this.id,
    required this.room,
    required this.roomType,
    required this.startDate,
    required this.endDate,
    required this.monthlyFee,
    required this.deposit,
    required this.status,
    this.isCurrent = false,
  });

  String get period => '$startDate – $endDate';

  DormContract copyWith({
    String? id,
    String? room,
    String? roomType,
    String? startDate,
    String? endDate,
    String? monthlyFee,
    String? deposit,
    String? status,
    bool? isCurrent,
  }) {
    return DormContract(
      id: id ?? this.id,
      room: room ?? this.room,
      roomType: roomType ?? this.roomType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      deposit: deposit ?? this.deposit,
      status: status ?? this.status,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }
}
