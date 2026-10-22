import 'package:flutter/material.dart';

import '../../data/demo_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'dashboard_common.dart';

class AdminDashboard extends StatelessWidget {
  final ValueChanged<String> onNavigate;
  const AdminDashboard({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final totalAccounts = DemoStore.accounts.length;
    final activeAccounts = DemoStore.accounts.where((account) => (account['status'] ?? 'Đang hoạt động') == 'Đang hoạt động').length;
    final lockedAccounts = totalAccounts - activeAccounts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RoleWelcomeCard(
          title: 'Trung tâm Quản trị Hệ thống DormHub',
          subtitle: 'Quản lý tài khoản, thiết lập phân quyền, cấu hình tham số KTX và giám sát nhật ký hoạt động.',
          icon: Icons.admin_panel_settings_outlined,
        ),
        const SizedBox(height: 18),
        RoleStatGrid(items: [
          RoleStatItem(label: 'Tổng số tài khoản', value: '$totalAccounts', note: 'Toàn hệ thống', icon: Icons.people_alt_outlined),
          RoleStatItem(label: 'Đang hoạt động', value: '$activeAccounts', note: 'Được phép truy cập', icon: Icons.verified_user_outlined, accent: AppColors.green, softColor: AppColors.greenSoft),
          const RoleStatItem(label: 'Nhóm quyền', value: '04 nhóm', note: 'Sinh viên, Quản lý, KT, Admin', icon: Icons.security_outlined, accent: AppColors.purple, softColor: AppColors.purpleSoft),
          RoleStatItem(label: 'Tài khoản bị khóa', value: '$lockedAccounts', note: 'Cần rà soát an toàn', icon: Icons.lock_person_outlined, accent: AppColors.orange, softColor: AppColors.orangeSoft),
        ]),
        const SizedBox(height: 20),
        SectionCard(
          title: 'Lối tắt Quản trị',
          subtitle: 'Truy cập nhanh các phân hệ quản trị hệ thống',
          child: RoleShortcutGrid(children: [
            RoleShortcutCard(title: 'Quản lý tài khoản', subtitle: 'Tạo, sửa & khóa tài khoản', icon: Icons.manage_accounts_outlined, onTap: () => onNavigate('Quản lý tài khoản')),
            RoleShortcutCard(title: 'Phân quyền & Vai trò', subtitle: 'Phân quyền CRUD chi tiết', icon: Icons.admin_panel_settings_outlined, accent: AppColors.purple, softColor: AppColors.purpleSoft, onTap: () => onNavigate('Phân quyền')),
            RoleShortcutCard(title: 'Cấu hình hệ thống', subtitle: 'Đơn giá & Tham số KTX', icon: Icons.settings_outlined, accent: AppColors.green, softColor: AppColors.greenSoft, onTap: () => onNavigate('Cấu hình hệ thống')),
            RoleShortcutCard(title: 'Nhật ký (Audit Logs)', subtitle: 'Truy vết lịch sử thao tác', icon: Icons.history_edu_outlined, accent: AppColors.orange, softColor: AppColors.orangeSoft, onTap: () => onNavigate('Nhật ký hệ thống')),
          ]),
        ),
        const SizedBox(height: 18),
        SectionCard(
          title: 'Trạng thái Hạ tầng & Máy chủ',
          subtitle: 'Kiểm tra tình trạng các dịch vụ cốt lõi',
          child: const Column(
            children: [
              RoleInfoLine(icon: Icons.dns_outlined, title: 'Máy chủ Cơ sở dữ liệu', subtitle: 'Kết nối ổn định · Chế độ Demo Cục bộ', trailing: StatusChip(label: 'Đang chạy')),
              Divider(height: 1),
              RoleInfoLine(icon: Icons.mark_email_read_outlined, title: 'Cổng thông báo Email (SMTP)', subtitle: 'Gửi thông báo tự động tới sinh viên', trailing: StatusChip(label: 'Sẵn sàng')),
              Divider(height: 1),
              RoleInfoLine(icon: Icons.shield_outlined, title: 'Hệ thống Phân quyền (RBAC)', subtitle: 'Áp dụng bảo mật phân quyền 4 cấp', trailing: StatusChip(label: 'Bảo mật')),
            ],
          ),
        ),
      ],
    );
  }
}
