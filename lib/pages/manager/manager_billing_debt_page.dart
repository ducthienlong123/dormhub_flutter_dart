import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ManagerBillingDebtPageWidget extends StatefulWidget {
  const ManagerBillingDebtPageWidget({super.key});

  @override
  State<ManagerBillingDebtPageWidget> createState() => _ManagerBillingDebtPageWidgetState();
}

class _ManagerBillingDebtPageWidgetState extends State<ManagerBillingDebtPageWidget> {
  int activeFilterTab = 0; // 0: Tất cả hóa đơn, 1: Sinh viên còn nợ
  String searchKeyword = '';

  List<Map<String, String>> bills = [
    {
      'id': 'HD-2024-1101',
      'studentName': 'Nguyễn Văn An',
      'studentCode': 'SV20210001',
      'room': 'A301',
      'period': '11/2024',
      'amount': '745.000 đ',
      'rawAmount': '745000',
      'status': 'Chưa thanh toán',
    },
    {
      'id': 'HD-2024-1102',
      'studentName': 'Trần Thị Bích',
      'studentCode': 'SV20210045',
      'room': 'B204',
      'period': '11/2024',
      'amount': '718.000 đ',
      'rawAmount': '718000',
      'status': 'Đã thanh toán',
    },
    {
      'id': 'HD-2024-1003',
      'studentName': 'Lê Văn Cường',
      'studentCode': 'SV20220012',
      'room': 'A405',
      'period': '10/2024',
      'amount': '582.000 đ',
      'rawAmount': '582000',
      'status': 'Quá hạn',
    },
    {
      'id': 'HD-2024-1104',
      'studentName': 'Phạm Thị Dung',
      'studentCode': 'SV20230089',
      'room': 'C102',
      'period': '11/2024',
      'amount': '505.000 đ',
      'rawAmount': '505000',
      'status': 'Chưa thanh toán',
    },
    {
      'id': 'HD-2024-0905',
      'studentName': 'Hoàng Văn Em',
      'studentCode': 'SV20210078',
      'room': 'D203',
      'period': '09/2024',
      'amount': '726.000 đ',
      'rawAmount': '726000',
      'status': 'Quá hạn',
    },
  ];

  int get totalBills => bills.length;

  List<Map<String, String>> get debtBills =>
      bills.where((b) => b['status'] == 'Chưa thanh toán' || b['status'] == 'Quá hạn').toList();

  int get debtCount => debtBills.length;

  int get overdueCount => bills.where((b) => b['status'] == 'Quá hạn').length;

  int get totalDebtAmount {
    int sum = 0;
    for (var b in debtBills) {
      sum += int.tryParse(b['rawAmount'] ?? '0') ?? 0;
    }
    return sum;
  }

  String _formatCurrency(int amount) {
    String str = amount.toString();
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return '${str.replaceAllMapped(reg, (Match m) => '${m[1]}.')} đ';
  }

  void _exportDebtReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xuất file báo cáo công nợ (Bao_Cao_Hoa_Don_Cong_No_DormHub.xlsx) thành công!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _remindAllDebtors() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã gửi thông báo nhắc nợ tới $debtCount sinh viên còn nợ.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showBillDetail(Map<String, String> bill) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Chi tiết hóa đơn ${bill['id']}', style: const TextStyle(fontWeight: FontWeight.w800)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Sinh viên:', '${bill['studentName']} (${bill['studentCode']})'),
              const SizedBox(height: 8),
              _detailRow('Phòng / Kỳ:', '${bill['room']} - Kỳ ${bill['period']}'),
              const SizedBox(height: 8),
              _detailRow('Tổng tiền:', bill['amount']!, isBold: true),
              const SizedBox(height: 8),
              _detailRow('Trạng thái:', bill['status']!),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đóng')),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String val, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        Text(val, style: TextStyle(fontWeight: isBold ? FontWeight.w800 : FontWeight.w600, fontSize: 13, color: AppColors.text)),
      ],
    );
  }

  void _recordPayment(Map<String, String> bill) {
    setState(() {
      bill['status'] = 'Đã thanh toán';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã ghi nhận thu tiền thành công cho hóa đơn ${bill['id']}!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBills = bills.where((b) {
      final matchesTab = activeFilterTab == 0 ||
          (activeFilterTab == 1 && (b['status'] == 'Chưa thanh toán' || b['status'] == 'Quá hạn'));
      final search = searchKeyword.toLowerCase();
      final matchesSearch = search.isEmpty ||
          b['id']!.toLowerCase().contains(search) ||
          b['studentName']!.toLowerCase().contains(search) ||
          b['studentCode']!.toLowerCase().contains(search) ||
          b['room']!.toLowerCase().contains(search);
      return matchesTab && matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Hóa đơn & công nợ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.text),
            ),
            Row(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8FAFC),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _exportDebtReport,
                  child: const Text('Xuất công nợ', style: TextStyle(fontSize: 13, color: AppColors.text, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1D61F2),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _remindAllDebtors,
                  child: const Text('Nhắc nợ tất cả', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;
            return GridView.count(
              crossAxisCount: isMobile ? 1 : 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isMobile ? 2.3 : 2.6,
              children: [
                _kpiCard('Tổng hóa đơn', '$totalBills', null, 'HĐ', const Color(0xFFF1F5F9), const Color(0xFF475569)),
                _kpiCard('Sinh viên còn nợ', '$debtCount', '$overdueCount hóa đơn quá hạn', 'CN', const Color(0xFFF1F5F9), const Color(0xFF475569)),
                _kpiCard('Tổng công nợ', _formatCurrency(totalDebtAmount), null, 'NỢ', const Color(0xFFFEE2E2), const Color(0xFFDC2626)),
              ],
            );
          },
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => activeFilterTab = 0),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: activeFilterTab == 0 ? const Color(0xFF1D61F2) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Tất cả hóa đơn ($totalBills)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: activeFilterTab == 0 ? Colors.white : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => setState(() => activeFilterTab = 1),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: activeFilterTab == 1 ? const Color(0xFF1D61F2) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Sinh viên còn nợ ($debtCount)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: activeFilterTab == 1 ? Colors.white : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 260,
              child: TextField(
                onChanged: (val) => setState(() => searchKeyword = val),
                decoration: InputDecoration(
                  hintText: 'Tìm MSSV, họ tên, phòng...',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

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
                  columnSpacing: 24,
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFFAFBFC)),
                  columns: const [
                    DataColumn(label: Text('MÃ HÓA ĐƠN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('SINH VIÊN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('PHÒNG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('KỲ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('TỔNG TIỀN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('TRẠNG THÁI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                    DataColumn(label: Text('THAO TÁC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B)))),
                  ],
                  rows: filteredBills.map((bill) {
                    final isPaid = bill['status'] == 'Đã thanh toán';
                    return DataRow(cells: [
                      DataCell(Text(bill['id']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text))),
                      DataCell(Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bill['studentName']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text)),
                          const SizedBox(height: 2),
                          Text(bill['studentCode']!, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      )),
                      DataCell(Text(bill['room']!, style: const TextStyle(fontSize: 12, color: AppColors.text))),
                      DataCell(Text(bill['period']!, style: const TextStyle(fontSize: 12, color: AppColors.text))),
                      DataCell(Text(bill['amount']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.text))),
                      DataCell(_statusChip(bill['status']!)),
                      DataCell(Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => _showBillDetail(bill),
                            child: const Text('Xem hóa đơn', style: TextStyle(fontSize: 11, color: AppColors.text, fontWeight: FontWeight.w600)),
                          ),
                          if (!isPaid) ...[
                            const SizedBox(width: 8),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1D61F2),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => _recordPayment(bill),
                              child: const Text('Ghi nhận thu', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ],
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
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.text)),
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

  Widget _statusChip(String status) {
    Color bg = const Color(0xFFF1F5F9);
    Color text = const Color(0xFF64748B);

    if (status == 'Đã thanh toán') {
      bg = const Color(0xFFDCFCE7);
      text = const Color(0xFF16A34A);
    } else if (status == 'Chưa thanh toán') {
      bg = const Color(0xFFFEF3C7);
      text = const Color(0xFFD97706);
    } else if (status == 'Quá hạn') {
      bg = const Color(0xFFFEE2E2);
      text = const Color(0xFFDC2626);
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
