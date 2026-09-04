import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/report_service.dart';

class PatientProfileScreen extends StatelessWidget {
  final Map<String, dynamic> patientData;

  const PatientProfileScreen({
    super.key,
    required this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    final String patientId = patientData['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('patients')
              .doc(patientId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator());
            }

            final data =
            snapshot.data!.data() as Map<String, dynamic>;

            final String currentMode =
                data['currentMode'] ?? "Passive";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${data['name']}"),
                Text("Age: ${data['age']}"),
                Text("Phone: ${data['phone']}"),
                Text("Email: ${data['email']}"),

                const SizedBox(height: 24),

                const Text(
                  "Rehabilitation Mode (Doctor Controlled)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                DropdownButton<String>(
                  value: currentMode,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: "Passive",
                      child: Text("Passive Mode"),
                    ),
                    DropdownMenuItem(
                      value: "Active",
                      child: Text("Active Mode"),
                    ),
                  ],
                  onChanged: (value) {
                    FirebaseFirestore.instance
                        .collection('patients')
                        .doc(patientId)
                        .update({
                      'currentMode': value,
                    });
                  },
                ),

                const SizedBox(height: 30),

                // ---- PDF REPORT BUTTON (DOCTOR ONLY) ----
                ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label:
                  const Text("Generate Rehab Report (PDF)"),
                  onPressed: () {
                    ReportService.generateRehabReport(
                      patientName: data['name'],
                      mode: currentMode,
                      fmaScore: 42.0, // placeholder (AI later)
                      duration: 20,   // placeholder
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
