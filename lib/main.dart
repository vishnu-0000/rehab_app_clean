import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'screens/role_select_screen.dart';
import 'screens/doctor_dashboard.dart';
import 'screens/patient_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RehabApp());
}

class RehabApp extends StatelessWidget {
  const RehabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rehab App',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnap) {
          if (authSnap.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (!authSnap.hasData) {
            return const RoleSelectScreen();
          }

          final uid = authSnap.data!.uid;

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .snapshots(),
            builder: (context, userSnap) {
              if (!userSnap.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final role = userSnap.data!['role'];

              if (role == 'doctor') {
                return const DoctorDashboard();
              } else {
                return const PatientDashboard();
              }
            },
          );
        },
      ),
    );
  }
}
