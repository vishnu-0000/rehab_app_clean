import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

import 'session_history_screen.dart';
import 'live_line_chart.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  bool sessionActive = false;

  final String patientId = FirebaseAuth.instance.currentUser!.uid;
  String? sessionId;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DatabaseReference liveRef =
  FirebaseDatabase.instance.ref("liveData");

  // ---- GRAPH DATA ----
  List<FlSpot> flex1Points = [];
  int graphX = 0;

  // ---- SESSION CONTROL ----
  Future<void> startSession(String mode) async {
    final doc = await firestore
        .collection('patients')
        .doc(patientId)
        .collection('sessions')
        .add({
      'mode': mode,
      'startTime': Timestamp.now(),
      'endTime': null,
    });

    setState(() {
      sessionActive = true;
      sessionId = doc.id;
    });
  }

  Future<void> stopSession() async {
    if (sessionId == null) return;

    await firestore
        .collection('patients')
        .doc(patientId)
        .collection('sessions')
        .doc(sessionId)
        .update({'endTime': Timestamp.now()});

    setState(() {
      sessionActive = false;
      sessionId = null;
    });
  }

  // ---- SAVE LIVE DATA INTO SESSION ----
  Future<void> saveLiveData(Map<String, dynamic> data) async {
    if (!sessionActive || sessionId == null) return;

    await firestore
        .collection('patients')
        .doc(patientId)
        .collection('sessions')
        .doc(sessionId)
        .collection('sensorData')
        .add({
      ...data,
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patient Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<DocumentSnapshot>(
          stream: firestore
              .collection('patients')
              .doc(patientId)
              .snapshots(),
          builder: (context, patientSnapshot) {
            if (!patientSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final patientData =
            patientSnapshot.data!.data() as Map<String, dynamic>;

            final String mode =
                patientData['currentMode'] ?? "Passive";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- MODE DISPLAY (READ ONLY) ----
                Text(
                  "Current Mode: $mode",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  sessionActive
                      ? "SESSION ACTIVE"
                      : "SESSION STOPPED",
                  style: TextStyle(
                    fontSize: 16,
                    color:
                    sessionActive ? Colors.green : Colors.red,
                  ),
                ),

                const SizedBox(height: 10),

                // ---- START / STOP BUTTONS ----
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: sessionActive
                            ? null
                            : () => startSession(mode),
                        child: const Text("Start Session"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                        sessionActive ? stopSession : null,
                        child: const Text("Stop Session"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "Live Sensor Data",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // ---- LIVE SENSOR STREAM ----
                Expanded(
                  child: StreamBuilder<DatabaseEvent>(
                    stream: liveRef.onValue,
                    builder: (context, snapshot) {
                      final raw =
                          snapshot.data?.snapshot.value;

                      if (raw == null || raw is! Map) {
                        return const Center(
                          child: Text(
                              "Waiting for ESP32 data..."),
                        );
                      }

                      final Map<String, dynamic> data =
                      Map<String, dynamic>.from(raw);

                      // ---- GRAPH UPDATE ----
                      final double flex1 =
                      (data['flex1'] ?? 0).toDouble();

                      flex1Points.add(
                        FlSpot(
                          graphX.toDouble(),
                          flex1,
                        ),
                      );
                      graphX++;

                      if (flex1Points.length > 50) {
                        flex1Points.removeAt(0);
                      }

                      // ---- SAVE DATA TO FIRESTORE ----
                      saveLiveData(data);

                      return ListView(
                        children: [
                          dataTile(
                              "Flex 1", data['flex1']),
                          dataTile(
                              "Flex 2", data['flex2']),
                          dataTile(
                              "Flex 3", data['flex3']),
                          dataTile("FSR", data['fsr']),
                          dataTile("Heart Rate",
                              data['heartRate']),

                          const SizedBox(height: 20),

                          // ---- LIVE GRAPH ----
                          LiveLineChart(
                            points: flex1Points,
                            label:
                            "Flex Sensor 1 (Live)",
                          ),
                        ],
                      );
                    },
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SessionHistoryScreen(
                                patientId: patientId),
                      ),
                    );
                  },
                  child:
                  const Text("View Session History"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget dataTile(String label, dynamic value) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(
          value.toString(),
          style:
          const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
