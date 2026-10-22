import 'package:flutter/material.dart';

import '../data/demo_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'home_page.dart';

enum _AuthMode { login, register, forgotPassword, resetPassword }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final studentCode = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  _AuthMode authMode = _AuthMode.login;
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void dispose() {
    fullName.dispose();
    studentCode.dispose();
    phoneNumber.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final valueText = value?.trim() ?? '';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(valueText)) {
      return 'Vui lòng nhập email hợp lệ.';
    }
    if (authMode == _AuthMode.register &&
        DemoStore.accounts.any((account) => account['email']?.toLowerCase() == valueText.toLowerCase())) {
      return 'Email này đã được đăng ký.';
    }
    return null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    final newEmail = email.text.trim().toLowerCase();
    final code = studentCode.text.trim().isEmpty
        ? 'SV${DateTime.now().year}${(DemoStore.students.length + 1).toString().padLeft(3, '0')}'
        : studentCode.text.trim();

    DemoStore.accounts.add({
      'name': fullName.text.trim(),
      'email': newEmail,
      'password': password.text,
      'phone': phoneNumber.text.trim(),
      'role': 'Sinh viên',
      'status': 'Đang hoạt động',
    });

    DemoStore.students.add({
      'id': code,
      'name': fullName.text.trim(),
      'email': newEmail,
      'phone': phoneNumber.text.trim(),
      'room': 'Chưa phân',
      'status': 'Chờ nhận phòng',
    });

    DemoStore.addAudit('Đăng ký tài khoản Sinh viên', fullName.text.trim());

    setState(() {
      authMode = _AuthMode.login;
      fullName.clear();
      studentCode.clear();
      phoneNumber.clear();
      password.clear();
      confirmPassword.clear();
    });

    _showMessage('Đăng ký thành công. Bạn có thể đăng nhập ngay bằng tài khoản vừa tạo.');
  }

  void _beginPasswordReset() {
    if (!_formKey.currentState!.validate()) return;
    final normalizedEmail = email.text.trim().toLowerCase();
    final accountExists = DemoStore.accounts.any((account) => account['email']?.toLowerCase() == normalizedEmail);
    if (!accountExists) {
      _showMessage('Không tìm thấy tài khoản có email này trong dữ liệu demo.');
      return;
    }
    setState(() {
      authMode = _AuthMode.resetPassword;
      password.clear();
      confirmPassword.clear();
      showPassword = false;
      showConfirmPassword = false;
    });
  }

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) return;
    final normalizedEmail = email.text.trim().toLowerCase();
    final index = DemoStore.accounts.indexWhere((account) => account['email']?.toLowerCase() == normalizedEmail);
    if (index < 0) {
      _showMessage('Không tìm thấy tài khoản. Vui lòng kiểm tra lại email.');
      return;
    }
    DemoStore.accounts[index]['password'] = password.text;
    DemoStore.addAudit('Đổi mật khẩu demo', normalizedEmail);
    setState(() {
      authMode = _AuthMode.login;
      password.clear();
      confirmPassword.clear();
    });
    _showMessage('Đã đổi mật khẩu trong phiên demo.');
  }

  void _switchMode(_AuthMode mode) {
    setState(() {
      authMode = mode;
      showPassword = false;
      showConfirmPassword = false;
      password.clear();
      confirmPassword.clear();
      if (mode == _AuthMode.register) {
        fullName.clear();
        studentCode.clear();
        phoneNumber.clear();
        email.clear();
      }
      if (mode == _AuthMode.login && email.text.trim().isEmpty) {
        email.text = '';
      }
    });
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    final normalizedEmail = email.text.trim().toLowerCase();
    final accountIndex = DemoStore.accounts.indexWhere((account) =>
        account['email']?.toLowerCase() == normalizedEmail &&
        account['password'] == password.text);
    if (accountIndex < 0) {
      _showMessage('Email hoặc mật khẩu chưa chính xác. Tài khoản demo dùng mật khẩu 123456.');
      return;
    }
    final account = DemoStore.accounts[accountIndex];
    if ((account['status'] ?? 'Đang hoạt động') != 'Đang hoạt động') {
      _showMessage('Tài khoản đang bị khóa. Vui lòng liên hệ quản trị viên.');
      return;
    }
    final accountRole = account['role'] ?? 'Sinh viên';
    DemoStore.addAudit('Đăng nhập thành công', account['name'] ?? normalizedEmail);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          role: accountRole,
          email: normalizedEmail,
          loginPageBuilder: (_) => const LoginPage(),
        ),
      ),
    );
  }

  InputDecoration _customInputDecoration({required String hintText, Widget? suffixIcon}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.8),
    );

    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      border: border,
      enabledBorder: border,
      focusedBorder: focusedBorder,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF0F4FF), Color(0xFFF8FAFD), Color(0xFFEEF4FF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1050),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 700;
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: Colors.white.withOpacity(.9)),
                        boxShadow: const [
                          BoxShadow(color: Color(0x14233D6C), blurRadius: 44, offset: Offset(0, 20)),
                        ],
                      ),
                      child: compact
                          ? _loginForm(compact: true)
                          : IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(flex: 5, child: _introPanel()),
                                  Expanded(flex: 6, child: _loginForm(compact: false)),
                                ],
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _introPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111D3A), Color(0xFF1A3159), Color(0xFF2454A1)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -96,
            top: -74,
            child: Container(
              width: 290,
              height: 290,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(.055), width: 32),
              ),
            ),
          ),
          Positioned(
            right: -55,
            bottom: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF6EA0FF).withOpacity(.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 42, 36, 38),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  children: [
                    DormHubLogo(size: 49, dark: true),
                    SizedBox(width: 13),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DormHub', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -.6)),
                        SizedBox(height: 4),
                        Text('SMART DORMITORY', style: TextStyle(color: Color(0xFF9EB7E3), fontWeight: FontWeight.w800, fontSize: 8, letterSpacing: 1.35)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 45),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.09),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(.11)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome_rounded, size: 13, color: Color(0xFF9CC3FF)),
                      SizedBox(width: 7),
                      Text('CỔNG THÔNG TIN KÝ TÚC XÁ', style: TextStyle(color: Color(0xFFE0E9FA), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: .65)),
                    ],
                  ),
                ),
                const SizedBox(height: 19),
                const Text(
                  'Quản lý ký túc xá,\nđơn giản hơn mỗi ngày.',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 30, height: 1.23, letterSpacing: -.8),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Một không gian làm việc tập trung dành cho sinh viên, ban quản lý và đội ngũ kỹ thuật.',
                  style: TextStyle(color: Color(0xFFCBD5E1), height: 1.65, fontSize: 13),
                ),
                const SizedBox(height: 30),
                const _FeatureLine(icon: Icons.meeting_room_outlined, title: 'Quản lý chỗ ở', subtitle: 'Sinh viên, phòng và đăng ký lưu trú'),
                const SizedBox(height: 18),
                const _FeatureLine(icon: Icons.receipt_long_outlined, title: 'Theo dõi chi phí', subtitle: 'Hóa đơn và tình trạng thanh toán'),
                const SizedBox(height: 18),
                const _FeatureLine(icon: Icons.handyman_outlined, title: 'Xử lý sự cố', subtitle: 'Tiếp nhận và cập nhật bảo trì'),
                const SizedBox(height: 34),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(color: Color(0xFF66D6A6), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 9),
                    const Text('Nền tảng quản lý tập trung', style: TextStyle(color: Color(0xFFD8E4F6), fontSize: 11, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    const Icon(Icons.shield_outlined, color: Color(0xFF9CC3FF), size: 17),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginForm({required bool compact}) {
    final isLogin = authMode == _AuthMode.login;
    final isRegister = authMode == _AuthMode.register;
    final isForgot = authMode == _AuthMode.forgotPassword;
    final isResetPassword = authMode == _AuthMode.resetPassword;

    final heading = isLogin
        ? 'Chào mừng trở lại!'
        : isRegister
            ? 'Tạo tài khoản mới'
            : isResetPassword
                ? 'Đặt lại mật khẩu'
                : 'Khôi phục mật khẩu';
    final description = isLogin
        ? 'Đăng nhập để tiếp tục vào hệ thống.'
        : isRegister
            ? 'Tạo tài khoản DormHub. Tài khoản đăng ký mới mặc định là Sinh viên.'
            : isResetPassword
                ? 'Nhập mật khẩu mới cho tài khoản của bạn.'
                : 'Nhập email đã đăng ký để tiếp tục khôi phục.';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 25 : 42, vertical: compact ? 30 : 42),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (compact) ...[
              const Center(child: DormHubLogo(size: 50)),
              const SizedBox(height: 15),
            ],
            Text(heading, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: -.6, color: AppColors.text)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 13, color: AppColors.muted, height: 1.45)),
            const SizedBox(height: 25),

            if (isRegister) ...[
              // 1. Họ và tên
              const _FieldCaption('Họ và tên'),
              const SizedBox(height: 8),
              TextFormField(
                controller: fullName,
                textCapitalization: TextCapitalization.words,
                decoration: _customInputDecoration(hintText: 'Nguyễn Văn A'),
                validator: (val) => (val?.trim().isEmpty ?? true) ? 'Vui lòng nhập họ và tên.' : null,
              ),
              const SizedBox(height: 16),

              // 2. Mã sinh viên
              const _FieldCaption('Mã sinh viên'),
              const SizedBox(height: 8),
              TextFormField(
                controller: studentCode,
                decoration: _customInputDecoration(hintText: 'SV20210001'),
                validator: (val) => (val?.trim().isEmpty ?? true) ? 'Vui lòng nhập mã sinh viên.' : null,
              ),
              const SizedBox(height: 16),

              // 3. Số điện thoại
              const _FieldCaption('Số điện thoại'),
              const SizedBox(height: 8),
              TextFormField(
                controller: phoneNumber,
                keyboardType: TextInputType.phone,
                decoration: _customInputDecoration(hintText: '0912 345 678'),
                validator: (val) => (val?.trim().isEmpty ?? true) ? 'Vui lòng nhập số điện thoại.' : null,
              ),
              const SizedBox(height: 16),

              // 4. Email (sv@university.edu.vn)
              const _FieldCaption('Email (sv@university.edu.vn)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: _customInputDecoration(hintText: 'sv@university.edu.vn'),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),

              // 5. Mật khẩu
              const _FieldCaption('Mật khẩu'),
              const SizedBox(height: 8),
              TextFormField(
                controller: password,
                obscureText: !showPassword,
                decoration: _customInputDecoration(
                  hintText: 'Nhập mật khẩu',
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: const Color(0xFF1D61F2),
                    ),
                    onPressed: () => setState(() => showPassword = !showPassword),
                  ),
                ),
                validator: (val) => (val ?? '').length < 6 ? 'Mật khẩu cần ít nhất 6 ký tự.' : null,
              ),
              const SizedBox(height: 16),

              // 6. Xác nhận mật khẩu
              const _FieldCaption('Xác nhận mật khẩu'),
              const SizedBox(height: 8),
              TextFormField(
                controller: confirmPassword,
                obscureText: !showConfirmPassword,
                decoration: _customInputDecoration(
                  hintText: '',
                  suffixIcon: IconButton(
                    icon: Icon(
                      showConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: const Color(0xFF94A3B8),
                    ),
                    onPressed: () => setState(() => showConfirmPassword = !showConfirmPassword),
                  ),
                ),
                validator: (val) {
                  if ((val ?? '').isEmpty) return 'Vui lòng nhập lại mật khẩu.';
                  if (val != password.text) return 'Mật khẩu nhập lại chưa khớp.';
                  return null;
                },
              ),
            ] else ...[
              // Default Login / Forgot Password inputs
              const _FieldCaption('Email'),
              const SizedBox(height: 8),
              TextFormField(
                controller: email,
                readOnly: isResetPassword,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                  hintText: 'ten@university.edu.vn',
                ),
                validator: _validateEmail,
              ),
              if (isLogin || isResetPassword) ...[
                const SizedBox(height: 16),
                const _FieldCaption('Mật khẩu'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: password,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    hintText: 'Nhập mật khẩu',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => showPassword = !showPassword),
                      icon: Icon(showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    ),
                  ),
                  validator: (val) => (val ?? '').length < 6 ? 'Mật khẩu cần ít nhất 6 ký tự.' : null,
                  onFieldSubmitted: (_) { if (isLogin) _login(); },
                ),
              ],
            ],

            if (isLogin) ...[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _switchMode(_AuthMode.forgotPassword),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8)),
                  child: const Text('Quên mật khẩu?'),
                ),
              ),
              const SizedBox(height: 9),
            ] else
              const SizedBox(height: 24),

            SizedBox(
              height: 51,
              child: FilledButton.icon(
                onPressed: isLogin
                    ? _login
                    : isRegister
                        ? _register
                        : isForgot
                            ? _beginPasswordReset
                            : _resetPassword,
                icon: Icon(
                  isLogin
                      ? Icons.login_rounded
                      : isRegister
                          ? Icons.person_add_alt_1_rounded
                          : isForgot
                              ? Icons.arrow_forward_rounded
                              : Icons.lock_reset_rounded,
                  size: 19,
                ),
                label: Text(
                  isLogin
                      ? 'Đăng nhập hệ thống'
                      : isRegister
                          ? 'Tạo tài khoản'
                          : isForgot
                              ? 'Tiếp tục'
                              : 'Lưu mật khẩu mới',
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (isLogin)
              TextButton.icon(
                onPressed: () => _switchMode(_AuthMode.register),
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                label: const Text('Chưa có tài khoản? Đăng ký ngay'),
              )
            else
              TextButton.icon(
                onPressed: () => _switchMode(_AuthMode.login),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Quay lại đăng nhập'),
              ),
            if (isLogin) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(color: const Color(0xFFF5F7FB), borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 18),
                    SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Tài khoản demo (mật khẩu chung: 123456): sv@university.edu.vn · qlktx@university.edu.vn · kt@university.edu.vn · admin@university.edu.vn. Vai trò được xác định từ tài khoản. Đăng ký mới chỉ tạo quyền Sinh viên.',
                        style: TextStyle(color: AppColors.muted, fontSize: 11, height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 22),
            const Text('© 2026 DormHub · Bản demo giao diện', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF9AA5B5), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureLine({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: Colors.white.withOpacity(.1), borderRadius: BorderRadius.circular(13)),
          child: Icon(icon, color: const Color(0xFF8AB9FF), size: 21),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 5),
              Text(subtitle, style: const TextStyle(color: Color(0xFFB7C4D8), fontSize: 11, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class _FieldCaption extends StatelessWidget {
  final String text;
  const _FieldCaption(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontSize: 13),
    );
  }
}
