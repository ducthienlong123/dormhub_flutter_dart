import 'package:flutter/material.dart';

import '../../data/demo_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'dashboard_common.dart';

class TechnicianDashboard extends StatelessWidget {
  final ValueChanged<String> onNavigate;
  const TechnicianDashboard({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final repairs = DemoStore.repairs;
    final newRepairs = repairs.where((item) => item['status'] == 'Mới' || item['status'] == 'Đã gán').length;
    final processingRepairs = repairs.where((item) => item['status'] == 'Đang xử lý').length;
    final completedRepairs = repairs.where((item) => item['status'] == 'Hoàn thành').length;
    final lowStock = DemoStore.inventory.where((item) => item['status'] == 'Sắp hết').length;
    final urgentRepairs = repairs.where((item) => item['status'] != 'Hoàn thành').take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RoleWelcomeCard(
          title: 'Không gian kỹ thuật',
          subtitle: 'Theo dõi sự cố mới, công việc bảo trì và tình trạng vật tư. Hãy ưu tiên những yêu cầu đang chờ xử lý.',
          icon: Icons.handyman_outlined,
        ),
        const SizedBox(height: 18),
        RoleStatGrid(items: [
          RoleStatItem(label: 'Sự cố cần nhận', value: '$newRepairs', note: 'Mới hoặc đã được gán', icon: Icons.notification_important_outlined, accent: AppColors.orange, softColor: AppColors.orangeSoft),
          RoleStatItem(label: 'Đang xử lý', value: '$processingRepairs', note: 'Chưa hoàn thành', icon: Icons.pending_actions_outlined, accent: AppColors.purple, softColor: AppColors.purpleSoft),
          RoleStatItem(label: 'Hoàn thành', value: '$completedRepairs', note: 'Trong danh sách hiện tại', icon: Icons.task_alt_rounded, accent: AppColors.green, softColor: AppColors.greenSoft),
          RoleStatItem(label: 'Vật tư sắp hết', value: '$lowStock', note: 'Cần kiểm tra tồn kho', icon: Icons.inventory_2_outlined),
        ]),
        const SizedBox(height: 20),
        SectionCard(
          title: 'Công việc ưu tiên',
          subtitle: 'Danh sách minh họa để theo dõi nhanh',
          action: TextButton(onPressed: () => onNavigate('Yêu cầu sửa chữa'), child: const Text('Xem tất cả')),
          child: Column(
            children: urgentRepairs.isEmpty
                ? [const Padding(padding: EdgeInsets.all(18), child: Text('Không còn yêu cầu tồn đọng.', style: TextStyle(color: AppColors.muted)))]
                : urgentRepairs.map((item) => Column(children: [
                    RoleInfoLine(
                      icon: Icons.home_repair_service_outlined,
                      title: '${item['id']} · ${item['title']}',
                      subtitle: 'Phòng ${item['room']} · ${item['student']}',
                      trailing: StatusChip(label: item['status'] ?? 'Chưa rõ'),
                    ),
                    if (item != urgentRepairs.last) const Divider(height: 1),
                  ])).toList(),
          ),
        ),
        const SizedBox(height: 18),
        SectionCard(
          title: 'Công cụ kỹ thuật',
          subtitle: 'Chuyển nhanh đến mô-đun công việc',
          child: RoleShortcutGrid(children: [
            RoleShortcutCard(title: 'Yêu cầu sửa chữa', subtitle: 'Tiếp nhận và cập nhật trạng thái', icon: Icons.home_repair_service_outlined, onTap: () => onNavigate('Yêu cầu sửa chữa')),
            RoleShortcutCard(title: 'Lịch bảo trì', subtitle: 'Xem lịch kiểm tra thiết bị', icon: Icons.calendar_month_outlined, accent: AppColors.green, softColor: AppColors.greenSoft, onTap: () => onNavigate('Lịch bảo trì')),
            RoleShortcutCard(title: 'Quản lý vật tư', subtitle: 'Theo dõi tồn kho linh kiện', icon: Icons.inventory_2_outlined, accent: AppColors.orange, softColor: AppColors.orangeSoft, onTap: () => onNavigate('Quản lý vật tư')),
          ]),
        ),
      ],
    );
  }
}
