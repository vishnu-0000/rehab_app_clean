import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'doctor_dashboard.dart';
import 'patient_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  Future<void> loginUser() async {
    setState(() {
      loading = true;
    });

    try {
      // 🔹 Firebase Authentication
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // 🔹 Check if doctor
      DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(uid)
          .get();

      if (doctorDoc.exists) {
        // ✅ Doctor login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DoctorDashboard(),
          ),
        );
      } else {
        // ✅ Patient login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PatientDashboard(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: loading ? null : loginUser,
                child: loading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
