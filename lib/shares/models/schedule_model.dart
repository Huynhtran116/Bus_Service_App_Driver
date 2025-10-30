class ScheduleModel {
  final String message;
  final String xeId;
  final String codeXe;
  final String tuyen;
  final List<LichTrinh> lichTrinh;
  final int tongHocSinh;

  ScheduleModel({
    required this.message,
    required this.xeId,
    required this.codeXe,
    required this.tuyen,
    required this.lichTrinh,
    required this.tongHocSinh,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      message: json['message'] ?? '',
      xeId: json['xe_id'] ?? '',
      codeXe: json['code_xe'] ?? '',
      tuyen: json['tuyen'] ?? '',
      lichTrinh: (json['lich_trinh'] as List<dynamic>)
          .map((item) => LichTrinh.fromJson(item))
          .toList(),
      tongHocSinh: json['tong_hoc_sinh'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "xe_id": xeId,
      "code_xe": codeXe,
      "tuyen": tuyen,
      "lich_trinh": lichTrinh.map((e) => e.toJson()).toList(),
      "tong_hoc_sinh": tongHocSinh,
    };
  }
}

class LichTrinh {
  final String diaDiem;
  final String hocSinhId;
  final String hoTenHocSinh;
  final String sdtHocSinh;
  final String mahs;
  final String avatar;
  final String lop;
  final String state;
  final PhuHuynh phuHuynh;

  LichTrinh({
    required this.diaDiem,
    required this.hocSinhId,
    required this.hoTenHocSinh,
    required this.sdtHocSinh,
    required this.mahs,
    required this.avatar,
    required this.lop,
    required this.state,
    required this.phuHuynh,
  });

  factory LichTrinh.fromJson(Map<String, dynamic> json) {
    return LichTrinh(
      diaDiem: json['diadiem'] ?? '',
      hocSinhId: json['hoc_sinh_id'] ?? '',
      hoTenHocSinh: json['hoten_hocsinh'] ?? '',
      sdtHocSinh: json['sdt_hocsinh'] ?? '',
      mahs: json['mahs'] ?? '',
      avatar: json['avatar'] ?? '',
      lop: json['lop'] ?? '',
      state: json['state'] ?? '',
      phuHuynh: PhuHuynh.fromJson(json['phu_huynh']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "diadiem": diaDiem,
      "hoc_sinh_id": hocSinhId,
      "hoten_hocsinh": hoTenHocSinh,
      "sdt_hocsinh": sdtHocSinh,
      "mahs": mahs,
      "avatar": avatar,
      "lop": lop,
      "state": state,
      "phu_huynh": phuHuynh.toJson(),
    };
  }
}

class PhuHuynh {
  final String hoTen;
  final String sdt;
  final String quanHe;

  PhuHuynh({
    required this.hoTen,
    required this.sdt,
    required this.quanHe,
  });

  factory PhuHuynh.fromJson(Map<String, dynamic> json) {
    return PhuHuynh(
      hoTen: json['hoten'] ?? '',
      sdt: json['sdt'] ?? '',
      quanHe: json['quanhe'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "hoten": hoTen,
      "sdt": sdt,
      "quanhe": quanHe,
    };
  }
}
