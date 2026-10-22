import 'package:flutter/material.dart';

import '../../data/demo_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class _DormBuilding {
  final String name;
  final String type;
  final int floors;
  final int totalRooms;
  final int availableRooms;

  const _DormBuilding({
    required this.name,
    required this.type,
    required this.floors,
    required this.totalRooms,
    required this.availableRooms,
  });
}

class _RoomLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _RoomLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 13, height: 13, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.text)),
        ],
      );
}

class StudentRoomBookingPage extends StatefulWidget {
  final String email;
  final ValueChanged<String> onNavigate;

  const StudentRoomBookingPage({super.key, required this.email, required this.onNavigate});

  @override
  State<StudentRoomBookingPage> createState() => _StudentRoomBookingPageState();
}

class _StudentRoomBookingPageState extends State<StudentRoomBookingPage> {
  bool _showAvailableBuildingsOnly = false;
  bool _showInlineForm = false;

  List<Map<String, String>> get applications => DemoStore.applications;

  Map<String, String> get currentAccount => DemoStore.accounts.firstWhere(
        (account) => account['email']?.toLowerCase() == widget.email.toLowerCase(),
        orElse: () => {'name': 'Người dùng', 'email': widget.email},
      );

  String get currentUserName => currentAccount['name'] ?? 'Người dùng';

  String get currentStudentCode => DemoStore.students.firstWhere(
        (student) => student['email']?.toLowerCase() == widget.email.toLowerCase(),
        orElse: () => {'id': 'SV20210001'},
      )['id']!;

  void _notice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) => _studentRoomBooking();

  static const List<_DormBuilding> _dormBuildings = [
    _DormBuilding(name: 'Tòa A', type: 'Nam', floors: 5, totalRooms: 100, availableRooms: 27),
    _DormBuilding(name: 'Tòa B', type: 'Nữ', floors: 4, totalRooms: 80, availableRooms: 27),
    _DormBuilding(name: 'Tòa C', type: 'Hỗn hợp', floors: 6, totalRooms: 120, availableRooms: 33),
    _DormBuilding(name: 'Tòa D', type: 'Nam', floors: 3, totalRooms: 60, availableRooms: 13),
  ];

  Widget _studentRoomBooking() {
    final buildings = _showAvailableBuildingsOnly
        ? _dormBuildings.where((building) => building.availableRooms > 0).toList()
        : _dormBuildings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _showAvailableBuildingsOnly = true;
                  _showInlineForm = false;
                });
                _notice('Hiện có ${_dormBuildings.fold<int>(0, (sum, item) => sum + item.availableRooms)} phòng trống ở ${_dormBuildings.where((item) => item.availableRooms > 0).length} tòa nhà.');
              },
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('Xem phòng trống'),
              style: FilledButton.styleFrom(
                backgroundColor: _showAvailableBuildingsOnly ? AppColors.primary : const Color(0xFFF1F5F9),
                foregroundColor: _showAvailableBuildingsOnly ? Colors.white : AppColors.text,
                elevation: 0,
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                _showRoomApplicationDialog();
              },
              icon: const Icon(Icons.description_outlined, size: 18),
              label: const Text('Nộp đơn đăng ký'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
            if (_showAvailableBuildingsOnly)
              TextButton.icon(
                onPressed: () => setState(() => _showAvailableBuildingsOnly = false),
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: const Text('Hiển thị tất cả'),
              ),
          ],
        ),
        const SizedBox(height: 24),

        if (_showInlineForm) ...[
          _RegistrationWizardWidget(
            email: widget.email,
            userName: currentUserName,
            studentCode: currentStudentCode,
            onSubmitted: (newApp) {
              setState(() {
                applications.insert(0, newApp);
                _showInlineForm = false;
              });
              DemoStore.addAudit('Gửi đơn đăng ký ${newApp['building']} - ${newApp['type']}', currentUserName);
              _notice('Nộp đơn đăng ký thành công!');
            },
            onCancel: () => setState(() => _showInlineForm = false),
          ),
          const SizedBox(height: 28),
        ],

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                'Xem tòa nhà & phòng',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: AppColors.text, letterSpacing: -.25),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                border: Border.all(color: const Color(0xFFBBD0FF)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text('4 tòa nhà', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 17),
        const Wrap(
          spacing: 18,
          runSpacing: 8,
          children: [
            _RoomLegend(color: Color(0xFF00C995), label: 'Còn trống'),
            _RoomLegend(color: Color(0xFFCBD5E1), label: 'Đang ở'),
            _RoomLegend(color: Color(0xFFFFB800), label: 'Đang sửa'),
          ],
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 760 ? 2 : 1;
            final ratio = constraints.maxWidth >= 1100
                ? 4.25
                : constraints.maxWidth >= 760
                    ? 3.7
                    : constraints.maxWidth >= 500
                        ? 3.1
                        : 2.05;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: ratio,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: buildings.map(_buildingCard).toList(),
            );
          },
        ),
        const SizedBox(height: 26),
        _myApplicationsSection(),
      ],
    );
  }

  Widget _buildingCard(_DormBuilding building) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x080D2148), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(building.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.text))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppColors.greenSoft, border: Border.all(color: const Color(0xFF98F0C8)), borderRadius: BorderRadius.circular(22)),
                child: Text('${building.availableRooms} trống', style: const TextStyle(color: AppColors.green, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildingInfo('Loại', building.type)),
                Expanded(child: _buildingInfo('Số tầng', '${building.floors} tầng')),
                Expanded(child: _buildingInfo('Tổng phòng', '${building.totalRooms} phòng')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildingInfo(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 4),
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.text)),
        ],
      );

  void _showRoomApplicationDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 760),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: _RegistrationWizardWidget(
              email: widget.email,
              userName: currentUserName,
              studentCode: currentStudentCode,
              onSubmitted: (newApp) {
                Navigator.pop(dialogContext);
                setState(() {
                  applications.insert(0, newApp);
                });
                DemoStore.addAudit('Gửi đơn đăng ký ${newApp['building']} - ${newApp['type']}', currentUserName);
                _notice('Nộp đơn đăng ký thành công!');
              },
              onCancel: () => Navigator.pop(dialogContext),
            ),
          ),
        ),
      ),
    );
  }

  Widget _myApplicationsSection() {
    final ownApplications = applications
        .where((application) => application['email']?.toLowerCase() == widget.email.toLowerCase())
        .toList();

    return SectionCard(
      title: 'Đơn đăng ký của tôi',
      subtitle: 'Các đơn đăng ký được gộp ngay tại trang này để bạn tiện theo dõi.',
      action: OutlinedButton.icon(
        onPressed: _showRoomApplicationDialog,
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('Nộp đơn mới'),
      ),
      child: ownApplications.isEmpty
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 14),
              decoration: BoxDecoration(color: const Color(0xFFFAFBFE), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: const Column(
                children: [
                  Icon(Icons.assignment_outlined, size: 35, color: AppColors.muted),
                  SizedBox(height: 9),
                  Text('Bạn chưa gửi đơn đăng ký phòng nào.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                  SizedBox(height: 5),
                  Text('Nhấn “Nộp đơn đăng ký” để bắt đầu.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            )
          : Column(
              children: [
                for (var index = 0; index < ownApplications.length; index++) ...[
                  _applicationCard(ownApplications[index]),
                  if (index < ownApplications.length - 1) const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }

  Widget _applicationCard(Map<String, String> application) {
    final status = application['status'] ?? 'Chờ duyệt';
    final isPending = status == 'Chờ duyệt';
    final statusColor = status == 'Đã duyệt'
        ? AppColors.green
        : status == 'Từ chối' || status == 'Đã hủy'
            ? AppColors.red
            : AppColors.orange;
    final statusSoftColor = status == 'Đã duyệt'
        ? AppColors.greenSoft
        : status == 'Từ chối' || status == 'Đã hủy'
            ? AppColors.redSoft
            : AppColors.orangeSoft;
    final room = application['room'] ?? 'Chưa phân';
    final building = _applicationBuilding(application);
    final roomPrefix = building.startsWith('Tòa ') ? '${building.substring(4)}-' : '';
    final roomDescription = room == 'Chưa phân'
        ? 'Chưa phân phòng'
        : roomPrefix.isNotEmpty && room.startsWith(roomPrefix)
            ? 'Phòng ${room.substring(roomPrefix.length)}'
            : 'Phòng $room';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.border)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 780;
          final identity = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.apartment_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 13),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$building · $roomDescription', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                    const SizedBox(height: 5),
                    Text('${application['id'] ?? ''} · ${application['code'] ?? currentStudentCode}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                  ],
                ),
              ),
            ],
          );
          final details = Wrap(
            spacing: 22,
            runSpacing: 12,
            children: [
              _applicationInfo('Ngày nộp đơn', application['date'] ?? '—'),
              _applicationInfo('Loại phòng', application['type'] ?? '—'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Trạng thái', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: statusSoftColor, borderRadius: BorderRadius.circular(20)),
                    child: Text(status, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          );
          final actions = Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              OutlinedButton.icon(
                onPressed: () => _showApplicationDetails(application),
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text('Xem chi tiết'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11), foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary)),
              ),
              if (isPending)
                OutlinedButton.icon(
                  onPressed: () => _cancelApplication(application),
                  icon: const Icon(Icons.delete_outline_rounded, size: 16),
                  label: const Text('Hủy đơn'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11), foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.red)),
                ),
            ],
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [identity, const SizedBox(height: 16), details, const SizedBox(height: 14), actions],
            );
          }
          return Row(
            children: [
              Expanded(flex: 4, child: identity),
              const SizedBox(width: 14),
              Expanded(flex: 5, child: details),
              const SizedBox(width: 12),
              actions,
            ],
          );
        },
      ),
    );
  }

  Widget _applicationInfo(String label, String value) => SizedBox(
        width: 118,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
            const SizedBox(height: 5),
            Text(value, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text)),
          ],
        ),
      );

  String _applicationBuilding(Map<String, String> application) {
    final requestedBuilding = application['building'];
    if (requestedBuilding != null && requestedBuilding.isNotEmpty) return requestedBuilding;
    final room = application['room'] ?? '';
    if (room != 'Chưa phân' && room.contains('-')) return 'Tòa ${room.split('-').first}';
    return 'Chưa phân tòa';
  }

  void _showApplicationDetails(Map<String, String> application) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Chi tiết đơn đăng ký'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailLine('Mã đơn', application['id'] ?? '—'),
              _detailLine('Sinh viên', application['name'] ?? currentUserName),
              _detailLine('Mã sinh viên', application['code'] ?? currentStudentCode),
              _detailLine('Tòa mong muốn', _applicationBuilding(application)),
              _detailLine('Phòng được phân', application['room'] ?? 'Chưa phân'),
              _detailLine('Loại phòng', application['type'] ?? '—'),
              _detailLine('Ngày nộp', application['date'] ?? '—'),
              _detailLine('Trạng thái', application['status'] ?? 'Chờ duyệt'),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Đóng'))],
      ),
    );
  }

  Widget _detailLine(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 135, child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted))),
            Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text))),
          ],
        ),
      );

  void _cancelApplication(Map<String, String> application) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hủy đơn đăng ký?'),
        content: Text('Bạn có chắc muốn hủy đơn ${application['id'] ?? ''} không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Không')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () {
              setState(() {
                application['status'] = 'Đã hủy';
              });
              DemoStore.addAudit('Hủy đơn đăng ký ${application['id'] ?? ''}', currentUserName);
              Navigator.pop(dialogContext);
              _notice('Đã hủy đơn đăng ký.');
            },
            child: const Text('Xác nhận hủy'),
          ),
        ],
      ),
    );
  }
}

class _RegistrationWizardWidget extends StatefulWidget {
  final String email;
  final String userName;
  final String studentCode;
  final ValueChanged<Map<String, String>> onSubmitted;
  final VoidCallback onCancel;

  const _RegistrationWizardWidget({
    required this.email,
    required this.userName,
    required this.studentCode,
    required this.onSubmitted,
    required this.onCancel,
  });

  @override
  State<_RegistrationWizardWidget> createState() => _RegistrationWizardWidgetState();
}

class _RegistrationWizardWidgetState extends State<_RegistrationWizardWidget> {
  int currentStep = 1;

  // Step 1
  String selectedBuilding = 'Tòa A (Nam)';
  String selectedRoomType = '4 người — 600.000 đ/tháng';
  late TextEditingController fromDateController;
  late TextEditingController toDateController;

  // Step 2
  late TextEditingController nameController;
  late TextEditingController studentCodeController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController facultyController;
  late TextEditingController schoolYearController;
  late TextEditingController addressController;

  // Step 3
  bool agreeTerms = false;

  @override
  void initState() {
    super.initState();
    fromDateController = TextEditingController(text: '01/09/2024');
    toDateController = TextEditingController(text: '31/05/2025');

    nameController = TextEditingController(text: widget.userName.isEmpty ? 'Nguyễn Văn A' : widget.userName);
    studentCodeController = TextEditingController(text: widget.studentCode.isEmpty ? 'SV20210001' : widget.studentCode);
    phoneController = TextEditingController(text: '0912 345 678');
    emailController = TextEditingController(text: widget.email.isEmpty ? 'sv@university.edu.vn' : widget.email);
    facultyController = TextEditingController(text: 'Công nghệ thông tin');
    schoolYearController = TextEditingController(text: '2024-2025');
    addressController = TextEditingController(text: 'Số nhà, đường, phường/xã, tỉnh/thành phố');
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    nameController.dispose();
    studentCodeController.dispose();
    phoneController.dispose();
    emailController.dispose();
    facultyController.dispose();
    schoolYearController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Đăng ký lưu trú', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.text)),
            IconButton(
              icon: const Icon(Icons.close, size: 20, color: AppColors.muted),
              onPressed: widget.onCancel,
            ),
          ],
        ),
        const SizedBox(height: 18),
        _buildStepperHeader(),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [BoxShadow(color: Color(0x060D2148), blurRadius: 16, offset: Offset(0, 4))],
          ),
          child: _buildCurrentStepContent(),
        ),
      ],
    );
  }

  Widget _buildStepperHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 580;
        return Row(
          children: [
            _stepHeaderItem(step: 1, label: 'Chọn tòa & phòng', compact: compact),
            Expanded(child: Container(height: 2, color: currentStep > 1 ? AppColors.green : const Color(0xFFE2E8F0), margin: const EdgeInsets.symmetric(horizontal: 8))),
            _stepHeaderItem(step: 2, label: 'Thông tin đăng ký', compact: compact),
            Expanded(child: Container(height: 2, color: currentStep > 2 ? AppColors.green : const Color(0xFFE2E8F0), margin: const EdgeInsets.symmetric(horizontal: 8))),
            _stepHeaderItem(step: 3, label: 'Xác nhận', compact: compact),
          ],
        );
      },
    );
  }

  Widget _stepHeaderItem({required int step, required String label, required bool compact}) {
    final isCompleted = currentStep > step;
    final isActive = currentStep == step;

    Color circleColor = const Color(0xFFE2E8F0);
    Color textColor = AppColors.muted;
    Widget circleChild = Text('$step', style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700, fontSize: 13));

    if (isCompleted) {
      circleColor = const Color(0xFF00C995);
      circleChild = const Icon(Icons.check, size: 16, color: Colors.white);
      textColor = AppColors.text;
    } else if (isActive) {
      circleColor = const Color(0xFF1D61F2);
      circleChild = Text('$step', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13));
      textColor = AppColors.text;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Center(child: circleChild),
        ),
        if (!compact) ...[
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: isActive ? FontWeight.w800 : FontWeight.w600, color: textColor)),
        ],
      ],
    );
  }

  Widget _buildCurrentStepContent() {
    if (currentStep == 1) return _buildStep1();
    if (currentStep == 2) return _buildStep2();
    return _buildStep3();
  }

  // Step 1: Chọn tòa & phòng
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 580;
            if (isWide) {
              return Row(
                children: [
                  Expanded(child: _buildBuildingDropdown()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRoomTypeDropdown()),
                ],
              );
            }
            return Column(
              children: [
                _buildBuildingDropdown(),
                const SizedBox(height: 16),
                _buildRoomTypeDropdown(),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        const Text('Thời gian lưu trú', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 580;
            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Từ ngày', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                        const SizedBox(height: 6),
                        _buildDatePickerField(fromDateController, 'mm/dd/yyyy'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Đến ngày', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                        const SizedBox(height: 6),
                        _buildDatePickerField(toDateController, 'mm/dd/yyyy'),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Từ ngày', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 6),
                _buildDatePickerField(fromDateController, 'mm/dd/yyyy'),
                const SizedBox(height: 14),
                const Text('Đến ngày', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 6),
                _buildDatePickerField(toDateController, 'mm/dd/yyyy'),
              ],
            );
          },
        ),
        const SizedBox(height: 26),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1D61F2),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => setState(() => currentStep = 2),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tiếp theo', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuildingDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Chọn tòa nhà', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedBuilding,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
          ),
          items: const [
            DropdownMenuItem(value: 'Tòa A (Nam)', child: Text('Tòa A (Nam)')),
            DropdownMenuItem(value: 'Tòa B (Nữ)', child: Text('Tòa B (Nữ)')),
            DropdownMenuItem(value: 'Tòa C (Hỗn hợp)', child: Text('Tòa C (Hỗn hợp)')),
            DropdownMenuItem(value: 'Tòa D (Nam)', child: Text('Tòa D (Nam)')),
          ],
          onChanged: (val) {
            if (val != null) setState(() => selectedBuilding = val);
          },
        ),
      ],
    );
  }

  Widget _buildRoomTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Loại phòng', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedRoomType,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
          ),
          items: const [
            DropdownMenuItem(value: '2 người — 1.000.000 đ/tháng', child: Text('2 người — 1.000.000 đ/tháng')),
            DropdownMenuItem(value: '4 người — 600.000 đ/tháng', child: Text('4 người — 600.000 đ/tháng')),
            DropdownMenuItem(value: '6 người — 450.000 đ/tháng', child: Text('6 người — 450.000 đ/tháng')),
            DropdownMenuItem(value: '8 người — 350.000 đ/tháng', child: Text('8 người — 350.000 đ/tháng')),
          ],
          onChanged: (val) {
            if (val != null) setState(() => selectedRoomType = val);
          },
        ),
      ],
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.muted),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2024),
          lastDate: DateTime(2028),
        );
        if (picked != null) {
          final formatted = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
          controller.text = formatted;
        }
      },
    );
  }

  // Step 2: Thông tin đăng ký
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 580;
            if (isWide) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildFormField('Họ và tên', nameController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFormField('Mã sinh viên', studentCodeController)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildFormField('Số điện thoại', phoneController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFormField('Email', emailController)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildFormField('Khoa / Ngành', facultyController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFormField('Năm học', schoolYearController)),
                    ],
                  ),
                ],
              );
            }
            return Column(
              children: [
                _buildFormField('Họ và tên', nameController),
                const SizedBox(height: 14),
                _buildFormField('Mã sinh viên', studentCodeController),
                const SizedBox(height: 14),
                _buildFormField('Số điện thoại', phoneController),
                const SizedBox(height: 14),
                _buildFormField('Email', emailController),
                const SizedBox(height: 14),
                _buildFormField('Khoa / Ngành', facultyController),
                const SizedBox(height: 14),
                _buildFormField('Năm học', schoolYearController),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _buildFormField('Địa chỉ thường trú', addressController, hint: 'Số nhà, đường, phường/xã, tỉnh/thành phố'),
        const SizedBox(height: 26),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              onPressed: () => setState(() => currentStep = 1),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_rounded, size: 16, color: AppColors.text),
                  SizedBox(width: 6),
                  Text('Quay lại', style: TextStyle(fontSize: 13, color: AppColors.text, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1D61F2),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => setState(() => currentStep = 3),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Tiếp theo', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
          ),
        ),
      ],
    );
  }

  // Step 3: Xác nhận
  Widget _buildStep3() {
    final buildingNameOnly = selectedBuilding.split(' (')[0];
    final roomCapacityText = selectedRoomType.contains('—') ? selectedRoomType.split(' — ')[0] : selectedRoomType;
    final priceText = selectedRoomType.contains('—') ? selectedRoomType.split(' — ')[1] : '600.000 đ/tháng';
    final priceAmountOnly = priceText.replaceAll('/tháng', '').trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Thông tin xác nhận', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E3A8A))),
              const SizedBox(height: 16),
              _confirmRow('Tòa / Phòng', '$buildingNameOnly — Phòng A301 ($roomCapacityText)'),
              const Divider(height: 20, color: Color(0xFFDBEAFE)),
              _confirmRow('Thời gian', '${fromDateController.text} → ${toDateController.text}'),
              const Divider(height: 20, color: Color(0xFFDBEAFE)),
              _confirmRow('Sinh viên', '${nameController.text} — ${studentCodeController.text}'),
              const Divider(height: 20, color: Color(0xFFDBEAFE)),
              _confirmRow('Phí hàng tháng', priceAmountOnly, isPrice: true),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: agreeTerms,
                activeColor: const Color(0xFF1D61F2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (val) => setState(() => agreeTerms = val ?? false),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('Tôi đồng ý với ', style: TextStyle(fontSize: 13, color: AppColors.text)),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nội quy ký túc xá: Giữ gìn vệ sinh chung, chấp hành giờ giấc và an toàn PCCC.'), behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: const Text(
                      'nội quy ký túc xá',
                      style: TextStyle(fontSize: 13, color: Color(0xFF1D61F2), decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Text(' và các điều khoản liên quan.', style: TextStyle(fontSize: 13, color: AppColors.text)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              onPressed: () => setState(() => currentStep = 2),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_rounded, size: 16, color: AppColors.text),
                  SizedBox(width: 6),
                  Text('Quay lại', style: TextStyle(fontSize: 13, color: AppColors.text, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: agreeTerms ? const Color(0xFF1D61F2) : const Color(0xFF94A3B8),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: agreeTerms ? _submit : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng đánh dấu đồng ý với nội quy ký túc xá.'), behavior: SnackBarBehavior.floating),
                );
              },
              child: const Text('Nộp đơn đăng ký', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _confirmRow(String label, String value, {bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF1E3A8A))),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isPrice ? 14 : 13,
              fontWeight: isPrice ? FontWeight.w800 : FontWeight.w700,
              color: const Color(0xFF1E3A8A),
            ),
          ),
        ),
      ],
    );
  }

  void _submit() {
    final buildingNameOnly = selectedBuilding.split(' (')[0];
    final roomCapacityText = selectedRoomType.contains('—') ? selectedRoomType.split(' — ')[0] : selectedRoomType;

    final newApplication = {
      'id': DemoStore.nextId('DK-2026'),
      'name': nameController.text.trim(),
      'code': studentCodeController.text.trim(),
      'email': emailController.text.trim(),
      'building': buildingNameOnly,
      'room': 'A301',
      'type': roomCapacityText,
      'date': DemoStore.dateToday(),
      'status': 'Chờ duyệt',
    };

    widget.onSubmitted(newApplication);
  }
}
