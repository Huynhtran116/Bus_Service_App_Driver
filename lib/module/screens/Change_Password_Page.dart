
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import 'Driver_Profile_Page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final success = await authProvider.changePassword(
        oldPassword: _oldPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        _showSuccessDialog();
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Đổi mật khẩu thất bại, vui lòng thử lại.")),
        // );
        _showSnackBar("Đổi mật khẩu thất bại, vui lòng thử lại.");
      }
    } catch (e) {
      if (!mounted) return;
      final errorMessage = e.toString().replaceAll("Exception:", "").trim();
      _showSnackBar(errorMessage);
    }
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter(color: Color(0xFFFFFFFF), fontSize: 15,fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF01406D),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(const Duration(seconds: 2), () async {
          if (!mounted) return;
          // Đóng dialog
          if (Navigator.canPop(dialogContext)) Navigator.pop(dialogContext);

          // Chuyển hướng về ProfilePage (thay thế trang hiện tại)
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DriverProfilePage()),
          );
        });

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Cập nhật thành công",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF004A75),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2EF977),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoading = authProvider.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Đổi mật khẩu",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: const Color(0xFF01406D),
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DriverProfilePage()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Color(0xFF01406D)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildLabel("Mật khẩu cũ"),
              const SizedBox(height: 10),
              _buildPasswordField(
                controller: _oldPasswordController,
                hint: "Mật khẩu cũ",
                obscure: _obscureOld,
                toggle: () => setState(() => _obscureOld = !_obscureOld),
                validator: (v) => v == null || v.isEmpty ? "Nhập mật khẩu cũ" : null,
              ),
              const SizedBox(height: 20),

              _buildLabel("Mật khẩu mới"),
              const SizedBox(height: 10),
              _buildPasswordField(
                controller: _newPasswordController,
                hint: "Mật khẩu mới",
                obscure: _obscureNew,
                toggle: () => setState(() => _obscureNew = !_obscureNew),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Nhập mật khẩu mới";
                  if (v.length < 6) return "Mật khẩu mới phải ít nhất 6 ký tự";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildLabel("Xác nhận mật khẩu mới"),
              const SizedBox(height: 10),
              _buildPasswordField(
                controller: _confirmPasswordController,
                hint: "Xác nhận mật khẩu mới",
                obscure: _obscureConfirm,
                toggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Nhập lại mật khẩu mới";
                  if (v != _newPasswordController.text) return "Mật khẩu không khớp";
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Nút cập nhật
              SizedBox(
                width: 233,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleChangePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01B4BA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(44),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    "Cập nhật",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback toggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: _inputDecoration(hint).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFFA1A2A4),
          ),
          onPressed: toggle,
        ),
      ),
      validator: validator,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: const Color(0xFFA1A2A4),
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(width: 0.5, color: Color(0xFFA1A2A4)),
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
    );
  }
}

