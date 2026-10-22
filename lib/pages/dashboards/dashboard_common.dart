import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class RoleWelcomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const RoleWelcomeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final showIcon = MediaQuery.sizeOf(context).width >= 560;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF142344), Color(0xFF1A3766), Color(0xFF2455A9)],
        ),
        borderRadius: BorderRadius.circular(23),
        boxShadow: const [
          BoxShadow(color: Color(0x1B244C91), blurRadius: 24, offset: Offset(0, 10)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: showIcon ? 20 : -45,
            top: -90,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(color: Colors.white.withOpacity(.045), shape: BoxShape.circle),
            ),
          ),
          Positioned(
            right: showIcon ? 95 : -25,
            bottom: -112,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(.08), width: 24), shape: BoxShape.circle),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(showIcon ? 25 : 21, 23, 22, 23),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(.11), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white.withOpacity(.08))),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.waving_hand_rounded, size: 13, color: Color(0xFFB7D1FF)),
                            SizedBox(width: 6),
                            Text('XIN CHÀO, CHÚC BẠN MỘT NGÀY TỐT LÀNH', style: TextStyle(color: Color(0xFFE2ECFF), fontSize: 8, letterSpacing: .45, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, height: 1.25, letterSpacing: -.4)),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 650),
                        child: Text(subtitle, style: const TextStyle(color: Color(0xFFD0DDF2), fontSize: 12, height: 1.6)),
                      ),
                    ],
                  ),
                ),
                if (showIcon) ...[
                  const SizedBox(width: 20),
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withOpacity(.17), Colors.white.withOpacity(.06)]),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withOpacity(.12)),
                    ),
                    child: Icon(icon, color: const Color(0xFFD6E5FF), size: 39),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoleStatItem {
  final String label;
  final String value;
  final String note;
  final IconData icon;
  final Color accent;
  final Color softColor;

  const RoleStatItem({
    required this.label,
    required this.value,
    required this.note,
    required this.icon,
    this.accent = AppColors.primary,
    this.softColor = AppColors.primarySoft,
  });
}

class RoleStatGrid extends StatelessWidget {
  final List<RoleStatItem> items;
  const RoleStatGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 960 ? 4 : constraints.maxWidth >= 520 ? 2 : 1;
        final ratio = count == 1 ? 1.9 : count == 2 ? 1.62 : 1.42;
        return GridView.count(
          crossAxisCount: count,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: ratio,
          children: items.map((item) => StatCard(
            label: item.label,
            value: item.value,
            note: item.note,
            icon: item.icon,
            accent: item.accent,
            softColor: item.softColor,
          )).toList(),
        );
      },
    );
  }
}

class RoleShortcutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;
  final Color softColor;

  const RoleShortcutCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.accent = AppColors.primary,
    this.softColor = AppColors.primarySoft,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: softColor, borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: accent, size: 22),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.text, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: AppColors.muted, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(color: const Color(0xFFF5F7FB), borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleShortcutGrid extends StatelessWidget {
  final List<Widget> children;
  const RoleShortcutGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 1100 ? 3 : constraints.maxWidth >= 680 ? 2 : 1;
        return GridView.count(
          crossAxisCount: count,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: count == 1 ? 3.25 : 2.55,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }
}

class RoleInfoLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  const RoleInfoLine({super.key, required this.icon, required this.title, required this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, size: 19, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.text)),
                const SizedBox(height: 4),
                Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, height: 1.45, color: AppColors.muted)),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
