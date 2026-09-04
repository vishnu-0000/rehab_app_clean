import 'dart:async';
import '../models/sensor_data.dart';

class HardwareService {
  // 🔴 Stream controller (real-time data pipe)
  final StreamController<SensorData> _controller =
  StreamController<SensorData>.broadcast();

  Stream<SensorData> get sensorStream => _controller.stream;

  // 🧪 TEMP: simulated data
  // Later → replace this with ESP32 input
  void startListening() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _controller.add(
        SensorData(
          flex: 45 + timer.tick % 10,
          emg: 300 + timer.tick % 20,
          fsr: 1.2,
          imu: 15,
          heartRate: 75,
          spo2: 97,
        ),
      );
    });
  }

  void stopListening() {
    _controller.close();
  }
}

