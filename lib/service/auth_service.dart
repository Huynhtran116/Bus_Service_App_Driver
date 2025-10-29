//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../shares/models/User_Model.dart';
//
// class AuthService {
//   final String baseUrl = "https://qlbus.onrender.com/api";
//
//
//   Future<Map<String, dynamic>> login(String email, String password) async {
//     final url = Uri.parse('$baseUrl/auth/login');
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"email": email, "password": password}),
//     );
//
//     final data = jsonDecode(response.body);
//
//     if (response.statusCode == 200 && data['accessToken'] != null) {
//       return {
//         'token': data['accessToken'],
//         'refreshToken': data['refreshToken'],
//         // UserModel tự xử lý tai_xe_info nếu có
//         'user': UserModel.fromJson(data['user']),
//       };
//     } else {
//       throw Exception(data['message'] ?? 'Đăng nhập thất bại');
//     }
//   }
//
//
//   Future<UserModel> getCurrentUser(String token) async {
//     final url = Uri.parse('$baseUrl/users/me');
//     final response = await http.get(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );
//
//     final data = jsonDecode(response.body);
//     print("Response body: ${response.body}");
//
//     if (response.statusCode == 200) {
//       final userJson = data['data'] ?? data;
//       print("Raw user data: ${jsonEncode(userJson)}");
//       return UserModel.fromJson(userJson);
//     } else {
//       throw Exception(data['message'] ?? 'Không lấy được thông tin người dùng');
//     }
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../shares/models/User_Model.dart';
import '../shares/models/schedule_model.dart';

class AuthService {
  final String baseUrl = "https://qlbus.onrender.com/api";


  Future<void> warmUpServer() async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/health"))
          .timeout(const Duration(seconds: 5));
      print(" Wakeup status: ${response.statusCode}");
    } catch (e) {
      print("Wakeup failed: $e");
    }
  }


  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    // Giới hạn tối đa 10 giây
    final response = await http
        .post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    )
        .timeout(const Duration(seconds: 10));

    final data = jsonDecode(response.body);
    print(" Login response: ${response.body}");

    if (response.statusCode == 200 && data['accessToken'] != null) {
      final user = UserModel.fromJson(data['user']);

      // 🔒 Chặn nếu không phải tài xế
      if (user.role != 'tai_xe') {
        throw Exception('Tài khoản này không có quyền truy cập ứng dụng tài xế.');
      }
      return {
        'token': data['accessToken'],
        'refreshToken': data['refreshToken'],
        'user': UserModel.fromJson(data['user']),
      };
    } else {
      throw Exception(data['message'] ?? 'Đăng nhập thất bại');
    }
  }


  Future<UserModel> getCurrentUser(String token) async {
    final url = Uri.parse('$baseUrl/users/me');
    final response = await http
        .get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    )
        .timeout(const Duration(seconds: 10));

    final data = jsonDecode(response.body);
    print(" Response body: ${response.body}");

    if (response.statusCode == 200) {
      final userJson = data['data'] ?? data;
      return UserModel.fromJson(userJson);
    } else {
      throw Exception(data['message'] ?? 'Không lấy được thông tin người dùng');
    }
  }
  // Future<bool> changePassword({
  //   required String token,
  //   required String oldPassword,
  //   required String newPassword,
  // }) async {
  //   final url = Uri.parse('$baseUrl/auth/change-password');
  //
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //     body: jsonEncode({
  //       "oldPassword": oldPassword,
  //       "newPassword": newPassword,
  //     }),
  //   );
  //
  //   print(" Change password response: ${response.statusCode}");
  //   print(" Body: ${response.body}");
  //
  //   if (response.statusCode == 200) {
  //     return true;
  //   } else if (response.statusCode == 400) {
  //     throw Exception(" Mật khẩu cũ không đúng hoặc thiếu dữ liệu");
  //   } else if (response.statusCode == 401) {
  //     throw Exception(" Thiếu token hoặc token không hợp lệ");
  //   } else {
  //     throw Exception(" Lỗi không xác định khi đổi mật khẩu");
  //   }
  // }
  Future<bool> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/auth/change-password');

    try {
      final response = await http
          .post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
      )
          .timeout(const Duration(seconds: 10)); //  giới hạn 10s thôi

      debugPrint("Change password: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode == 200) return true;

      if (response.statusCode == 400) {
        throw Exception("Mật khẩu cũ không đúng hoặc dữ liệu thiếu");
      } else if (response.statusCode == 401) {
        throw Exception("Token không hợp lệ hoặc đã hết hạn");
      } else {
        throw Exception("Lỗi không xác định (${response.statusCode})");
      }
    } on TimeoutException {
      throw Exception("Kết nối quá chậm, vui lòng thử lại sau");
    } catch (e) {
      debugPrint("Lỗi đổi mật khẩu: $e");
      rethrow;
    }
  }
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password');

    try {
      final response = await http
          .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      )
          .timeout(const Duration(seconds: 10));

      debugPrint(" Forgot password response: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode == 200) {
        return {"success": true, "message": "OTP đã được gửi qua email"};
      } else if (response.statusCode == 404) {
        return {"success": false, "message": "Email không tồn tại"};
      } else {
        return {
          "success": false,
          "message": "Lỗi không xác định (${response.statusCode})"
        };
      }
    } on TimeoutException {
      return {"success": false, "message": "Kết nối quá chậm, vui lòng thử lại"};
    } catch (e) {
      debugPrint("Lỗi forgot password: $e");
      return {"success": false, "message": "Lỗi hệ thống: $e"};
    }
  }
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/auth/reset-password');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "otp": otp,
        "newPassword": newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'OTP không hợp lệ hoặc thiếu dữ liệu');
    }
  }
  Future<ScheduleModel> getDriverSchedule(String token) async {
    final url = Uri.parse('$baseUrl/taixe/lich-trinh');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // token lấy từ AuthProvider
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ScheduleModel.fromJson(data);
    } else {
      throw Exception('Không thể lấy lịch trình xe');
    }
  }
  ///moi
  Future<bool> updateBusState({
    required String token,
    required String xeId,
    required String state, // 'waiting' hoặc 'done'
  }) async {
    final url = Uri.parse('$baseUrl/taixe/$xeId/update-states?state=$state');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint('Lỗi cập nhật trạng thái: ${response.body}');
      return false;
    }
  }




}
