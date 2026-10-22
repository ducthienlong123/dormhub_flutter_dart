import 'package:flutter/material.dart';

import '../../data/contracts/contract_repository.dart';
import '../../models/dorm_contract.dart';
import '../../theme/app_theme.dart';

/// Giao diện theo dõi hợp đồng của vai trò Sinh viên.
/// Repository được inject để sau này đổi sang API/backend dễ dàng.
class StudentContractPage extends StatefulWidget {
  final String email;
  final ContractRepository? repository;

  const StudentContractPage({super.key, required this.email, this.repository});

  @override
  State<StudentContractPage> createState() => _StudentContractPageState();
}

class _StudentContractPageState extends State<StudentContractPage> {
  late final ContractRepository _repository;
  DormContract? _currentContract;
  List<DormContract> _history = const [];
  bool _loading = true;
  String? _error;
  bool _working = false;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? DemoContractRepository.instance;
    _loadContracts();
  }

  Future<void> _loadContracts() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<Object?>([
        _repository.getCurrentContract(widget.email),
        _repository.getContractHistory(widget.email),
      ]);
      if (!mounted) return;
      setState(() {
        _currentContract = results[0] as DormContract?;
        _history = results[1] as List<DormContract>;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Không thể tải thông tin hợp đồng. Vui lòng thử lại.';
        _loading = false;
      });
    }
  }

  void _showNotice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _renewContract() async {
    final contract = _currentContract;
    if (contract == null || _working) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Gia hạn hợp đồng'),
        content: Text('Bạn muốn gửi yêu cầu gia hạn hợp đồng ${contract.id}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Để sau')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Xác nhận gia hạn')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _working = true);
    try {
      final updated = await _repository.renewContract(widget.email, contract.id);
      if (!mounted) return;
      setState(() {
        _currentContract = updated;
        _working = false;
      });
      _showNotice('Đã ghi nhận gia hạn trong dữ liệu demo.');
    } catch (error) {
      if (!mounted) return;
      setState(() => _working = false);
      _showNotice(error.toString());
    }
  }

  Future<void> _terminateContract() async {
    final contract = _currentContract;
    if (contract == null || _working) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Chấm dứt hợp đồng sớm?'),
        content: Text('Bạn xác nhận gửi yêu cầu chấm dứt hợp đồng ${contract.id} chứ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Không')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xác nhận chấm dứt'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _working = true);
    try {
      final updated = await _repository.terminateContract(widget.email, contract.id);
      if (!mounted) return;
      setState(() {
        _currentContract = updated;
        _working = false;
      });
      _showNotice('Đã cập nhật trạng thái hợp đồng trong dữ liệu demo.');
    } catch (error) {
      if (!mounted) return;
      setState(() => _working = false);
      _showNotice(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Theo dõi hợp đồng', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -.35, color: AppColors.text)),
            const SizedBox(height: 24),
            if (_loading)
              const Padding(padding: EdgeInsets.symmetric(vertical: 50), child: Center(child: CircularProgressIndicator()))
            else if (_error != null)
              _errorPanel()
            else ...[
              if (_currentContract != null) _currentContractCard(_currentContract!) else _emptyCurrentContract(),
              const SizedBox(height: 20),
              _historyCard(),
            ],
            const SizedBox(height: 4),
            const Text(
              'Dữ liệu hiện là bản demo. Khi tích hợp backend, các thao tác gia hạn/chấm dứt sẽ gửi yêu cầu đến máy chủ để xét duyệt.',
              style: TextStyle(fontSize: 11, color: AppColors.muted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currentContractCard(DormContract contract) {
    final canManage = contract.status == 'Đang hiệu lực';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x080D2148), blurRadius: 18, offset: Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('HỢP ĐỒNG HIỆN TẠI', style: TextStyle(fontSize: 12, color: AppColors.muted, letterSpacing: .35)),
                  const SizedBox(height: 7),
                  Text(contract.id, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.text)),
                ]),
              ),
              _ContractStatusChip(label: contract.status),
            ],
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 540 ? 2 : 1;
              final itemWidth = columns == 2 ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;
              final items = <Widget>[
                _contractInfo('Phòng', contract.room),
                _contractInfo('Loại phòng', contract.roomType),
                _contractInfo('Ngày bắt đầu', contract.startDate),
                _contractInfo('Ngày kết thúc', contract.endDate),
                _contractInfo('Phí hàng tháng', contract.monthlyFee),
                _contractInfo('Đặt cọc', contract.deposit),
              ];
              return Wrap(spacing: 16, runSpacing: 16, children: items.map((item) => SizedBox(width: itemWidth, child: item)).toList());
            },
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: _working ? null : () => _showNotice('Chức năng tải file hợp đồng PDF sẽ được kết nối khi tích hợp backend.'),
                icon: const Icon(Icons.download_outlined, size: 17),
                label: const Text('Tải hợp đồng'),
              ),
              OutlinedButton.icon(
                onPressed: canManage && !_working ? _renewContract : null,
                icon: const Icon(Icons.event_repeat_outlined, size: 17),
                label: const Text('Gia hạn hợp đồng'),
              ),
              OutlinedButton.icon(
                onPressed: canManage && !_working ? _terminateContract : null,
                icon: const Icon(Icons.close_rounded, size: 17),
                label: const Text('Chấm dứt sớm'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.red, side: const BorderSide(color: Color(0xFFFFB7BC)), backgroundColor: const Color(0xFFFFF5F5)),
              ),
              if (_working) const Padding(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contractInfo(String label, String value) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFFF7F9FC), borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 3),
          Text(value, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.text)),
        ]),
      );

  Widget _historyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 25, 26, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x080D2148), blurRadius: 18, offset: Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lịch sử hợp đồng', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.text)),
          const SizedBox(height: 18),
          if (_history.isEmpty)
            const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Center(child: Text('Chưa có hợp đồng cũ.', style: TextStyle(color: AppColors.muted, fontSize: 13))))
          else
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    horizontalMargin: 12,
                    columnSpacing: 24,
                    headingRowHeight: 42,
                    dataRowMinHeight: 50,
                    dataRowMaxHeight: 58,
                    headingRowColor: WidgetStateProperty.all(Colors.white),
                    columns: const [
                      DataColumn(label: Text('MÃ HĐ', style: _tableHeaderStyle)),
                      DataColumn(label: Text('PHÒNG', style: _tableHeaderStyle)),
                      DataColumn(label: Text('THỜI GIAN', style: _tableHeaderStyle)),
                      DataColumn(label: Text('TRẠNG THÁI', style: _tableHeaderStyle)),
                    ],
                    rows: _history.map((contract) => DataRow(cells: [
                      DataCell(Text(contract.id, style: const TextStyle(fontSize: 13, color: AppColors.text))),
                      DataCell(Text(contract.room, style: const TextStyle(fontSize: 13, color: AppColors.text))),
                      DataCell(Text(contract.period, style: const TextStyle(fontSize: 13, color: AppColors.text))),
                      DataCell(_ContractStatusChip(label: contract.status)),
                    ])).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _emptyCurrentContract() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
        child: const Column(children: [Icon(Icons.description_outlined, size: 36, color: AppColors.muted), SizedBox(height: 10), Text('Bạn chưa có hợp đồng lưu trú hiện tại.', style: TextStyle(fontSize: 13, color: AppColors.muted))]),
      );

  Widget _errorPanel() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Column(children: [Text(_error!, style: const TextStyle(color: AppColors.red)), const SizedBox(height: 12), OutlinedButton.icon(onPressed: _loadContracts, icon: const Icon(Icons.refresh_rounded), label: const Text('Thử lại'))]),
      );
}

const _tableHeaderStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted, letterSpacing: .3);

class _ContractStatusChip extends StatelessWidget {
  final String label;
  const _ContractStatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final isActive = label == 'Đang hiệu lực';
    final isTerminated = label == 'Đã chấm dứt';
    final foreground = isActive ? AppColors.green : isTerminated ? AppColors.red : AppColors.muted;
    final background = isActive ? AppColors.greenSoft : isTerminated ? AppColors.redSoft : const Color(0xFFF0F3F8);
    final border = isActive ? const Color(0xFF98F0C8) : isTerminated ? const Color(0xFFFFB7BC) : AppColors.border;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(24), border: Border.all(color: border)),
      child: Text(label, style: TextStyle(fontSize: 11, color: foreground, fontWeight: FontWeight.w700)),
    );
  }
}
