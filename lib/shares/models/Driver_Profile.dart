class TaiXeInfo {
  final String xeId;
  final String bienso;
  final String tuyen;
  final int sucChua;
  final String mabanglai;

  TaiXeInfo({
    required this.xeId,
    required this.bienso,
    required this.tuyen,
    required this.sucChua,
    required this.mabanglai,
  });

  factory TaiXeInfo.fromJson(Map<String, dynamic> json) {
    final xeData = json['xe_id'] ?? {}; // Lấy object xe_id bên trong

    return TaiXeInfo(
      xeId: xeData['xe_id'] ?? '',
      bienso: xeData['bienso'] ?? '',
      tuyen: xeData['tuyen'] ?? '',
      sucChua: xeData['suc_chua'] ?? 0,
      mabanglai: json['mabanglai'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'xe_id': {
        'xe_id': xeId,
        'bienso': bienso,
        'tuyen': tuyen,
        'suc_chua': sucChua,
      },
      'mabanglai': mabanglai,
    };
  }
}
