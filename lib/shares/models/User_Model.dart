
import 'User_Profile.dart';
import 'Driver_Profile.dart';

class UserModel {
  final String id;
  final String email;
  final String role;
  final bool isVerified;
  final UserProfile profile;
  final TaiXeInfo? taiXeInfo; // Thêm thuộc tính tài xế (nếu có)

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.profile,
    this.taiXeInfo, //  cho phép null nếu không phải tài xế
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isVerified: json['isVerified'] ?? false,
      profile: UserProfile.fromJson(json['profile'] ?? {}),
      taiXeInfo: json['tai_xe_info'] != null
          ? TaiXeInfo.fromJson(json['tai_xe_info'])
          : null, //  chỉ parse nếu có
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'role': role,
      'isVerified': isVerified,
      'profile': profile.toJson(),
      if (taiXeInfo != null) 'tai_xe_info': taiXeInfo!.toJson(), //  chỉ thêm nếu có
    };
  }
}
