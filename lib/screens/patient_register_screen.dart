import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientRegisterScreen extends StatefulWidget {
  final String doctorId;

  const PatientRegisterScreen({super.key, required this.doctorId});

  @override
  State<PatientRegisterScreen> createState() =>
      _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  Future<void> registerPatient() async {
    setState(() => loading = true);

    try {
      UserCredential cred =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('patients')
          .doc(cred.user!.uid)
          .set({
        "name": nameController.text.trim(),
        "age": int.parse(ageController.text.trim()),
        "phone": phoneController.text.trim(),
        "email": emailController.text.trim(),
        "doctorId": widget.doctorId,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Patient Registered")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patient Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Patient Name")),
            TextField(controller: ageController, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : registerPatient,
              child: loading ? const CircularProgressIndicator() : const Text("Register Patient"),
            )
          ],
        ),
      ),
    );
  }
}
