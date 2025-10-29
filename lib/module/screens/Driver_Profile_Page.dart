import 'package:busservice/module/screens/Change_Password_Page.dart';
import 'package:busservice/module/screens/Driver_Infor_Page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:busservice/provider/auth_provider.dart';
import 'Driver_Home_Page.dart';
import 'Login_Screen.dart';


class DriverProfilePage extends StatefulWidget {
  const DriverProfilePage({super.key});

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final String? token = auth.token;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF01406D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: (user?.profile.avatar.isNotEmpty == true)
                        ? Image.network(
                      user!.profile.avatar,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 40,
                        color: Color(0xFF004A76),
                      ),
                    )
                        : const Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF004A76),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  user?.profile.hoten.isNotEmpty == true
                      ? user!.profile.hoten
                      : 'Tài xế chưa cập nhật tên',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user?.email ?? 'Chưa có email',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Menu danh sách
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Thông tin tài xế',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) =>  DriverInfoPage()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Đổi mật khẩu',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const  ChangePasswordPage()),
                    );
                  },
                ),
                const SizedBox(height: 16),
             
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Đăng xuất',

                  onTap: () async {
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: Text(
                          'Đăng xuất',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF01406D),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        content:  Text(
                          'Bạn có chắc chắn muốn đăng xuất không?',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,

                          ),
                          textAlign: TextAlign.center,
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black54,
                              backgroundColor: const Color(0xFF1E3A8A33),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                              child: Text('Hủy'
                              ,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF01406D),
                                )),
                            ),
                          ),
                          SizedBox(
                            width: 26,
                          )
                          ,
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003366),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child:  Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                              child: Text('Đăng xuất', style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFFFFF),
                              ),),
                            ),
                          ),
                        ],
                      ),
                    );

                    // Nếu người dùng chọn "Đăng xuất"
                    if (shouldLogout == true) {
                      await auth.logout();

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      }
                    }
                  },
                ),

              ],
            ),
          ),
        ],
      ),

      // Thanh điều hướng dưới cùng
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          switch (i) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) =>  DriverHomePage()),
              );
              break;
            case 1:
              break;
          }


        },
        selectedItemColor: const Color(0xFF01B4BA),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Trang chủ"

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color color = Colors.black87,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFFF3F3F3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF01406D), size: 30),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: const Color(0xFF01406D),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        trailing: const Icon(Icons.chevron_right,
            color: Color(0xFF01406D), size: 30),
        onTap: onTap,
      ),
    );
  }
}
