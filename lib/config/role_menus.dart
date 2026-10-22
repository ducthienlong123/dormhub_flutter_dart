import 'package:flutter/material.dart';

class RoleMenus {
  static const List<String> studentMenu = [
    'Trang chủ',
    'Đăng ký phòng',
    'Hợp đồng',
    'Hóa đơn & thanh toán',
    'Báo sự cố / Sửa chữa',
    'Thông báo',
    'Hồ sơ cá nhân',
  ];

  static const List<String> managerMenu = [
    'Dashboard',
    'Duyệt đơn đăng ký',
    'Sinh viên / Phòng',
    'Quản lý hợp đồng',
    'Hóa đơn & công nợ',
    'Điện nước',
    'Vi phạm',
    'Thông báo',
    'Báo cáo',
  ];

  static const List<String> technicianMenu = [
    'Dashboard',
    'Yêu cầu sửa chữa',
    'Lịch bảo trì',
    'Quản lý vật tư',
    'Báo cáo',
  ];

  static const List<String> adminMenu = [
    'Dashboard',
    'Quản lý tài khoản',
    'Phân quyền',
    'Cấu hình hệ thống',
    'Nhật ký hệ thống',
  ];

  static List<String> getMenuForRole(String role) {
    switch (role) {
      case 'Sinh viên':
        return studentMenu;
      case 'Kỹ thuật viên':
        return technicianMenu;
      case 'Quản trị viên':
        return adminMenu;
      case 'Quản lý KTX':
      default:
        return managerMenu;
    }
  }
}
