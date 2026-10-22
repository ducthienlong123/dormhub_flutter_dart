import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'dashboard_common.dart';

class ManagerDashboard extends StatelessWidget {
  final List<Map<String, String>> students;
  final List<Map<String, String>> applications;
  final List<Map<String, String>> repairs;
  final ValueChanged<String> onNavigate;

  const ManagerDashboard({
    super.key,
    required this.students,
    required this.applications,
    required this.repairs,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final pendingApplications = applications.where((item) => item['status'] == 'Chờ duyệt').length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RoleWelcomeCard(
          title: 'Tổng quan quản lý ký túc xá',
          subtitle: 'Theo dõi chỗ ở, duyệt hồ sơ lưu trú, hóa đơn công nợ và phát sóng thông báo KTX.',
          icon: Icons.apartment_rounded,
        ),
        const SizedBox(height: 18),
        RoleStatGrid(items: [
          RoleStatItem(label: 'Sinh viên mẫu', value: '${students.length}', note: 'Danh sách đang hiển thị', icon: Icons.people_alt_outlined),
          const RoleStatItem(label: 'Tổng số phòng', value: '320', note: 'Tòa A, B, C và D', icon: Icons.meeting_room_outlined, accent: AppColors.purple, softColor: AppColors.purpleSoft),
          RoleStatItem(label: 'Đơn chờ duyệt', value: '$pendingApplications', note: 'Theo danh sách demo', icon: Icons.assignment_outlined, accent: AppColors.orange, softColor: AppColors.orangeSoft),
          const RoleStatItem(label: 'Thông báo KTX', value: '2', note: 'Kênh thông báo sinh viên', icon: Icons.campaign_outlined, accent: AppColors.green, softColor: AppColors.greenSoft),
        ]),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final occupancy = _occupancyCard();
            final pending = _attentionCard(pendingApplications);
            if (constraints.maxWidth < 850) {
              return Column(children: [occupancy, const SizedBox(height: 16), pending]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 5, child: occupancy), const SizedBox(width: 16), Expanded(flex: 4, child: pending)]);
          },
        ),
        const SizedBox(height: 20),
        SectionCard(
          title: 'Đơn đăng ký gần đây',
          subtitle: 'Bấm xem danh sách để duyệt và cập nhật trạng thái',
          action: TextButton(onPressed: () => onNavigate('Duyệt đơn đăng ký'), child: const Text('Xem danh sách')),
          child: Column(
            children: applications.take(3).map((item) => Column(
              children: [
                RoleInfoLine(
                  icon: Icons.assignment_outlined,
                  title: '${item['id']} · ${item['name']}',
                  subtitle: 'Phòng đề xuất ${item['room']} · ${item['date']}',
                  trailing: StatusChip(label: item['status'] ?? 'Chưa rõ'),
                ),
                if (item != applications.take(3).last) const Divider(height: 1),
              ],
            )).toList(),
          ),
        ),
        const SizedBox(height: 18),
        SectionCard(
          title: 'Thông báo chung KTX',
          subtitle: 'Danh sách thông báo mới đăng tới sinh viên các tòa',
          action: TextButton(onPressed: () => onNavigate('Thông báo'), child: const Text('Quản lý thông báo')),
          child: Column(
            children: const [
              RoleInfoLine(
                icon: Icons.campaign_outlined,
                title: 'Kiểm tra PCCC tòa A',
                subtitle: 'Gửi tới Sinh viên tòa A · Ngày tạo: 10/11/2024',
                trailing: StatusChip(label: 'Đã gửi'),
              ),
              Divider(height: 1),
              RoleInfoLine(
                icon: Icons.campaign_outlined,
                title: 'Nhắc thanh toán hóa đơn tháng 11',
                subtitle: 'Gửi tới Sinh viên chưa thanh toán · Ngày tạo: 11/11/2024',
                trailing: StatusChip(label: 'Bản nháp'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _occupancyCard() {
    return SectionCard(
      title: 'Tình trạng phòng ở',
      subtitle: 'Phân bố sử dụng phòng theo dữ liệu minh họa',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('77,5%', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -.8, color: AppColors.text)),
            SizedBox(width: 8),
            Padding(padding: EdgeInsets.only(bottom: 4), child: Text('đang được sử dụng', style: TextStyle(fontSize: 11, color: AppColors.muted))),
          ]),
          const SizedBox(height: 15),
          ClipRRect(borderRadius: BorderRadius.circular(20), child: const LinearProgressIndicator(value: .775, minHeight: 9, backgroundColor: Color(0xFFEDF0F5), color: AppColors.primary)),
          const SizedBox(height: 18),
          const RoleInfoLine(icon: Icons.circle, title: 'Đang sử dụng', subtitle: '248 phòng', trailing: StatusChip(label: '77,5%')),
          const Divider(height: 1),
          const RoleInfoLine(icon: Icons.circle, title: 'Còn trống', subtitle: '52 phòng', trailing: StatusChip(label: '16,3%')),
          const Divider(height: 1),
          const RoleInfoLine(icon: Icons.circle, title: 'Đang bảo trì', subtitle: '20 phòng', trailing: StatusChip(label: '6,2%')),
        ],
      ),
    );
  }

  Widget _attentionCard(int pendingApplications) {
    return SectionCard(
      title: 'Cần chú ý',
      subtitle: 'Đầu việc nên kiểm tra trước',
      child: Column(
        children: [
          RoleInfoLine(icon: Icons.assignment_outlined, title: 'Đơn đăng ký chờ duyệt', subtitle: 'Các hồ sơ đang chờ xét duyệt', trailing: Text('$pendingApplications', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: AppColors.orange))),
          const Divider(height: 1),
          RoleInfoLine(icon: Icons.campaign_outlined, title: 'Thông báo KTX', subtitle: 'Quản lý phát sóng thông báo', trailing: IconButton(tooltip: 'Mở thông báo', onPressed: () => onNavigate('Thông báo'), icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary))),
          const Divider(height: 1),
          RoleInfoLine(icon: Icons.assessment_outlined, title: 'Báo cáo quản lý', subtitle: 'Xem tổng quan hoạt động theo kỳ', trailing: IconButton(tooltip: 'Mở báo cáo', onPressed: () => onNavigate('Báo cáo'), icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary))),
        ],
      ),
    );
  }
}
