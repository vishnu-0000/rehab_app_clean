class LiveData {
  final double flex1, flex2, flex3, fsr;
  final int heartRate;

  LiveData({
    required this.flex1,
    required this.flex2,
    required this.flex3,
    required this.fsr,
    required this.heartRate,
  });

  factory LiveData.fromMap(Map data) {
    return LiveData(
      flex1: (data['flex1'] ?? 0).toDouble(),
      flex2: (data['flex2'] ?? 0).toDouble(),
      flex3: (data['flex3'] ?? 0).toDouble(),
      fsr: (data['fsr'] ?? 0).toDouble(),
      heartRate: data['heartRate'] ?? 0,
    );
  }
}
