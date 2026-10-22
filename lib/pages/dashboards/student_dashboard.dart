import 'package:flutter/material.dart';

import '../../data/demo_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'dashboard_common.dart';

class StudentDashboard extends StatelessWidget {
  final String email;
  final ValueChanged<String> onNavigate;
  const StudentDashboard({super.key, required this.email, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final student = DemoStore.students.firstWhere(
      (item) => item['email']?.toLowerCase() == email.toLowerCase(),
      orElse: () => {'room': 'Chưa phân', 'status': 'Chờ nhận phòng'},
    );
    final ownBills = DemoStore.bills.where((item) => item['email']?.toLowerCase() == email.toLowerCase()).toList();
    final unpaidBills = ownBills.where((item) => item['status'] == 'Chưa thanh toán').length;
    final ownRepairs = DemoStore.repairs.where((item) => item['email']?.toLowerCase() == email.toLowerCase()).toList();
    final openRepairs = ownRepairs.where((item) => item['status'] != 'Hoàn thành').length;
    final ownApplications = DemoStore.applications.where((item) => item['email']?.toLowerCase() == email.toLowerCase()).toList();
    final stayStatus = ownApplications.isNotEmpty ? (ownApplications.first['status'] ?? student['status'] ?? 'Chưa cập nhật') : (student['status'] ?? 'Chưa cập nhật');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoleWelcomeCard(
          title: 'Xin chào, sinh viên!',
          subtitle: 'Xem thông tin phòng ở, hóa đơn và yêu cầu hỗ trợ của bạn tại một nơi. Tài khoản: $email',
          icon: Icons.school_outlined,
        ),
        const SizedBox(height: 18),
        RoleStatGrid(items: [
          RoleStatItem(label: 'Phòng hiện tại', value: student['room'] ?? 'Chưa phân', note: student['room'] == 'Chưa phân' ? 'Chưa được xếp phòng' : 'Thông tin lưu trú', icon: Icons.meeting_room_outlined),
          RoleStatItem(label: 'Hóa đơn cần trả', value: '$unpaidBills', note: 'Khoản chưa thanh toán', icon: Icons.receipt_long_outlined, accent: AppColors.orange, softColor: AppColors.orangeSoft),
          RoleStatItem(label: 'Yêu cầu hỗ trợ', value: '$openRepairs', note: 'Chưa hoàn thành', icon: Icons.handyman_outlined, accent: AppColors.purple, softColor: AppColors.purpleSoft),
          RoleStatItem(label: 'Hồ sơ lưu trú', value: stayStatus, note: 'Trạng thái đơn gần nhất', icon: Icons.verified_outlined, accent: AppColors.green, softColor: AppColors.greenSoft),
        ]),
        const SizedBox(height: 20),
        SectionCard(
          title: 'Truy cập nhanh',
          subtitle: 'Các chức năng dành cho sinh viên',
          child: RoleShortcutGrid(children: [
            RoleShortcutCard(title: 'Đăng ký phòng', subtitle: 'Xem và gửi yêu cầu lưu trú', icon: Icons.add_home_work_outlined, onTap: () => onNavigate('Đăng ký phòng')),
            RoleShortcutCard(title: 'Hóa đơn & thanh toán', subtitle: 'Theo dõi khoản phí', icon: Icons.payments_outlined, accent: AppColors.orange, softColor: AppColors.orangeSoft, onTap: () => onNavigate('Hóa đơn & thanh toán')),
            RoleShortcutCard(title: 'Báo sự cố', subtitle: 'Gửi yêu cầu sửa chữa', icon: Icons.home_repair_service_outlined, accent: AppColors.purple, softColor: AppColors.purpleSoft, onTap: () => onNavigate('Báo sự cố / Sửa chữa')),
            RoleShortcutCard(title: 'Hồ sơ cá nhân', subtitle: 'Xem thông tin tài khoản', icon: Icons.person_outline_rounded, accent: AppColors.green, softColor: AppColors.greenSoft, onTap: () => onNavigate('Hồ sơ cá nhân')),
          ]),
        ),
        const SizedBox(height: 18),
        SectionCard(
          title: 'Nhắc nhở',
          subtitle: 'Thông tin cần chú ý',
          child: const Column(
            children: [
              RoleInfoLine(icon: Icons.event_available_outlined, title: 'Phí lưu trú tháng 10', subtitle: 'Vui lòng kiểm tra hạn thanh toán trên hóa đơn.', trailing: StatusChip(label: 'Chưa thanh toán')),
              Divider(height: 1),
              RoleInfoLine(icon: Icons.handyman_outlined, title: 'Vòi nước phòng A-203', subtitle: 'Yêu cầu sửa chữa đã được tiếp nhận.', trailing: StatusChip(label: 'Đang xử lý')),
            ],
          ),
        ),
      ],
    );
  }
}
