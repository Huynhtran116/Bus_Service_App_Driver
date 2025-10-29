//
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import '../../provider/auth_provider.dart';
// import 'Student_Location.dart';
//
// class RouteMorningScreen extends StatefulWidget {
//   const RouteMorningScreen({super.key});
//
//   @override
//   State<RouteMorningScreen> createState() => _RouteMorningScreenState();
// }
//
// class _RouteMorningScreenState extends State<RouteMorningScreen> {
//   final Map<int, bool> _expanded = {};
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final schedule = authProvider.schedule;
//     final isLoading = authProvider.isLoading;
//
//     return Scaffold(
//       backgroundColor: const Color(0xffF4F7FA),
//       appBar: AppBar(
//         title: Text(
//           "Lộ trình buổi sáng",
//           style: GoogleFonts.inter(
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//             color: const Color(0xFF01406D),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0.8,
//         centerTitle: true,
//       //  leading: const SizedBox(),
//       ),
//       body: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(color: Color(0xFF01406D)),
//       )
//           : schedule == null
//           ? Center(
//         child: ElevatedButton.icon(
//           icon: const Icon(Icons.refresh, color: Colors.white),
//           label: const Text("Tải lại lịch trình"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF004A76),
//           ),
//           onPressed: () => authProvider.fetchSchedule(),
//         ),
//       )
//           : Column(
//         children: [
//           const SizedBox(height: 20),
//
//           // QR code xe buýt
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF004A76), Color(0xFF067BA2)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   offset: Offset(0, 4),
//                   blurRadius: 6,
//                 ),
//               ],
//             ),
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Text(
//                   "QR Xe ${schedule.codeXe}",
//                   style: GoogleFonts.inter(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       QrImageView(
//                         data: '''
//                         {
//                           "xe_id": "${schedule.xeId}",
//
//                         }
//                                   ''',
//                         version: QrVersions.auto,
//                         size: 220,
//                         backgroundColor: Colors.white,
//                         eyeStyle: const QrEyeStyle(
//                           eyeShape: QrEyeShape.circle,
//                           color: Color(0xFF004A76),
//                         ),
//                         dataModuleStyle: const QrDataModuleStyle(
//                           dataModuleShape: QrDataModuleShape.circle,
//                           color: Color(0xFF004A76),
//                         ),
//                       ),
//                       Positioned(
//                         child: Container(
//                           width: 50,
//                           height: 50,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white,
//                           ),
//                           child: const Icon(Icons.directions_bus,
//                               color: Color(0xFF004A76), size: 32),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Quét mã này để xác nhận xe buýt',
//                   style: GoogleFonts.inter(
//                     fontSize: 14,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           // Danh sách học sinh
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               itemCount: schedule.lichTrinh.length,
//               itemBuilder: (context, index) {
//                 final trip = schedule.lichTrinh[index];
//                 final ph = trip.phuHuynh;
//                 final isExpanded = _expanded[index] ?? false;
//
//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => StudentLocationScreen(
//                           hoTen: trip.hoTenHocSinh,
//                           diaDiem: trip.diaDiem,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Card(
//                   color: Colors.white,
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: trip.avatar.isNotEmpty
//                                   ? Image.network(
//                                 trip.avatar,
//                                 width: 80,
//                                 height: 80,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) => Container(
//                                   width: 80,
//                                   height: 80,
//                                   color: Colors.grey[200],
//                                   child: const Icon(
//                                     Icons.account_circle,
//                                     color: Colors.grey,
//                                     size: 50,
//                                   ),
//                                 ),
//                               )
//                                   : Container(
//                                 width: 80,
//                                 height: 80,
//                                 color: Colors.grey[200],
//                                 child: const Icon(
//                                   Icons.account_circle,
//                                   color: Colors.grey,
//                                   size: 50,
//                                 ),
//                               ),
//                             ),
//
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     trip.hoTenHocSinh,
//                                     style: GoogleFonts.inter(
//                                       fontWeight: FontWeight.bold,
//                                       color: const Color(0xff004A76),
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     "Mã học sinh: ${trip.mahs}",
//                                     style: GoogleFonts.inter(
//                                         color: Colors.black87),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     trip.diaDiem,
//                                     style: GoogleFonts.inter(
//                                         color: Colors.black54,
//                                         fontWeight: FontWeight.w700
//                                     )
//                                     ,
//
//                                   ),
//                                   Text(
//                                     "SĐT: ${trip.sdtHocSinh}",
//                                     style: GoogleFonts.inter(
//                                       color: Colors.black87,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//
//
//
//                                 ],
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 isExpanded
//                                     ? Icons.expand_less
//                                     : Icons.expand_more,
//                                 color: const Color(0xFF01406D),
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _expanded[index] = !isExpanded;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//
//                         // Xem thêm chi tiết
//                         AnimatedCrossFade(
//                           duration: const Duration(milliseconds: 300),
//                           firstChild: const SizedBox.shrink(),
//                           secondChild: Container(
//                             margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFF3F8FB),
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(color: const Color(0xFFD1E3F3)),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//
//                                 const SizedBox(height: 4),
//                                 Row(
//                                   children: [
//                                     const Icon(Icons.family_restroom, color: Color(0xFF004A76), size: 18),
//                                     const SizedBox(width: 6),
//                                     Expanded(
//                                       child: Text(
//                                         "Phụ huynh: ${ph.hoTen} (${ph.quanHe})",
//                                         style: GoogleFonts.inter(
//                                           color: Colors.black87,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Row(
//                                   children: [
//                                     const Icon(Icons.phone, color: Color(0xFF004A76), size: 18),
//                                     const SizedBox(width: 6),
//                                     Expanded(
//                                       child: Text(
//                                         "SĐT (PH): ${ph.sdt}",
//                                         style: GoogleFonts.inter(
//                                           color: Colors.black87,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           crossFadeState:
//                           isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 )
//                 );
//
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final schedule = authProvider.schedule;
    final isLoading = authProvider.isLoading;

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
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF01406D)),
      )
          : schedule == null
          ? Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.refresh, color: Colors.white),
          label: const Text("Tải lại lịch trình"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF004A76),
          ),
          onPressed: () => authProvider.fetchSchedule(),
        ),
      )
          : Column(
        children: [
          const SizedBox(height: 20),

          // QR code xe buýt
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
                Text(
                  "QR Xe ${schedule.codeXe}",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
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
                  'Quét mã này để xác nhận xe buýt',
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Danh sách học sinh " ,style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.bold,
                color: Color(0xFF004A76)

            ),

          ),),
          Divider(),
          const SizedBox(height: 20),
          // Danh sách học sinh
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: schedule.lichTrinh.length,
              itemBuilder: (context, index) {
                final trip = schedule.lichTrinh[index];
                final ph = trip.phuHuynh;
                final isExpanded = _expanded[index] ?? false;

                return InkWell(
                  onTap: () async {
                    final diaDiem = Uri.encodeComponent(trip.diaDiem);
                    final googleMapsUrl =
                        'https://www.google.com/maps/search/?api=1&query=$diaDiem';

                    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                      await launchUrl(
                        Uri.parse(googleMapsUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text('Không mở được Google Maps')),
                      );
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
                                borderRadius:
                                BorderRadius.circular(10),
                                child: trip.avatar.isNotEmpty
                                    ? Image.network(
                                  trip.avatar,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error,
                                      stackTrace) =>
                                      Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.account_circle,
                                          color: Colors.grey,
                                          size: 50,
                                        ),
                                      ),
                                )
                                    : Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.account_circle,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trip.hoTenHocSinh,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        color:
                                        const Color(0xff004A76),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Mã học sinh: ${trip.mahs}",
                                      style: GoogleFonts.inter(
                                          color: Colors.black87),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      trip.diaDiem,
                                      style: GoogleFonts.inter(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "SĐT: ${trip.sdtHocSinh}",
                                      style: GoogleFonts.inter(
                                        color: Colors.black87,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
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

                          // Chi tiết phụ huynh
                          AnimatedCrossFade(
                            duration:
                            const Duration(milliseconds: 300),
                            firstChild: const SizedBox.shrink(),
                            secondChild: Container(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 5, right: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F8FB),
                                borderRadius:
                                BorderRadius.circular(10),
                                border: Border.all(
                                    color:
                                    const Color(0xFFD1E3F3)),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                          Icons.family_restroom,
                                          color: Color(0xFF004A76),
                                          size: 18),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          "Phụ huynh: ${ph.hoTen} (${ph.quanHe})",
                                          style: GoogleFonts.inter(
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone,
                                          color: Color(0xFF004A76),
                                          size: 18),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          "SĐT (PH): ${ph.sdt}",
                                          style: GoogleFonts.inter(
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            crossFadeState: isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                label:  Text(
                  "Hoàn thành lộ trình",
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF)
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004A76),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final success = await authProvider.updateBusState(
                      schedule.xeId, "done");
                  if (success) {
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const DriverHomePage()),
                            (route) => false,
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                          Text("Cập nhật trạng thái thất bại")),
                    );
                  }
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}
