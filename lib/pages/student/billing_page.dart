import 'package:flutter/material.dart';

import '../../data/demo_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class StudentBillingPage extends StatefulWidget {
  final String email;
  final String userName;

  const StudentBillingPage({super.key, required this.email, required this.userName});

  @override
  State<StudentBillingPage> createState() => _StudentBillingPageState();
}

class _StudentBillingPageState extends State<StudentBillingPage> {
  int _studentBillingTab = 0;
  String? _selectedStudentBillId;

  void _notice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleBills = DemoStore.bills
        .where((bill) => bill['email']?.toLowerCase() == widget.email.toLowerCase())
        .toList();
    final Map<String, String>? selectedBill = visibleBills.isEmpty
        ? null
        : visibleBills.firstWhere(
            (bill) => bill['id'] == _selectedStudentBillId,
            orElse: () => visibleBills.first,
          );

    final unpaidBills = visibleBills.where((bill) => bill['status'] == 'Chưa thanh toán').toList();
    final paidBills = visibleBills.where((bill) => bill['status'] == 'Đã thanh toán').toList();
    final period = selectedBill?['period'] ?? 'Chưa có kỳ thu';
    final dueDate = selectedBill?['dueDate'] ?? 'Chưa cập nhật';
    final amount = _billingNumber(selectedBill?['amount']);
    final hasBreakdown = selectedBill?.containsKey('rentAmount') ?? false;
    final isUtilityOnly = !hasBreakdown && (selectedBill?['title'] ?? '').toLowerCase().contains('điện nước');
    final rentAmount = hasBreakdown
        ? _billingNumber(selectedBill?['rentAmount'])
        : (isUtilityOnly ? 0 : amount);
    final electricKwh = _billingNumber(selectedBill?['electricKwh']);
    final electricRate = _billingNumber(selectedBill?['electricRate']);
    final waterM3 = _billingNumber(selectedBill?['waterM3']);
    final waterRate = _billingNumber(selectedBill?['waterRate']);
    final electricAmount = hasBreakdown ? electricKwh * electricRate : 0;
    final waterAmount = hasBreakdown ? waterM3 * waterRate : 0;
    final sanitationAmount = _billingNumber(selectedBill?['sanitationAmount']);
    final total = hasBreakdown ? rentAmount + electricAmount + waterAmount + sanitationAmount : amount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _studentBillingTabButton('Hóa đơn', 0, Icons.receipt_long_outlined),
            _studentBillingTabButton('Thanh toán', 1, Icons.payments_outlined),
            _studentBillingTabButton('Lịch sử', 2, Icons.history_rounded),
          ],
        ),
        const SizedBox(height: 30),
        if (_studentBillingTab == 0) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text('Xem hóa đơn', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: -.35, color: AppColors.text)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFBDD3FF))),
                child: Text('Tháng $period', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (selectedBill == null)
            _billingEmptyState('Chưa có hóa đơn', 'Khi quản lý tạo hóa đơn, thông tin sẽ hiển thị tại đây.')
          else ...[
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth >= 1000
                    ? (constraints.maxWidth - 32) / 3
                    : constraints.maxWidth >= 620
                        ? (constraints.maxWidth - 16) / 2
                        : constraints.maxWidth;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(width: cardWidth, child: _billingSummaryCard('Tiền phòng', _billingMoney(rentAmount), 'TP', const Color(0xFFE5EBFF), AppColors.primary)),
                    SizedBox(width: cardWidth, child: _billingSummaryCard('Điện nước', _billingMoney(electricAmount + waterAmount + (isUtilityOnly ? amount : 0)), 'ĐN', const Color(0xFFFFEFE1), AppColors.orange)),
                    SizedBox(width: cardWidth, child: _billingSummaryCard('Tổng cộng', _billingMoney(total), 'TỔ', const Color(0xFFE0F3EC), AppColors.green, note: 'Hạn: $dueDate')),
                  ],
                );
              },
            ),
            const SizedBox(height: 26),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: AppColors.border),
                boxShadow: const [BoxShadow(color: Color(0x070D2148), blurRadius: 20, offset: Offset(0, 6))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chi tiết hóa đơn tháng $period', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.text)),
                  const SizedBox(height: 22),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final tableWidth = constraints.maxWidth < 760 ? 760.0 : constraints.maxWidth;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: tableWidth,
                          child: Column(
                            children: [
                              _billingDetailRow('KHOẢN MỤC', 'ĐƠN VỊ', 'SỐ LƯỢNG', 'ĐƠN GIÁ', 'THÀNH TIỀN', header: true),
                              const Divider(height: 1, color: AppColors.border),
                              if (hasBreakdown) ...[
                                _billingDetailRow('Tiền phòng ${selectedBill['room'] ?? 'A-203'}', 'Tháng', '1', _billingMoney(rentAmount), _billingMoney(rentAmount)),
                                _billingDetailRow('Điện ($electricKwh kWh)', 'kWh', '$electricKwh', _billingMoney(electricRate), _billingMoney(electricAmount)),
                                _billingDetailRow('Nước ($waterM3 m³)', 'm³', '$waterM3', _billingMoney(waterRate), _billingMoney(waterAmount)),
                                _billingDetailRow('Phí vệ sinh', 'Tháng', '1', _billingMoney(sanitationAmount), _billingMoney(sanitationAmount)),
                              ] else if (isUtilityOnly) ...[
                                _billingDetailRow('Điện nước', 'Gói', '1', _billingMoney(amount), _billingMoney(amount)),
                              ] else ...[
                                _billingDetailRow(selectedBill['title'] ?? 'Tiền phòng ${selectedBill['room'] ?? 'A-203'}', 'Tháng', '1', _billingMoney(rentAmount), _billingMoney(rentAmount)),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 28, color: AppColors.border),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Tổng cộng', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                        const SizedBox(height: 3),
                        Text(_billingMoney(total), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: AppColors.text)),
                        const SizedBox(height: 8),
                        Text('Hạn thanh toán: $dueDate', style: const TextStyle(color: AppColors.orange, fontSize: 12, fontWeight: FontWeight.w600)),
                        if (selectedBill['status'] == 'Chưa thanh toán') ...[
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () => setState(() => _studentBillingTab = 1),
                            icon: const Icon(Icons.payments_outlined, size: 18),
                            label: const Text('Đi đến thanh toán'),
                          ),
                        ] else ...[
                          const SizedBox(height: 14),
                          const StatusChip(label: 'Đã thanh toán'),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ] else if (_studentBillingTab == 1) ...[
          const Text('Thanh toán hóa đơn', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: -.35, color: AppColors.text)),
          const SizedBox(height: 7),
          const Text('Kiểm tra khoản phí còn nợ và xác nhận thanh toán trong bản demo.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
          const SizedBox(height: 20),
          if (unpaidBills.isEmpty)
            _billingEmptyState('Bạn không có khoản phí chưa thanh toán', 'Các hóa đơn đã được thanh toán sẽ xuất hiện trong mục Lịch sử.')
          else
            SectionCard(
              title: 'Khoản cần thanh toán',
              subtitle: '${unpaidBills.length} hóa đơn đang chờ thanh toán',
              child: Column(
                children: unpaidBills.map((bill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 650;
                        final details = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bill['title'] ?? 'Hóa đơn', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                            const SizedBox(height: 5),
                            Text('Mã ${bill['id'] ?? ''}  •  Kỳ ${bill['period'] ?? ''}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                            const SizedBox(height: 8),
                            Text(bill['amount'] ?? '0 đ', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.text)),
                          ],
                        );
                        final payButton = FilledButton.icon(
                          onPressed: () {
                            setState(() => bill['status'] = 'Đã thanh toán');
                            DemoStore.addAudit('Thanh toán demo ${bill['id']}', widget.userName);
                            _notice('Đã cập nhật trạng thái trong bản demo. Không có giao dịch tiền thật.');
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 18),
                          label: const Text('Thanh toán demo'),
                        );
                        if (compact) {
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [details, const SizedBox(height: 12), Row(children: [const StatusChip(label: 'Chưa thanh toán'), const Spacer(), payButton])]);
                        }
                        return Row(children: [Expanded(child: details), const SizedBox(width: 18), const StatusChip(label: 'Chưa thanh toán'), const SizedBox(width: 18), payButton]);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 12),
          const Text('Lưu ý: thao tác này chỉ cập nhật dữ liệu demo trên giao diện, không trừ tiền và không tạo giao dịch ngân hàng.', style: TextStyle(fontSize: 11, color: AppColors.muted, height: 1.5)),
        ] else ...[
          const Text('Lịch sử thanh toán', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: -.35, color: AppColors.text)),
          const SizedBox(height: 7),
          const Text('Các hóa đơn đã thanh toán của tài khoản hiện tại.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
          const SizedBox(height: 20),
          if (paidBills.isEmpty)
            _billingEmptyState('Chưa có lịch sử thanh toán', 'Sau khi thanh toán hóa đơn, thông tin sẽ được lưu ở đây.')
          else
            SectionCard(
              title: 'Các hóa đơn đã thanh toán',
              subtitle: '${paidBills.length} hóa đơn',
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      headingRowHeight: 45,
                      dataRowMinHeight: 56,
                      dataRowMaxHeight: 66,
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFF7F9FC)),
                      columns: const [
                        DataColumn(label: Text('MÃ HÓA ĐƠN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted))),
                        DataColumn(label: Text('NỘI DUNG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted))),
                        DataColumn(label: Text('KỲ THU', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted))),
                        DataColumn(label: Text('SỐ TIỀN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted))),
                        DataColumn(label: Text('TRẠNG THÁI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted))),
                        DataColumn(label: Text('THAO TÁC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted))),
                      ],
                      rows: paidBills.map((bill) => DataRow(cells: [
                        DataCell(Text(bill['id'] ?? '', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(bill['title'] ?? '', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(bill['period'] ?? '', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(bill['amount'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
                        const DataCell(StatusChip(label: 'Đã thanh toán')),
                        DataCell(TextButton.icon(
                          onPressed: () => setState(() {
                            _selectedStudentBillId = bill['id'];
                            _studentBillingTab = 0;
                          }),
                          icon: const Icon(Icons.visibility_outlined, size: 16),
                          label: const Text('Xem'),
                        )),
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

  Widget _studentBillingTabButton(String label, int index, IconData icon) {
    final active = _studentBillingTab == index;
    return active
        ? FilledButton.icon(
            onPressed: () => setState(() => _studentBillingTab = index),
            icon: Icon(icon, size: 18),
            label: Text(label),
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13)),
          )
        : OutlinedButton.icon(
            onPressed: () => setState(() => _studentBillingTab = index),
            icon: Icon(icon, size: 18, color: AppColors.muted),
            label: Text(label),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.text, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13)),
          );
  }

  Widget _billingSummaryCard(String label, String amount, String mark, Color softColor, Color accent, {String? note}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 142),
      padding: const EdgeInsets.fromLTRB(24, 22, 20, 19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x070D2148), blurRadius: 18, offset: Offset(0, 5))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, color: AppColors.muted)),
                const SizedBox(height: 8),
                Text(amount, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: -.55, color: AppColors.text)),
                if (note != null) ...[
                  const SizedBox(height: 8),
                  Text(note, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: softColor, borderRadius: BorderRadius.circular(15)),
            child: Text(mark, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: accent)),
          ),
        ],
      ),
    );
  }

  Widget _billingDetailRow(String item, String unit, String quantity, String unitPrice, String total, {bool header = false}) {
    final style = TextStyle(
      fontSize: header ? 11 : 13,
      fontWeight: header ? FontWeight.w800 : FontWeight.w500,
      color: header ? AppColors.muted : AppColors.text,
      letterSpacing: header ? .3 : 0,
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: header ? 14 : 15),
      decoration: BoxDecoration(color: header ? const Color(0xFFFAFBFE) : Colors.white),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(item, style: style, maxLines: 2, overflow: TextOverflow.ellipsis)),
          Expanded(flex: 2, child: Text(unit, style: style)),
          Expanded(flex: 2, child: Text(quantity, style: style)),
          Expanded(flex: 3, child: Text(unitPrice, style: style)),
          Expanded(flex: 3, child: Text(total, style: style)),
        ],
      ),
    );
  }

  Widget _billingEmptyState(String title, String description) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
        child: Column(
          children: [
            Container(width: 54, height: 54, decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle), child: const Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 25)),
            const SizedBox(height: 14),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.text)),
            const SizedBox(height: 6),
            Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.muted, height: 1.5)),
          ],
        ),
      );

  int _billingNumber(String? value) => int.tryParse((value ?? '').replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  String _billingMoney(int value) {
    final digits = value.toString();
    final formatted = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) formatted.write('.');
      formatted.write(digits[index]);
    }
    return '${formatted.toString()} đ';
  }


}
