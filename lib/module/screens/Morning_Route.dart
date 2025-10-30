
//==================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../provider/auth_provider.dart';
import 'Driver_Home_Page.dart';

class RouteMorningScreen extends StatefulWidget {
  const RouteMorningScreen({super.key});

  @override
  State<RouteMorningScreen> createState() => _RouteMorningScreenState();
}

class _RouteMorningScreenState extends State<RouteMorningScreen> {
  final Map<int, bool> _expanded = {};
  bool _showQr = true; // Ẩn/hiện QR
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
            MaterialPageRoute(builder: (_) => const DriverHomePage()),
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
                  "Hoàn thành lộ trình",
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
                    Icons.star,
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

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FA),
      appBar: AppBar(
        title: Text(
          "Lộ trình",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: const Color(0xFF01406D),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.8,
        centerTitle: true,
        leading: SizedBox(),
      ),
      body: _buildScheduleBody(authProvider),
    );
  }

  //  Gom toàn bộ logic hiển thị vào đây
  Widget _buildScheduleBody(AuthProvider authProvider) {
    final schedule = authProvider.schedule;
    final isLoading = authProvider.isLoading;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF01406D)),
      );
    }

    if (schedule == null) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.refresh, color: Colors.white),
          label: const Text("Tải lại lịch trình"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF004A76),
          ),
          onPressed: () => authProvider.fetchSchedule(),
        ),
      );
    }

    if (schedule.lichTrinh.isEmpty) {
      return const _EmptyStateWidget(
        icon: Icons.map_outlined,
        title: "Không có dữ liệu lộ trình",
        subtitle: "Hiện tại chưa có lịch trình nào để hiển thị.",
        color: Color(0xFF004A76),
      );
    }

    final waitingList = schedule.lichTrinh
        .where((trip) => trip.state == "waiting")
        .toList();

    if (waitingList.isEmpty) {
      return const _EmptyStateWidget(
        icon: Icons.school_outlined,
        title: "Chưa có học sinh chờ",
        subtitle:
        "Tất cả học sinh đã lên xe hoặc chưa có điểm đón nào đang chờ.",
        color: Color(0xFF01406D),
      );
    }

    // Nếu có dữ liệu hợp lệ
    return _buildScheduleContent(schedule, waitingList, authProvider);
  }

  // ✅ Giao diện chính khi có dữ liệu
  Widget _buildScheduleContent(schedule, List waitingList, AuthProvider authProvider) {
    return Column(
      children: [
        const SizedBox(height: 20),

        // --- QR code xe buýt ---
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF004A76), Color(0xFF067BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "QR Xe ${schedule.codeXe}",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      _showQr ? Icons.visibility_off : Icons.qr_code_2,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () {
                      setState(() {
                        _showQr = !_showQr;
                      });
                    },
                    tooltip: _showQr ? "Ẩn QR" : "Hiện QR",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_showQr)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      QrImageView(
                        data: '''
                        {
                          "xe_id": "${schedule.xeId}"
                        }
                      ''',
                        version: QrVersions.auto,
                        size: 220,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.circle,
                          color: Color(0xFF004A76),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color: Color(0xFF004A76),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.directions_bus,
                            color: Color(0xFF004A76),
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                _showQr ? 'Quét mã này để xác nhận xe buýt' : 'Bấm để xem QR',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Danh sách học sinh",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF004A76),
            ),
          ),
        ),
        Divider(),
        const SizedBox(height: 20),

        // --- Danh sách học sinh ---
        Expanded(
          child: RefreshIndicator(
            color: const Color(0xFF004A76),
            onRefresh: () async => authProvider.fetchSchedule(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: waitingList.length,
              itemBuilder: (context, index) {
                final trip = waitingList[index];
                final ph = trip.phuHuynh;
                final isExpanded = _expanded[index] ?? false;

                return _buildStudentCard(trip, ph, index, isExpanded);
              },
            ),
          ),
        ),

        // --- Nút hoàn thành ---
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              label: Text(
                "Hoàn thành lộ trình",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004A76),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final success =
                await authProvider.updateBusState(schedule.xeId, "done");

                if (success) {
                  _showSuccessDialog();
                } else {
                  _showSnackBar("Cập nhật trạng thái thất bại");
                }
              },
            ),
          ),
        ),

      ],
    );
  }

  // --- Thẻ học sinh ---
  Widget _buildStudentCard(trip, ph, int index, bool isExpanded) {
    return InkWell(
      onTap: () async {
        final diaDiem = Uri.encodeComponent(trip.diaDiem);
        final googleMapsUrl =
            'https://www.google.com/maps/search/?api=1&query=$diaDiem';
        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl),
              mode: LaunchMode.externalApplication);
        } else {

          _showSnackBar('Không mở được Google Maps');
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: trip.avatar.isNotEmpty
                        ? Image.network(
                      trip.avatar,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _defaultAvatar(),
                    )
                        : _defaultAvatar(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.hoTenHocSinh,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff004A76),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text("Mã học sinh: ${trip.mahs}",
                            style: GoogleFonts.inter(color: Colors.black87)),
                        const SizedBox(height: 2),
                        Text(trip.diaDiem,
                            style: GoogleFonts.inter(
                                color: Colors.black54,
                                fontWeight: FontWeight.w700)),
                        Text("SĐT: ${trip.sdtHocSinh}",
                            style: GoogleFonts.inter(
                                color: Colors.black87, fontSize: 15)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: const Color(0xFF01406D),
                    ),
                    onPressed: () {
                      setState(() {
                        _expanded[index] = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: const SizedBox.shrink(),
                secondChild: _buildParentInfo(ph),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParentInfo(ph) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD1E3F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.family_restroom,
                color: Color(0xFF004A76), size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                "Phụ huynh: ${ph.hoTen} (${ph.quanHe})",
                style:
                GoogleFonts.inter(color: Colors.black87, fontSize: 14),
              ),
            ),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.phone, color: Color(0xFF004A76), size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text("SĐT (PH): ${ph.sdt}",
                  style: GoogleFonts.inter(color: Colors.black87, fontSize: 14)),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _defaultAvatar() => Container(
    width: 80,
    height: 80,
    color: Colors.grey[200],
    child: const Icon(Icons.account_circle, color: Colors.grey, size: 50),
  );
}

// --- Widget hiển thị trạng thái trống ---
class _EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _EmptyStateWidget({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color = Colors.blueGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: color.withOpacity(0.8)),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: color)),
            const SizedBox(height: 8),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.4)),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Đang chờ cập nhật...',
                  style: TextStyle(
                      fontSize: 14, color: color.withOpacity(0.8))),
            ),
          ],
        ),
      ),
    );
  }
}

