class SensorData {
  final double flex1;
  final double flex2;
  final double flex3;
  final double fsr;
  final int heartRate;

  SensorData({
    required this.flex1,
    required this.flex2,
    required this.flex3,
    required this.fsr,
    required this.heartRate,
  });

  factory SensorData.mock() {
    return SensorData(
      flex1: 45,
      flex2: 50,
      flex3: 40,
      fsr: 1.8,
      heartRate: 78,
    );
  }
}
