import 'package:flutter/material.dart';

import '../../data/demo_store.dart';
import '../../theme/app_theme.dart';

class ManagerContractPageWidget extends StatefulWidget {
  const ManagerContractPageWidget({super.key});

  @override
  State<ManagerContractPageWidget> createState() => _ManagerContractPageWidgetState();
}

class _ManagerContractPageWidgetState extends State<ManagerContractPageWidget> {
  String searchKeyword = '';
  String selectedStatus = 'Tất cả trạng thái';

  @override
  Widget build(BuildContext context) {
    final contracts = DemoStore.contracts;
    final totalContracts = contracts.length;
    final activeContracts = contracts.where((c) => c['status'] == 'Đang hiệu lực').length;
    final expiringContracts = contracts.where((c) => c['status'] == 'Sắp hết hạn').length;
    final terminatedContracts = contracts.where((c) => c['status'] == 'Đã thanh lý' || c['status'] == 'Hết hạn').length;

    final filteredContracts = contracts.where((c) {
      final matchesSearch = searchKeyword.isEmpty ||
          (c['id']?.toLowerCase().contains(searchKeyword.toLowerCase()) ?? false) ||
          (c['student']?.toLowerCase().contains(searchKeyword.toLowerCase()) ?? false) ||
          (c['studentCode']?.toLowerCase().contains(searchKeyword.toLowerCase()) ?? false) ||
          (c['room']?.toLowerCase().contains(searchKeyword.toLowerCase()) ?? false);

      final matchesStatus = selectedStatus == 'Tất cả trạng thái' ||
          (selectedStatus == 'Đã thanh lý / hết hạn'
              ? (c['status'] == 'Đã thanh lý' || c['status'] == 'Hết hạn')
              : c['status'] == selectedStatus);

      return matchesSearch && matchesStatus;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;
            return GridView.count(
              crossAxisCount: isMobile ? 2 : 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isMobile ? 1.5 : 1.75,
              children: [
                _kpiCard('Tổng hợp đồng', '$totalContracts', null, 'HĐ', const Color(0xFFF1F5F9), const Color(0xFF475569)),
                _kpiCard('Đang hiệu lực', '$activeContracts', null, 'HL', const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
                _kpiCard('Sắp hết hạn', '$expiringContracts', 'Cần xử lý gia hạn', 'GH', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
                _kpiCard('Đã thanh lý / hết hạn', '$terminatedContracts', null, 'TL', const Color(0xFFF1F5F9), const Color(0xFF64748B)),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (val) => setState(() => searchKeyword = val),
                  decoration: InputDecoration(
                    hintText: 'Tìm Mã HĐ, tên sinh viên, Mã SV, số phòng...',
                    hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                  ),
                ),
              ),
              SizedBox(
                width: 190,
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Tất cả trạng thái', child: Text('Tất cả trạng thái', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Đang hiệu lực', child: Text('Đang hiệu lực', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Sắp hết hạn', child: Text('Sắp hết hạn', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Đã thanh lý / hết hạn', child: Text('Đã thanh lý / hết hạn', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => selectedStatus = val);
                  },
                ),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1D61F2),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chức năng tạo hợp đồng mới.'), behavior: SnackBarBehavior.floating),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('+ Tạo hợp đồng mới', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
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
                  dataRowMinHeight: 64,
                  dataRowMaxHeight: 74,
                  horizontalMargin: 16,
                  columnSpacing: 20,
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFBFC)),
                  columns: const [
                    DataColumn(label: Text('MÃ HĐ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('SINH VIÊN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('PHÒNG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('NGÀY BẮT ĐẦU', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('NGÀY KẾT THÚC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('TIỀN THUÊ / THÁNG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('TIỀN CỌC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('TRẠNG THÁI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('THAO TÁC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                  ],
                  rows: filteredContracts.map((contract) {
                    final isExpiring = contract['status'] == 'Sắp hết hạn';
                    return DataRow(cells: [
                      DataCell(Text(
                        contract['id'] ?? '',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.text),
                      )),
                      DataCell(Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(contract['student'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text)),
                          const SizedBox(height: 2),
                          Text(contract['studentCode'] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      )),
                      DataCell(Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(contract['room'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text)),
                          const SizedBox(height: 2),
                          Text(contract['building'] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      )),
                      DataCell(Text(contract['startDate'] ?? '', style: const TextStyle(fontSize: 12, color: AppColors.text))),
                      DataCell(Text(
                        contract['endDate'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isExpiring ? FontWeight.w800 : FontWeight.w500,
                          color: isExpiring ? const Color(0xFFEA580C) : AppColors.text,
                        ),
                      )),
                      DataCell(Text(contract['monthlyFee'] ?? '', style: const TextStyle(fontSize: 12, color: AppColors.text))),
                      DataCell(Text(contract['deposit'] ?? '', style: const TextStyle(fontSize: 12, color: AppColors.text))),
                      DataCell(_contractStatusChip(contract['status'] ?? '')),
                      DataCell(OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Xem chi tiết hợp đồng ${contract['id']}'), behavior: SnackBarBehavior.floating),
                          );
                        },
                        child: const Text('Chi tiết', style: TextStyle(fontSize: 11, color: AppColors.text, fontWeight: FontWeight.w600)),
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _kpiCard(String title, String value, String? subtitle, String badgeText, Color badgeBg, Color badgeColor) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.text)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFFEA580C), fontWeight: FontWeight.w500)),
              ],
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 36,
              height: 36,
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

  Widget _contractStatusChip(String status) {
    Color bg = const Color(0xFFF1F5F9);
    Color text = const Color(0xFF64748B);

    if (status == 'Đang hiệu lực') {
      bg = const Color(0xFFDCFCE7);
      text = const Color(0xFF16A34A);
    } else if (status == 'Sắp hết hạn') {
      bg = const Color(0xFFFEF3C7);
      text = const Color(0xFFD97706);
    } else if (status == 'Đã thanh lý' || status == 'Hết hạn') {
      bg = const Color(0xFFF1F5F9);
      text = const Color(0xFF64748B);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
