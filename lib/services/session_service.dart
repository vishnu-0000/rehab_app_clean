import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sensor_data.dart';

class SessionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? currentSessionId;

  Future<void> startSession(String patientId, String mode) async {
    final doc = await _db
        .collection('patients')
        .doc(patientId)
        .collection('sessions')
        .add({
      'mode': mode,
      'startTime': Timestamp.now(),
      'endTime': null,
    });

    currentSessionId = doc.id;
  }

  Future<void> stopSession(String patientId) async {
    if (currentSessionId == null) return;

    await _db
        .collection('patients')
        .doc(patientId)
        .collection('sessions')
        .doc(currentSessionId)
        .update({
      'endTime': Timestamp.now(),
    });

    currentSessionId = null;
  }

  Future<void> addSensorData(
      String patientId, SensorData data) async {
    if (currentSessionId == null) return;

    await _db
        .collection('patients')
        .doc(patientId)
        .collection('sessions')
        .doc(currentSessionId)
        .collection('sensorData')
        .add({
      'flex1': data.flex1,
      'flex2': data.flex2,
      'flex3': data.flex3,
      'fsr': data.fsr,
      'heartRate': data.heartRate,
      'timestamp': Timestamp.now(),
    });
  }
}
