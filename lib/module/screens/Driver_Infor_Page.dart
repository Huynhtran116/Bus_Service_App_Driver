
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import 'Driver_Profile_Page.dart';

class DriverInfoPage extends StatelessWidget {
  const DriverInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: true);
    final user = auth.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Không tìm thấy thông tin tài xế")),
      );
    }

    // Kiểm tra nếu là tài xế
    final isDriver = user.role == 'tai_xe';
    final driverInfo = user.taiXeInfo; // có thể null nếu không phải tài xế

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Hồ sơ",
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
        child: Center(
          child: Column(
            children: [
              ClipOval(
                child: user.profile.avatar.isNotEmpty
                    ? Image.network(
                  user.profile.avatar,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF004A76),
                    ),
                  ),
                )
                    : Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF004A76),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow("Email", user.email),
                    _buildInfoRow("Họ và tên", user.profile.hoten),
                    _buildInfoRow("Ngày sinh", user.profile.ngaysinh),
                    _buildInfoRow("Giới tính", user.profile.gioitinh),
                    _buildInfoRow("Số điện thoại", user.profile.sdt),
                    _buildInfoRow("Địa chỉ", user.profile.diachi),
                    _buildInfoRow("CCCD", user.profile.cccd),

                    //  Nếu là tài xế → hiển thị thêm thông tin tài xế
                    if (isDriver && driverInfo != null) ...[
                      _buildInfoRow("Mã bằng lái", driverInfo.mabanglai ?? "—"),
                      _buildInfoRow("Biển số xe", driverInfo.bienso ?? "—"),
                      _buildInfoRow("Tuyến xe", driverInfo.tuyen ?? "—"),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF01406D),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value.isNotEmpty ? value : "—",
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
