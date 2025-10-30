
import 'package:busservice/module/screens/Driver_Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import 'ForgotPass_Screen.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Vui lòng nhập đầy đủ email và mật khẩu!");
      return;
    }

    setState(() => _isLoading = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    bool success = false;
    String message = "";

    try {
      success = await auth.login(email, password);
      if (success) {
        message = "Đăng nhập thành công!";
      } else {
        message = "Đăng nhập thất bại. Vui lòng kiểm tra lại!";
      }
    } catch (e) {
      if (e.toString().contains("quyền truy cập")) {
        message = "Tài khoản của bạn không thuộc quyền truy cập ứng dụng tài xế.";
      } else {
        message = "Đăng nhập thất bại. Vui lòng kiểm tra lại!";
      }
      success = false;
    } finally {
      setState(() => _isLoading = false);
      _showDialog(message, success);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF01406D),
      ),
    );
  }

  void _showDialog(String message, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            isSuccess ? "Thông báo" : "Lỗi đăng nhập",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isSuccess ? Colors.green[900] : Colors.red[900],
            ),
          ),
        ),
        content: SizedBox(
          height: 80,
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF333333),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (isSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DriverHomePage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF01406D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  "OK",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/logo.png', height: 60),
              const SizedBox(height: 20),
              Text(
                'Đăng nhập',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF01406D),
                ),
              ),
              const SizedBox(height: 30),

              // Email field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Địa chỉ email',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: _inputDecoration("Nhập email"),
              ),
              const SizedBox(height: 20),

              // Password field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mật khẩu',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: _inputDecoration("Nhập mật khẩu").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(color: Color(0xFFA1A2A4)),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Login button
              SizedBox(
                width: 233,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B4B4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(44),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Đăng nhập',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),


            ],
          ),
        ),
      ),
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
