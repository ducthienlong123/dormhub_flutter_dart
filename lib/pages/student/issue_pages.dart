import 'package:flutter/material.dart';

import '../../data/demo_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

/// Màn hình Báo sự cố & Theo dõi tiến độ xử lý dành cho Sinh viên
class StudentIssuePage extends StatefulWidget {
  final String email;
  final String userName;
  final ValueChanged<String> onNavigate;

  const StudentIssuePage({
    super.key,
    required this.email,
    required this.userName,
    required this.onNavigate,
  });

  @override
  State<StudentIssuePage> createState() => _StudentIssuePageState();
}

class _StudentIssuePageState extends State<StudentIssuePage> {
  String _selectedIssueType = 'Điện / Đèn';

  String get _defaultRoom => DemoStore.students.firstWhere(
        (student) => student['email']?.toLowerCase() == widget.email.toLowerCase(),
        orElse: () => {'room': ''},
      )['room'] ?? '';

  void _notice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ownRepairs = DemoStore.repairs
        .where((repair) => repair['email']?.toLowerCase() == widget.email.toLowerCase())
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Khối Báo sự cố
        SectionCard(
          title: 'Báo sự cố / Yêu cầu sửa chữa',
          subtitle: 'Gửi thông tin sự cố để đội ngũ kỹ thuật tiếp nhận và hỗ trợ.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RoleModuleHeading(
                icon: Icons.home_repair_service_outlined,
                title: 'Bạn đang gặp sự cố?',
                subtitle: 'Mô tả ngắn gọn tình trạng và vị trí để xử lý nhanh hơn.',
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ['Điện / Đèn', 'Nước', 'Điều hòa', 'Khóa cửa', 'Khác']
                    .map(_issueTypeChip)
                    .toList(),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _showCreateIssueDialog,
                icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                label: const Text('Tạo yêu cầu mới'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Khối Theo dõi danh sách sự cố đã gửi
        SectionCard(
          title: 'Theo dõi yêu cầu sửa chữa',
          subtitle: 'Tiến độ các yêu cầu do bạn gửi.',
          child: ownRepairs.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFBFE),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.build_circle_outlined, size: 36, color: AppColors.muted),
                      SizedBox(height: 8),
                      Text('Bạn chưa gửi yêu cầu sửa chữa nào.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                    ],
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        headingRowHeight: 44,
                        dataRowMinHeight: 50,
                        dataRowMaxHeight: 60,
                        columns: const [
                          DataColumn(label: Text('MÃ SỰ CỐ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted))),
                          DataColumn(label: Text('NỘI DUNG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted))),
                          DataColumn(label: Text('PHÒNG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted))),
                          DataColumn(label: Text('NGÀY GỬI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted))),
                          DataColumn(label: Text('TRẠNG THÁI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted))),
                        ],
                        rows: ownRepairs.map((repair) => DataRow(cells: [
                          DataCell(Text(repair['id'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
                          DataCell(Text(repair['title'] ?? '', style: const TextStyle(fontSize: 12))),
                          DataCell(Text(repair['room'] ?? '', style: const TextStyle(fontSize: 12))),
                          DataCell(Text(repair['date'] ?? '', style: const TextStyle(fontSize: 12))),
                          DataCell(StatusChip(label: repair['status'] ?? 'Mới')),
                        ])).toList(),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _issueTypeChip(String label) => ChoiceChip(
        avatar: const Icon(Icons.build_circle_outlined, size: 17, color: AppColors.primary),
        label: Text(label),
        selected: _selectedIssueType == label,
        onSelected: (_) => setState(() => _selectedIssueType = label),
        backgroundColor: const Color(0xFFF5F8FE),
        selectedColor: AppColors.primarySoft,
        side: const BorderSide(color: AppColors.border),
        labelStyle: const TextStyle(fontSize: 12, color: AppColors.text, fontWeight: FontWeight.w600),
      );

  Future<void> _showCreateIssueDialog() async {
    final roomController = TextEditingController(text: _defaultRoom);
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final values = await showDialog<List<String>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tạo yêu cầu sửa chữa'),
        content: SizedBox(
          width: 430,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedIssueType,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Loại sự cố'),
                  items: const ['Điện / Đèn', 'Nước', 'Điều hòa', 'Khóa cửa', 'Khác']
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedIssueType = value ?? _selectedIssueType),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: roomController,
                  decoration: const InputDecoration(labelText: 'Tòa / Phòng', hintText: 'Ví dụ: A-203'),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Vui lòng nhập vị trí' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Mô tả chi tiết', hintText: 'Mô tả tình trạng gặp phải'),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Vui lòng nhập mô tả' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Hủy')),
          FilledButton.icon(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              Navigator.pop(dialogContext, [_selectedIssueType, roomController.text.trim(), descriptionController.text.trim()]);
            },
            icon: const Icon(Icons.send_rounded, size: 17),
            label: const Text('Gửi yêu cầu'),
          ),
        ],
      ),
    );
    roomController.dispose();
    descriptionController.dispose();
    if (values == null || !mounted) return;

    setState(() {
      final issueId = DemoStore.nextId('SC');
      DemoStore.repairs.insert(0, {
        'id': issueId,
        'title': values[0],
        'description': values[2],
        'room': values[1],
        'student': widget.userName,
        'email': widget.email,
        'date': DemoStore.dateToday(),
        'status': 'Mới',
      });
    });
    DemoStore.addAudit('Tạo yêu cầu sửa chữa ${values[0]}', widget.userName);
    _notice('Đã gửi yêu cầu sửa chữa thành công!');
  }
}

/// Màn hình theo dõi sự cố (giữ lại để tương thích nếu cần)
class StudentRepairsPage extends StatelessWidget {
  final String email;
  final ValueChanged<String> onNavigate;

  const StudentRepairsPage({super.key, required this.email, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return StudentIssuePage(
      email: email,
      userName: 'Sinh viên',
      onNavigate: onNavigate,
    );
  }
}
