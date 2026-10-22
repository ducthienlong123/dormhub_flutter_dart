import 'package:flutter/material.dart';

import '../../data/demo_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class StudentRoomManagerPageWidget extends StatefulWidget {
  const StudentRoomManagerPageWidget({super.key});

  @override
  State<StudentRoomManagerPageWidget> createState() => _StudentRoomManagerPageWidgetState();
}

class _StudentRoomManagerPageWidgetState extends State<StudentRoomManagerPageWidget> {
  int activeTab = 1; // 0: Sinh viên, 1: Tòa nhà & phòng

  final List<Map<String, String>> rooms = [
    {'room': 'A101', 'building': 'Tòa A', 'capacity': '4 người', 'occupied': '4', 'type': '4 người — 600.000đ', 'status': 'Đầy'},
    {'room': 'A102', 'building': 'Tòa A', 'capacity': '4 người', 'occupied': '3', 'type': '4 người — 600.000đ', 'status': '1 chỗ trống'},
    {'room': 'B201', 'building': 'Tòa B', 'capacity': '6 người', 'occupied': '0', 'type': '6 người — 450.000đ', 'status': 'Trống'},
    {'room': 'C304', 'building': 'Tòa C', 'capacity': '8 người', 'occupied': '7', 'type': '8 người — 350.000đ', 'status': '1 chỗ trống'},
  ];

  void _showAddStudentDialog() {
    final idController = TextEditingController(text: 'SV${DateTime.now().year}${(DemoStore.students.length + 1).toString().padLeft(3, '0')}');
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final roomController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Thêm sinh viên mới', style: TextStyle(fontWeight: FontWeight.w800)),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(labelText: 'Mã sinh viên'),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Vui lòng nhập mã sinh viên.' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Họ và tên'),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Vui lòng nhập họ tên.' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Vui lòng nhập email.';
                      if (!val.contains('@')) return 'Email không hợp lệ.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: roomController,
                    decoration: const InputDecoration(labelText: 'Số phòng (ví dụ: A101)'),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Vui lòng nhập số phòng.' : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Hủy')),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(() {
                DemoStore.students.add({
                  'id': idController.text.trim(),
                  'name': nameController.text.trim(),
                  'email': emailController.text.trim(),
                  'room': roomController.text.trim(),
                  'status': 'Chờ nhận phòng',
                });
              });
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã thêm sinh viên ${nameController.text.trim()} thành công!'), behavior: SnackBarBehavior.floating),
              );
            },
            child: const Text('Thêm mới'),
          ),
        ],
      ),
    );
  }

  void _showAddRoomDialog() {
    final roomController = TextEditingController();
    final buildingController = TextEditingController(text: 'Tòa A');
    final capacityController = TextEditingController(text: '4 người');
    final typeController = TextEditingController(text: '4 người — 600.000đ');
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Thêm phòng mới', style: TextStyle(fontWeight: FontWeight.w800)),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: roomController,
                    decoration: const InputDecoration(labelText: 'Số phòng (ví dụ: A103)'),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Vui lòng nhập số phòng.' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: buildingController.text,
                    decoration: const InputDecoration(labelText: 'Tòa nhà'),
                    items: const [
                      DropdownMenuItem(value: 'Tòa A', child: Text('Tòa A')),
                      DropdownMenuItem(value: 'Tòa B', child: Text('Tòa B')),
                      DropdownMenuItem(value: 'Tòa C', child: Text('Tòa C')),
                      DropdownMenuItem(value: 'Tòa D', child: Text('Tòa D')),
                    ],
                    onChanged: (val) {
                      if (val != null) buildingController.text = val;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: capacityController,
                    decoration: const InputDecoration(labelText: 'Sức chứa (ví dụ: 4 người)'),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Vui lòng nhập sức chứa.' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: typeController,
                    decoration: const InputDecoration(labelText: 'Loại phòng & Đơn giá'),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Vui lòng nhập loại phòng.' : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Hủy')),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(() {
                rooms.add({
                  'room': roomController.text.trim(),
                  'building': buildingController.text,
                  'capacity': capacityController.text.trim(),
                  'occupied': '0',
                  'type': typeController.text.trim(),
                  'status': 'Trống',
                });
              });
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã thêm phòng ${roomController.text.trim()} thành công!'), behavior: SnackBarBehavior.floating),
              );
            },
            child: const Text('Thêm mới'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final students = DemoStore.students;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => setState(() => activeTab = 0),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: activeTab == 0 ? const Color(0xFF1D61F2) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Sinh viên',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: activeTab == 0 ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () => setState(() => activeTab = 1),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: activeTab == 1 ? const Color(0xFF1D61F2) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Tòa nhà & phòng',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: activeTab == 1 ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (activeTab == 0) ...[
          SectionCard(
            title: 'Danh sách sinh viên',
            subtitle: 'Thông tin lưu trú và liên hệ',
            action: FilledButton.icon(
              onPressed: _showAddStudentDialog,
              icon: const Icon(Icons.add, size: 17),
              label: const Text('Thêm sinh viên'),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 45,
                dataRowMinHeight: 52,
                dataRowMaxHeight: 62,
                columns: const [
                  DataColumn(label: Text('MÃ SV', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.muted))),
                  DataColumn(label: Text('HỌ TÊN', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.muted))),
                  DataColumn(label: Text('EMAIL', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.muted))),
                  DataColumn(label: Text('PHÒNG', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.muted))),
                  DataColumn(label: Text('TRẠNG THÁI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.muted))),
                ],
                rows: students.map((s) => DataRow(cells: [
                  DataCell(Text(s['id'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
                  DataCell(Text(s['name'] ?? '', style: const TextStyle(fontSize: 12))),
                  DataCell(Text(s['email'] ?? '', style: const TextStyle(fontSize: 12))),
                  DataCell(Text(s['room'] ?? '', style: const TextStyle(fontSize: 12))),
                  DataCell(StatusChip(label: s['status'] ?? '')),
                ])).toList(),
              ),
            ),
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tòa nhà & phòng',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.text),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1D61F2),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _showAddRoomDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('+ Thêm phòng', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 720;
              return GridView.count(
                crossAxisCount: isMobile ? 2 : 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isMobile ? 1.35 : 1.55,
                children: [
                  _buildingCard('Tòa A', 'Nam', 52, 60, '8 phòng còn trống', const Color(0xFF1D61F2)),
                  _buildingCard('Tòa B', 'Nữ', 47, 50, '3 phòng còn trống', const Color(0xFFEC4899)),
                  _buildingCard('Tòa C', 'Hỗn hợp', 68, 80, '12 phòng còn trống', const Color(0xFF10B981)),
                  _buildingCard('Tòa D', 'Nam', 43, 58, '15 phòng còn trống', const Color(0xFFF97316)),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowHeight: 48,
                    dataRowMinHeight: 60,
                    dataRowMaxHeight: 70,
                    horizontalMargin: 20,
                    columnSpacing: 32,
                    headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFBFC)),
                    columns: const [
                      DataColumn(label: Text('PHÒNG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                      DataColumn(label: Text('TÒA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                      DataColumn(label: Text('SỨC CHÚA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                      DataColumn(label: Text('ĐANG Ở', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                      DataColumn(label: Text('LOẠI PHÒNG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                      DataColumn(label: Text('TÌNH TRẠNG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    ],
                    rows: rooms.map((r) => DataRow(cells: [
                      DataCell(Text(r['room']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text))),
                      DataCell(Text(r['building']!, style: const TextStyle(fontSize: 13, color: AppColors.text))),
                      DataCell(Text(r['capacity']!, style: const TextStyle(fontSize: 13, color: AppColors.text))),
                      DataCell(Text(r['occupied']!, style: const TextStyle(fontSize: 13, color: AppColors.text))),
                      DataCell(Text(r['type']!, style: const TextStyle(fontSize: 13, color: AppColors.text))),
                      DataCell(_roomStatusChip(r['status']!)),
                    ])).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildingCard(String name, String tag, int current, int total, String emptyCount, Color accentColor) {
    final progress = (current / total).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x040D2148), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.text)),
              Text(tag, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '$current ', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: accentColor)),
                TextSpan(text: '/$total', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFF1F5F9),
              color: accentColor,
            ),
          ),
          Text(emptyCount, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _roomStatusChip(String status) {
    Color bg = const Color(0xFFF1F5F9);
    Color text = const Color(0xFF64748B);

    if (status == 'Đầy') {
      bg = const Color(0xFFFEE2E2);
      text = const Color(0xFFDC2626);
    } else if (status.contains('chỗ trống')) {
      bg = const Color(0xFFFEF3C7);
      text = const Color(0xFFD97706);
    } else if (status == 'Trống') {
      bg = const Color(0xFFDCFCE7);
      text = const Color(0xFF16A34A);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: text),
      ),
    );
  }
}
