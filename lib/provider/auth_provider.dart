
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/auth_service.dart';
import '../shares/models/User_Model.dart';
import '../shares/models/schedule_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  String? _token;
  String? _refreshToken;
  UserModel? _user;
  bool _isLoading = false;
  ScheduleModel? _schedule;
  String? get token => _token;

  UserModel? get user => _user;

  bool get isAuthenticated => _token != null;

  bool get isLoading => _isLoading;
  ScheduleModel? get schedule => _schedule;


  // Future<bool> login(String email, String password) async {
  //   try {
  //     _isLoading = true;
  //     notifyListeners();
  //
  //     final result = await _authService.login(email, password);
  //     _token = result['token'];
  //     _refreshToken = result['refreshToken'];
  //
  //     _user = await _authService.getCurrentUser(_token!);
  //
  //     // Lưu local
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('auth_token', _token!);
  //     await prefs.setString('refresh_token', _refreshToken!);
  //     await prefs.setString('user_info', jsonEncode(_user!.toJson()));
  //
  //     return true;
  //   } catch (e) {
  //     debugPrint("Lỗi đăng nhập: $e");
  //     return false;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
  // Future<bool> login(String email, String password) async {
  //   try {
  //     _isLoading = true;
  //     notifyListeners();
  //
  //     final result = await _authService.login(email, password);
  //     _token = result['token'];
  //     _refreshToken = result['refreshToken'];
  //
  //
  //     // Song song load user info và SharedPreferences
  //     final results = await Future.wait([
  //       _authService.getCurrentUser(_token!),
  //       SharedPreferences.getInstance(),
  //     ]);
  //
  //     _user = results[0] as UserModel;
  //     final prefs = results[1] as SharedPreferences;
  //
  //     // Lưu  dữ liệu cơ bản
  //     await prefs.setString('auth_token', _token!);
  //     await prefs.setString('refresh_token', _refreshToken!);
  //     await prefs.setString('user_basic', jsonEncode({
  //       'id': _user!.id,
  //       'email': _user!.email,
  //       'role': _user!.role,
  //     }));
  //
  //     return true;
  //   } catch (e) {
  //     debugPrint("Lỗi đăng nhập: $e");
  //     return false;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _authService.login(email, password);
      _token = result['token'];
      _refreshToken = result['refreshToken'];

      // Song song load user info và SharedPreferences
      final results = await Future.wait([
        _authService.getCurrentUser(_token!),
        SharedPreferences.getInstance(),
      ]);

      _user = results[0] as UserModel;
      final prefs = results[1] as SharedPreferences;

      //  Chặn không cho đăng nhập nếu không phải tài xế
      if (_user!.role != 'tai_xe') {
        throw Exception("Tài khoản không có quyền truy cập ứng dụng tài xế");
      }

      // Lưu local
      await prefs.setString('auth_token', _token!);
      await prefs.setString('refresh_token', _refreshToken!);
      await prefs.setString(
        'user_basic',
        jsonEncode({
          'id': _user!.id,
          'email': _user!.email,
          'role': _user!.role,
        }),
      );

      return true;
    } catch (e) {
      debugPrint("Lỗi đăng nhập: $e");
      rethrow; //  ném lại lỗi để LoginPage bắt được
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  // Future<bool> tryAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('auth_token')) return false;
  //
  //   _token = prefs.getString('auth_token');
  //   _refreshToken = prefs.getString('refresh_token');
  //   final userJson = prefs.getString('user_info');
  //
  //   if (userJson != null) {
  //     final parsed = jsonDecode(userJson);
  //
  //
  //     _user = UserModel.fromJson(parsed);
  //   } else if (_token != null) {
  //     _user = await _authService.getCurrentUser(_token!);
  //     if (_user != null) {
  //       await prefs.setString('user_info', jsonEncode(_user!.toJson()));
  //     }
  //   }
  //
  //   notifyListeners();
  //   return true;
  // }
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token == null) return false;

    final userJson = prefs.getString('user_basic');
    if (userJson != null) {
      _user = UserModel.fromJson(jsonDecode(userJson));
      notifyListeners();
      // Gọi load chi tiết sau 1s (async)
      Future.delayed(const Duration(seconds: 1), () async {
        final updatedUser = await _authService.getCurrentUser(_token!);
        _user = updatedUser;
        notifyListeners();
      });
      return true;
    }

    return false;
  }


  Future<void> logout() async {
    _token = null;
    _refreshToken = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_info');

    notifyListeners();
  }
  // Future<bool> changePassword({
  //   required String oldPassword,
  //   required String newPassword,
  // }) async {
  //   if (_token == null) {
  //     debugPrint(" Không có token, người dùng chưa đăng nhập");
  //     return false;
  //   }
  //
  //   try {
  //     _isLoading = true;
  //     notifyListeners();
  //
  //     final result = await _authService.changePassword(
  //       token: _token!,
  //       oldPassword: oldPassword,
  //       newPassword: newPassword,
  //     );
  //
  //     if (result) {
  //       debugPrint(" Đổi mật khẩu thành công");
  //       return true;
  //     } else {
  //       debugPrint(" Đổi mật khẩu thất bại");
  //       return false;
  //     }
  //   } catch (e) {
  //     debugPrint("Lỗi đổi mật khẩu: $e");
  //     rethrow; // Cho phép UI bắt và hiển thị thông báo lỗi chi tiết
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (_token == null) {
      debugPrint(" Không có token, người dùng chưa đăng nhập");
      return false;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final success = await _authService.changePassword(
        token: _token!,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (success) {
        debugPrint(" Đổi mật khẩu thành công");
        return true;
      } else {
        debugPrint(" Đổi mật khẩu thất bại");
        return false;
      }
    } catch (e) {
      debugPrint("Lỗi đổi mật khẩu: $e");
      rethrow; // để UI hiển thị lỗi chi tiết
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> fetchSchedule() async {
    if (_token == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      _schedule = await _authService.getDriverSchedule(_token!);
    } catch (e) {
      debugPrint("Lỗi khi tải lịch trình: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  //moi
  Future<bool> updateBusState(String xeId, String state) async {
    if (_token == null) {
      debugPrint(" Không có token, không thể cập nhật trạng thái");
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final success = await _authService.updateBusState(
        token: _token!,
        xeId: xeId,
        state: state,
      );
      return success;
    } catch (e) {
      debugPrint("Lỗi khi cập nhật trạng thái xe: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  }

