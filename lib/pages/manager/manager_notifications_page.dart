import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ManagerNotificationsPageWidget extends StatefulWidget {
  const ManagerNotificationsPageWidget({super.key});

  @override
  State<ManagerNotificationsPageWidget> createState() => _ManagerNotificationsPageWidgetState();
}

class _ManagerNotificationsPageWidgetState extends State<ManagerNotificationsPageWidget> {
  List<Map<String, String>> notifications = [
    {
      'id': '1',
      'title': 'Kiểm tra PCCC tòa A',
      'status': 'Đã gửi',
      'content': 'Ban quản lý sẽ kiểm tra hệ thống PCCC tòa A vào lúc 08:00 ngày 15/11.',
      'target': 'Sinh viên tòa A',
      'createdAt': '10/11/2024',
    },
    {
      'id': '2',
      'title': 'Nhắc thanh toán hóa đơn tháng 11',
      'status': 'Bản nháp',
      'content': 'Sinh viên vui lòng hoàn tất thanh toán hóa đơn trước ngày 15/12.',
      'target': 'Sinh viên chưa thanh toán',
      'createdAt': '11/11/2024',
    },
  ];

  int get totalNotifications => notifications.length;
  int get sentNotifications => notifications.where((n) => n['status'] == 'Đã gửi').length;
  int get draftNotifications => notifications.where((n) => n['status'] == 'Bản nháp').length;

  void _showNotificationFormDialog({Map<String, String>? notification}) {
    final isEditing = notification != null;
    final titleController = TextEditingController(text: isEditing ? notification['title'] : '');
    final contentController = TextEditingController(text: isEditing ? notification['content'] : '');
    final targetController = TextEditingController(text: isEditing ? notification['target'] : 'Sinh viên tòa A');
    String status = isEditing ? notification['status']! : 'Bản nháp';

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            isEditing ? 'Sửa thông báo' : 'Tạo thông báo mới',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tiêu đề', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tiêu đề thông báo...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Đối tượng nhận', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: targetController,
                    decoration: InputDecoration(
                      hintText: 'Ví dụ: Sinh viên tòa A, Sinh viên chưa thanh toán...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Nội dung', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: contentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Nhập nội dung thông báo...',
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Text('Trạng thái: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text('Bản nháp'),
                        selected: status == 'Bản nháp',
                        onSelected: (selected) {
                          if (selected) setDialogState(() => status = 'Bản nháp');
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Đã gửi'),
                        selected: status == 'Đã gửi',
                        onSelected: (selected) {
                          if (selected) setDialogState(() => status = 'Đã gửi');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1D61F2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isEmpty) return;
                final nowStr = '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}';

                setState(() {
                  if (isEditing) {
                    notification['title'] = title;
                    notification['content'] = contentController.text.trim();
                    notification['target'] = targetController.text.trim();
                    notification['status'] = status;
                  } else {
                    notifications.insert(0, {
                      'id': '${DateTime.now().millisecondsSinceEpoch}',
                      'title': title,
                      'content': contentController.text.trim(),
                      'target': targetController.text.trim(),
                      'status': status,
                      'createdAt': nowStr,
                    });
                  }
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEditing ? 'Đã cập nhật thông báo thành công!' : 'Đã lưu thông báo mới!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(isEditing ? 'Cập nhật' : 'Lưu thông báo'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendNow(Map<String, String> item) {
    setState(() {
      item['status'] = 'Đã gửi';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã gửi thông báo "${item['title']}" tới sinh viên!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteNotification(Map<String, String> item) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('Bạn có chắc chắn muốn xóa thông báo "${item['title']}" không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              setState(() {
                notifications.remove(item);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa thông báo thành công!'), behavior: SnackBarBehavior.floating),
              );
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quản lý thông báo',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.text),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1D61F2),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _showNotificationFormDialog(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tạo thông báo', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 3 KPI Cards
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;
            return GridView.count(
              crossAxisCount: isMobile ? 1 : 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isMobile ? 2.5 : 2.8,
              children: [
                _kpiCard(
                  title: 'Tổng thông báo',
                  value: '$totalNotifications',
                  badgeText: 'TB',
                  badgeBg: const Color(0xFFEEF2FF),
                  badgeColor: const Color(0xFF4F46E5),
                ),
                _kpiCard(
                  title: 'Đã gửi',
                  value: '$sentNotifications',
                  badgeText: 'ĐG',
                  badgeBg: const Color(0xFFE6F4EA),
                  badgeColor: const Color(0xFF137333),
                ),
                _kpiCard(
                  title: 'Bản nháp',
                  value: '$draftNotifications',
                  badgeText: 'BN',
                  badgeBg: const Color(0xFFFEF3D6),
                  badgeColor: const Color(0xFFB45309),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        // List of Notifications
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = notifications[index];
            final isSent = item['status'] == 'Đã gửi';

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(color: Color(0x040D2148), blurRadius: 10, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Status + Action Buttons
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _statusChip(item['status']!),
                      const Spacer(),
                      // Actions: Sửa, (Gửi ngay if draft), Xóa
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          minimumSize: const Size(0, 34),
                        ),
                        onPressed: () => _showNotificationFormDialog(notification: item),
                        child: const Text(
                          'Sửa',
                          style: TextStyle(fontSize: 12, color: AppColors.text, fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (!isSent) ...[
                        const SizedBox(width: 8),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF1D61F2),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            minimumSize: const Size(0, 34),
                          ),
                          onPressed: () => _sendNow(item),
                          child: const Text(
                            'Gửi ngay',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFFEF2F2),
                          side: const BorderSide(color: Color(0xFFFEE2E2)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          minimumSize: const Size(0, 34),
                        ),
                        onPressed: () => _deleteNotification(item),
                        child: const Text(
                          'Xóa',
                          style: TextStyle(fontSize: 12, color: Color(0xFFEF4444), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['content']!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        'Đối tượng: ${item['target']}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Ngày tạo: ${item['createdAt']}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _kpiCard({
    required String title,
    required String value,
    required String badgeText,
    required Color badgeBg,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x040D2148), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.text),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  badgeText,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: badgeColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color bg = const Color(0xFFE6F4EA);
    Color text = const Color(0xFF137333);

    if (status == 'Bản nháp') {
      bg = const Color(0xFFFEF3D6);
      text = const Color(0xFFB45309);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: text),
      ),
    );
  }
}
