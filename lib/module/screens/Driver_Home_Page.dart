//
// import 'package:busservice/widgets/BusIcon.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
//
// import '../../provider/auth_provider.dart';
// import 'Driver_Profile_Page.dart';
// import 'Morning_Route.dart';
// import 'Notification_Screen.dart';
//
// class DriverHomePage extends StatefulWidget {
//   const DriverHomePage({super.key});
//
//   @override
//   State<DriverHomePage> createState() => _DriverHomePageState();
// }
//
// class _DriverHomePageState extends State<DriverHomePage> {
//   //DateTime selectedDate = DateTime.now();
//   int _currentIndex = 0;
//
//   // String formatDate(DateTime d) {
//   //   String two(int n) => n.toString().padLeft(2, '0');
//   //   return '${two(d.day)}/${two(d.month)}/${d.year}';
//   // }
//   //
//   // Future<void> _pickDate() async {
//   //   final DateTime? picked = await showDatePicker(
//   //     context: context,
//   //     initialDate: selectedDate,
//   //     firstDate: DateTime(2020),
//   //     lastDate: DateTime(2030),
//   //   );
//   //   if (picked != null && picked != selectedDate) {
//   //     setState(() {
//   //       selectedDate = picked;
//   //     });
//   //   }
//   // }
//
//   void _startTrip() {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Không tắt khi bấm ngoài
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Bắt đầu chuyến đi',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Color(0xFF004A76),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color(0xFF01406D),
//                   ),
//                   //child: const Icon(Icons.directions_bus_sharp, color: Colors.white, size: 50),
//                   child: const AnimatedBusIcon(),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Bắt đầu chuyến đi',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//
//     // Tự động đóng dialog và chuyển trang sau 1.2s
//     Future.delayed(const Duration(seconds: 1), () {
//       Navigator.pop(context); // Đóng dialog
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const RouteMorningScreen()),
//         );
//
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final double cardPadding = 16;
//     final auth = Provider.of<AuthProvider>(context, listen: true);
//     final user = auth.user;
//
//     if (user == null) {
//       return const Scaffold(
//         body: Center(child: Text("Không tìm thấy thông tin tài xế")),
//       );
//     }
//
//     final profile = user.profile;
//     final isDriver = user.role == 'tai_xe';
//     final driverInfo = user.taiXeInfo;
//
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xFFFFFFFF),
//         toolbarHeight: 72,
//         flexibleSpace: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF13B7B3),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Image.asset('assets/images/logo.png', height: 29, width: 135),
//                 ),
//                 const Spacer(),
//                 Container(
//                   width: 42,
//                   height: 40,
//                   child: ClipOval(
//                     child: Image.network(
//                       profile.avatar.isNotEmpty
//                           ? profile.avatar
//                           : 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) => Image.asset(
//                         'assets/images/avt_driver.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         color: const Color(0xFFFFFFFF),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Row(
//               //   children: [
//               //     Card(
//               //       elevation: 2,
//               //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               //       child: InkWell(
//               //         onTap: _pickDate,
//               //         borderRadius: BorderRadius.circular(8),
//               //         child: Padding(
//               //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               //           child: Row(
//               //             mainAxisSize: MainAxisSize.min,
//               //             children: [
//               //               const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF01406D)),
//               //               const SizedBox(width: 8),
//               //               Text(formatDate(selectedDate),
//               //                   style: const TextStyle(color: Color(0xFF01406D), fontWeight: FontWeight.w600)),
//               //               const SizedBox(width: 8),
//               //               const Icon(Icons.arrow_drop_down, color: Color(0xFF01406D)),
//               //             ],
//               //           ),
//               //         ),
//               //       ),
//               //     ),
//               //   ],
//               // ),
//               const SizedBox(height: 12),
//
//               /// ========== THÔNG TIN TÀI XẾ ==========
//               Card(
//                 elevation: 4,
//                 color: const Color(0xFFFFFFFF),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: EdgeInsets.all(cardPadding),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// Avatar + Tên + SĐT
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: 60,
//                             height: 60,
//                             child: ClipOval(
//                               child: Image.network(
//                                 profile.avatar.isNotEmpty
//                                     ? profile.avatar
//                                     : 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) => Image.asset(
//                                   'assets/images/avt_driver.png',
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   profile.hoten.isNotEmpty ? profile.hoten : "Chưa có tên",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20,
//                                     fontFamily: 'Roboto',
//                                   ),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   profile.sdt.isNotEmpty ? profile.sdt : "Chưa có SĐT",
//                                   style: const TextStyle(
//                                     color: Color(0xFF01406D),
//                                     fontFamily: 'Roboto',
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 14),
//
//                       /// Dữ liệu riêng tài xế
//                       if (isDriver && driverInfo != null) ...[
//                         Row(
//                           children: [
//                             Expanded(child: _infoTile('Mã bằng lái', driverInfo.mabanglai ?? "—")),
//                             const SizedBox(width: 12),
//                             Expanded(child: _infoTile('Biển số xe', driverInfo.bienso ?? "—")),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         _infoTile('Tuyến xe', driverInfo.tuyen ?? "—", full: true),
//                       ] else ...[
//                         Row(
//                           children: [
//                             Expanded(child: _infoTile('Mã bằng lái', "—")),
//                             const SizedBox(width: 12),
//                             Expanded(child: _infoTile('Biển số xe', "—")),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         _infoTile('Tuyến xe', "—", full: true),
//                       ],
//
//                       const SizedBox(height: 10),
//                       _infoTile('Tổng học sinh', "—", full: false),
//                       // _infoTile('Tổng học sinh', user.soHocSinh?.toString() ?? "—", full: false),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 14),
//
//               /// ========== CHUYẾN ĐI ==========
//               _tripSection('Lịch trình', onStart: (
//
//                   ) => _startTrip()),
//
//             ],
//           ),
//         ),
//       ),
//
//       /// ========== NAVIGATION BAR ==========
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (i) {
//           setState(() => _currentIndex = i);
//           switch (i) {
//             case 0:
//               break;
//             case 1:
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const NotificationPage()),
//               );
//               break;
//             case 2:
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const DriverProfilePage()),
//               );
//           }
//         },
//         selectedItemColor: const Color(0xFF01B4BA),
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Trang chủ'),
//           BottomNavigationBarItem(icon: Icon(Icons.add_alert), label: 'Thông báo'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
//         ],
//       ),
//     );
//   }
//
//   /// ========= WIDGET HIỂN THỊ Ô THÔNG TIN =========
//   static Widget _infoTile(String title, String value, {bool full = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.inter(
//             fontSize: 14,
//             color: const Color(0xFF01406D),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//           decoration: BoxDecoration(
//             color: const Color(0xFFA1A2A4),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             value.isNotEmpty ? value : "—",
//             style: GoogleFonts.inter(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// ========= WIDGET PHẦN CHUYẾN ĐI =========
//   Widget _tripSection(String title, {required VoidCallback onStart}) {
//     return Card(
//       elevation: 2,
//       color: const Color(0xFFFFFFFF),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: const BoxDecoration(
//               color: Color(0xFF01B4BA),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//             ),
//             child: Text(
//               title,
//               style: GoogleFonts.inter(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Center(
//               child: SizedBox(
//                 width: 200,
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: onStart,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF00B5B0),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//                     padding: EdgeInsets.zero,
//                   ),
//                   child: Text(
//                     'Bắt đầu chuyến đi',
//                     style: GoogleFonts.inter(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }
import 'package:busservice/widgets/BusIcon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import 'Driver_Profile_Page.dart';
import 'Morning_Route.dart';


class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // 🔹 Gọi API lấy lịch trình sau khi trang mở
    Future.microtask(() {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      auth.fetchSchedule();
    });
  }


  //==test
  void _startTrip() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final schedule = authProvider.schedule;
    final xeId = schedule?.xeId;

    if (xeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Không tìm thấy ID xe để bắt đầu chuyến đi"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Hiện dialog loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Bắt đầu chuyến đi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF004A76),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF01406D),
                    child: AnimatedBusIcon(), // Giữ nguyên animation của bạn
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Đang khởi động...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Gọi API cập nhật trạng thái
    final success = await authProvider.updateBusState(xeId, "waiting");

    // Đợi 1s rồi đóng dialog
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);

    if (success) {
      // Chuyển sang màn hình kế tiếp nếu thành công
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RouteMorningScreen()),
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text(" Xe đã chuyển sang trạng thái 'waiting'"),
      //     backgroundColor: Colors.green,
      //   ),
      // );
    } else {
      // // Hiện lỗi nếu thất bại
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text(" Cập nhật trạng thái thất bại"),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      _showSnackBar("Cập nhật trạng thái thất bại");
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

  @override
  Widget build(BuildContext context) {
    final double cardPadding = 16;
    final auth = Provider.of<AuthProvider>(context, listen: true);
    final user = auth.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Không tìm thấy thông tin tài xế")),
      );
    }

    final profile = user.profile;
    final isDriver = user.role == 'tai_xe';
    final driverInfo = user.taiXeInfo;
    final schedule = auth.schedule;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFFFFF),
        toolbarHeight: 72,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13B7B3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset('assets/images/logo.png', height: 29, width: 135),
                ),
                const Spacer(),
                SizedBox(
                  width: 42,
                  height: 40,
                  child: ClipOval(
                    child: profile.avatar.isNotEmpty
                        ? Image.network(
                      profile.avatar,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.person,
                          size: 24,
                          color: Color(0xFF004A76),
                        ),
                      ),
                    )
                        : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 24,
                        color: Color(0xFF004A76),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              /// ========== THÔNG TIN TÀI XẾ ==========
              Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// === ẢNH & THÔNG TIN CƠ BẢN ===
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipOval(
                            child: profile.avatar.isNotEmpty
                                ? Image.network(
                              profile.avatar,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Color(0xFF004A76),
                                ),
                              ),
                            )
                                : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.person,
                                size: 32,
                                color: Color(0xFF004A76),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.hoten.isNotEmpty ? profile.hoten : "Chưa có tên",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  profile.sdt.isNotEmpty ? profile.sdt : "Chưa có SĐT",
                                  style: const TextStyle(
                                    color: Color(0xFF01406D),
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                      const SizedBox(height: 8),

                      /// === DỮ LIỆU RIÊNG CHO TÀI XẾ ===
                      if (isDriver && driverInfo != null) ...[
                        Row(
                          children: [
                            Expanded(child: _infoTile('Mã bằng lái', driverInfo.mabanglai)),
                            const SizedBox(width: 12),
                            Expanded(child: _infoTile('Biển số xe', driverInfo.bienso)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _infoTile('Tuyến xe', driverInfo.tuyen, full: true),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                                child: _infoTile('Sức chứa', driverInfo.sucChua.toString(), full: false)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _infoTile(
                                'Tổng học sinh',
                                auth.isLoading
                                    ? "Đang tải..."
                                    : (schedule?.tongHocSinh.toString() ?? "—"),
                                full: false,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(child: _infoTile('Mã bằng lái', "—")),
                            const SizedBox(width: 12),
                            Expanded(child: _infoTile('Biển số xe', "—")),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _infoTile('Tuyến xe', "—", full: true),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _infoTile('Sức chứa', "—", full: false)),
                            const SizedBox(width: 12),
                            Expanded(child: _infoTile('Tổng học sinh', "—", full: false)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),


              /// ========== CHUYẾN ĐI ==========
              _tripSection('Lịch trình', onStart: _startTrip),
            ],
          ),
        ),
      ),

      /// ========== NAVIGATION BAR ==========
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          switch (i) {
            case 0:
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DriverProfilePage()),
              );
          }
        },
        selectedItemColor: const Color(0xFF01B4BA),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }

  /// ========= Ô hiển thị thông tin =========
  static Widget _infoTile(String title, String value, {bool full = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF01406D),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFA1A2A4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.isNotEmpty ? value : "—",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// ========= WIDGET PHẦN CHUYẾN ĐI =========
  Widget _tripSection(String title, {required VoidCallback onStart}) {
    return Card(
      elevation: 2,
      color: const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF01B4BA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Center(
              child: SizedBox(
                width: 200,
                height: 48,
                child: ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B5B0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Bắt đầu chuyến đi',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
