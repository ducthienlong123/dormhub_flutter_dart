import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ReportsPageWidget extends StatefulWidget {
  const ReportsPageWidget({super.key});

  @override
  State<ReportsPageWidget> createState() => _ReportsPageWidgetState();
}

class _ReportsPageWidgetState extends State<ReportsPageWidget> {
  int _activeTab = 0; // 0: Tổng hợp, 1: Tài chính, 2: Sinh viên, 3: Vi phạm

  final List<Map<String, String>> monthlyRevenue = [
    {'month': 'T1', 'value': '420'},
    {'month': 'T2', 'value': '450'},
    {'month': 'T3', 'value': '480'},
    {'month': 'T4', 'value': '510'},
    {'month': 'T5', 'value': '530'},
    {'month': 'T6', 'value': '550'},
    {'month': 'T7', 'value': '570'},
    {'month': 'T8', 'value': '590'},
    {'month': 'T9', 'value': '600'},
    {'month': 'T10', 'value': '614'},
    {'month': 'T11', 'value': '634'},
    {'month': 'T12', 'value': '650'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Header Row with Export Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Báo cáo',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.text,
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xuất báo cáo ra file Excel demo.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.description_outlined, size: 16, color: Color(0xFF64748B)),
              label: const Text(
                'Xuất Excel',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Top Row: 2 Cards (Doanh thu & Công suất sử dụng phòng)
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 850;
            final revenueCard = _buildRevenueChartCard();
            final occupancyCard = _buildOccupancyCard();

            if (isMobile) {
              return Column(
                children: [
                  revenueCard,
                  const SizedBox(height: 16),
                  occupancyCard,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: revenueCard),
                const SizedBox(width: 16),
                Expanded(child: occupancyCard),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        // Bottom Section: Tabs + Metrics Table
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x040D2148),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabs Row
              Row(
                children: [
                  _buildTabButton(0, 'Tổng hợp'),
                  const SizedBox(width: 12),
                  _buildTabButton(1, 'Tài chính'),
                  const SizedBox(width: 12),
                  _buildTabButton(2, 'Sinh viên'),
                  const SizedBox(width: 12),
                  _buildTabButton(3, 'Vi phạm'),
                ],
              ),
              const SizedBox(height: 20),

              // Metrics Table
              _buildMetricsTable(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x040D2148),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doanh thu theo tháng (2024)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 35),
          // Bar Chart Visualization
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: monthlyRevenue.map((item) {
                final val = double.parse(item['value']!);
                final maxVal = 700.0;
                final heightFactor = (val / maxVal).clamp(0.1, 1.0);
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 14,
                        height: 110 * heightFactor,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D61F2).withOpacity(0.85),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item['month']!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccupancyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x040D2148),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Công suất sử dụng phòng',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 20),
          _buildOccupancyRow('Tòa A', 0.87, '87%', const Color(0xFF1D61F2)),
          const SizedBox(height: 16),
          _buildOccupancyRow('Tòa B', 0.94, '94%', const Color(0xFFEC4899)),
          const SizedBox(height: 16),
          _buildOccupancyRow('Tòa C', 0.85, '85%', const Color(0xFF10B981)),
          const SizedBox(height: 16),
          _buildOccupancyRow('Tòa D', 0.74, '74%', const Color(0xFFD97706)),
        ],
      ),
    );
  }

  Widget _buildOccupancyRow(String title, double value, String percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: const Color(0xFFF1F5F9),
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(int index, String label) {
    final isActive = _activeTab == index;
    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1D61F2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowHeight: 45,
              dataRowMinHeight: 52,
              dataRowMaxHeight: 60,
              horizontalMargin: 8,
              columnSpacing: 40,
              headingRowColor: WidgetStateProperty.all(Colors.white),
              columns: const [
                DataColumn(
                  label: Text(
                    'CHỈ TIÊU',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'THÁNG 10/2024',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'THÁNG 11/2024',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'THAY ĐỔI',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
              rows: [
                _buildMetricRow('Tổng sinh viên', '830', '842', '↑ +12', isPositive: true),
                _buildMetricRow('Phòng đang dùng', '205', '210', '↑ +5', isPositive: true),
                _buildMetricRow('Doanh thu', '614M đ', '634M đ', '↑ +3.2%', isPositive: true),
                _buildMetricRow('Vi phạm mới', '8', '5', '↓ -37.5%', isPositive: false),
              ],
            ),
          ),
        );
      },
    );
  }

  DataRow _buildMetricRow(
    String metric,
    String octValue,
    String novValue,
    String change, {
    required bool isPositive,
  }) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            metric,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ),
        DataCell(
          Text(
            octValue,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.text,
            ),
          ),
        ),
        DataCell(
          Text(
            novValue,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.text,
            ),
          ),
        ),
        DataCell(
          Text(
            change,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isPositive ? const Color(0xFF16A34A) : const Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }
}
