import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionHistoryScreen extends StatelessWidget {
  final String patientId;

  const SessionHistoryScreen({
    super.key,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Session History"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('patients')
            .doc(patientId)
            .collection('sessions')
            .orderBy('startTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No sessions available"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data =
              snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(Icons.history),
                title: Text("Mode: ${data['mode']}"),
                subtitle: Text(
                  "Start: ${data['startTime'].toDate()}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
