class SessionData {
  final double flex1;
  final double flex2;
  final double flex3;
  final double fsr;
  final int heartRate;
  final Map<String, int> imu;

  SessionData({
    required this.flex1,
    required this.flex2,
    required this.flex3,
    required this.fsr,
    required this.heartRate,
    required this.imu,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      flex1: json['flex1'].toDouble(),
      flex2: json['flex2'].toDouble(),
      flex3: json['flex3'].toDouble(),
      fsr: json['fsr'].toDouble(),
      heartRate: json['heartRateRaw'],
      imu: Map<String, int>.from(json['imu']),
    );
  }
}
