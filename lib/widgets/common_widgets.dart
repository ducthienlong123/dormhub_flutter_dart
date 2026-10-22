import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DormHubLogo extends StatelessWidget {
  final double size;
  final bool dark;

  const DormHubLogo({super.key, this.size = 42, this.dark = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: dark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6EA0FF), Color(0xFF356AE6)],
              )
            : null,
        color: dark ? null : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(size * .29),
        boxShadow: dark
            ? [BoxShadow(color: AppColors.primary.withOpacity(.22), blurRadius: 16, offset: const Offset(0, 6))]
            : null,
      ),
      child: Icon(
        Icons.apartment_rounded,
        size: size * .57,
        color: dark ? Colors.white : AppColors.primary,
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.action,
    this.padding = const EdgeInsets.all(22),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x060D2148), blurRadius: 22, offset: Offset(0, 7)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: subtitle == null ? 23 : 39,
                margin: const EdgeInsets.only(right: 12, top: 1),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -.15, color: AppColors.text)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 5),
                      Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.muted, height: 1.45)),
                    ],
                  ],
                ),
              ),
              if (action != null) const SizedBox(width: 10),
              if (action != null) action!,
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String note;
  final IconData icon;
  final Color accent;
  final Color softColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.note,
    required this.icon,
    this.accent = AppColors.primary,
    this.softColor = AppColors.primarySoft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x050D2148), blurRadius: 20, offset: Offset(0, 6)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -34,
            bottom: -45,
            child: Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(color: softColor.withOpacity(.55), shape: BoxShape.circle),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(top: 5, right: 6),
                    child: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.3, fontWeight: FontWeight.w600)),
                  )),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(color: softColor, borderRadius: BorderRadius.circular(14)),
                    child: Icon(icon, color: accent, size: 21),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 27, height: 1.05, fontWeight: FontWeight.w800, letterSpacing: -.8, color: AppColors.text)),
              const SizedBox(height: 9),
              Row(
                children: [
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
                  const SizedBox(width: 7),
                  Expanded(child: Text(note, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, height: 1.35, color: AppColors.muted))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  const StatusChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final normalized = label.toLowerCase();
    Color foreground = AppColors.muted;
    Color background = const Color(0xFFF0F3F8);

    if (normalized.contains('đã duyệt') ||
        normalized.contains('đang ở') ||
        normalized.contains('đã thanh toán') ||
        normalized.contains('hoàn thành') ||
        normalized.contains('đã xử lý') ||
        normalized.contains('đang hoạt động')) {
      foreground = AppColors.green;
      background = AppColors.greenSoft;
    } else if (normalized.contains('chờ') ||
        normalized.contains('mới') ||
        normalized.contains('đã gán') ||
        normalized.contains('đã nhắc nhở') ||
        normalized.contains('sắp hết') ||
        normalized.contains('demo')) {
      foreground = AppColors.orange;
      background = AppColors.orangeSoft;
    } else if (normalized.contains('từ chối') ||
        normalized.contains('chưa thanh toán') ||
        normalized.contains('đã khóa')) {
      foreground = AppColors.red;
      background = AppColors.redSoft;
    } else if (normalized.contains('đang xử lý')) {
      foreground = AppColors.purple;
      background = AppColors.purpleSoft;
    } else if (normalized.contains('chưa cấu hình')) {
      foreground = AppColors.muted;
      background = const Color(0xFFF0F3F8);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(30)),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: foreground, fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }
}

class PageIntro extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;

  const PageIntro({super.key, required this.title, required this.subtitle, this.action});

  IconData get _icon {
    final value = title.toLowerCase();
    if (value.contains('dashboard') || value.contains('trang chủ')) return Icons.grid_view_rounded;
    if (value.contains('đăng ký') || value.contains('duyệt đơn')) return Icons.assignment_outlined;
    if (value.contains('sinh viên') || value.contains('hồ sơ')) return Icons.people_alt_outlined;
    if (value.contains('phòng')) return Icons.meeting_room_outlined;
    if (value.contains('hóa đơn') || value.contains('điện nước')) return Icons.receipt_long_outlined;
    if (value.contains('sự cố') || value.contains('sửa chữa')) return Icons.handyman_outlined;
    if (value.contains('tài khoản') || value.contains('phân quyền')) return Icons.admin_panel_settings_outlined;
    if (value.contains('báo cáo')) return Icons.query_stats_rounded;
    if (value.contains('thông báo')) return Icons.notifications_none_rounded;
    if (value.contains('bảo trì')) return Icons.calendar_month_outlined;
    if (value.contains('vật tư')) return Icons.inventory_2_outlined;
    return Icons.dashboard_customize_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 540;
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: compact ? 42 : 48,
            height: compact ? 42 : 48,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.border)),
            child: Icon(_icon, color: AppColors.primary, size: compact ? 20 : 23),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: compact ? 21 : 25, height: 1.15, fontWeight: FontWeight.w800, letterSpacing: -.6, color: AppColors.text)),
                const SizedBox(height: 6),
                Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted, height: 1.4)),
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 10),
            action!,
          ],
        ],
      ),
    );
  }
}


class RoleModuleHeading extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const RoleModuleHeading({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
