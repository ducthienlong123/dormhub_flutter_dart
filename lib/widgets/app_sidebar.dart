import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'common_widgets.dart';

class AppSidebar extends StatelessWidget {
  final String role;
  final String currentPage;
  final List<String> menu;
  final ValueChanged<String> onSelect;

  const AppSidebar({
    super.key,
    required this.role,
    required this.currentPage,
    required this.menu,
    required this.onSelect,
  });

  IconData _iconFor(String item) {
    if (item.contains('Dashboard') || item.contains('Trang chủ')) return Icons.grid_view_rounded;
    if (item.contains('đơn') || item.contains('Đăng ký')) return Icons.assignment_turned_in_outlined;
    if (item.contains('Sinh viên') || item.contains('tài khoản')) return Icons.people_alt_outlined;
    if (item.contains('Phòng')) return Icons.meeting_room_outlined;
    if (item.contains('Hóa đơn') || item.contains('Điện nước')) return Icons.receipt_long_outlined;
    if (item.contains('sửa chữa') || item.contains('Sửa chữa') || item.contains('sự cố')) return Icons.handyman_outlined;
    if (item.contains('Hồ sơ')) return Icons.person_outline_rounded;
    if (item.contains('Báo cáo')) return Icons.query_stats_rounded;
    if (item.contains('Thông báo')) return Icons.notifications_none_rounded;
    if (item.contains('Hợp đồng')) return Icons.description_outlined;
    if (item.contains('Lịch bảo trì')) return Icons.calendar_month_outlined;
    if (item.contains('vật tư')) return Icons.inventory_2_outlined;
    if (item.contains('Phân quyền')) return Icons.admin_panel_settings_outlined;
    if (item.contains('Nhật ký')) return Icons.receipt_long_outlined;
    if (item.contains('Vi phạm')) return Icons.gpp_bad_outlined;
    return Icons.settings_outlined;
  }

  String get _sectionTitle {
    switch (role) {
      case 'Sinh viên':
        return 'KHÔNG GIAN SINH VIÊN';
      case 'Kỹ thuật viên':
        return 'KHÔNG GIAN KỸ THUẬT';
      case 'Quản trị viên':
        return 'QUẢN TRỊ HỆ THỐNG';
      default:
        return 'QUẢN LÝ KÝ TÚC XÁ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, Color(0xFF15284A), Color(0xFF101C35)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -75,
            right: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(.12), shape: BoxShape.circle),
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 25, 18, 28),
                  child: Row(
                    children: [
                      const DormHubLogo(size: 43, dark: true),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DormHub', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900, letterSpacing: -.45)),
                            SizedBox(height: 4),
                            Text('DORMITORY MANAGEMENT', style: TextStyle(color: Color(0xFF9EACC6), fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 1.15)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 16, 11),
                  child: Row(
                    children: [
                      Container(width: 5, height: 5, decoration: const BoxDecoration(color: Color(0xFF6EA0FF), shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_sectionTitle, style: TextStyle(color: Colors.white.withOpacity(.53), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.0))),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 3, 12, 12),
                    itemCount: menu.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 5),
                    itemBuilder: (context, index) {
                      final item = menu[index];
                      final selected = currentPage == item;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 170),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFF356AE6) : Colors.transparent,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: selected ? Colors.white.withOpacity(.12) : Colors.transparent),
                          boxShadow: selected
                              ? const [BoxShadow(color: Color(0x26356AE6), blurRadius: 14, offset: Offset(0, 5))]
                              : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(13),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(13),
                            onTap: () => onSelect(item),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(_iconFor(item), color: selected ? Colors.white : const Color(0xFFACBAD0), size: 19),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(item, maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: selected ? Colors.white : const Color(0xFFD0D8E6), fontSize: 12, fontWeight: selected ? FontWeight.w800 : FontWeight.w500))),
                                  if (selected) ...[
                                    const SizedBox(width: 4),
                                    const Icon(Icons.chevron_right_rounded, size: 17, color: Colors.white70),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.065),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(.09)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(color: const Color(0xFF2D4268), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.person_outline_rounded, size: 20, color: Colors.white),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ĐANG ĐĂNG NHẬP', style: TextStyle(color: Color(0xFF91A1BC), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: .65)),
                            const SizedBox(height: 5),
                            Text(role, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF70C6A0)),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(22, 0, 20, 18),
                  child: Text('DormHub  ·  Bản demo 1.3', style: TextStyle(color: Color(0xFF7E8BA4), fontSize: 10)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
