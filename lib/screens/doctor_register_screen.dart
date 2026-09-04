import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});

  @override
  State<DoctorRegisterScreen> createState() =>
      _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController regNoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  void registerDoctor() async {
    setState(() => loading = true);

    try {
      await _authService.registerDoctor(
        name: nameController.text.trim(),
        hospital: hospitalController.text.trim(),
        regNo: regNoController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Doctor registered successfully")),
      );

      // Clear fields
      nameController.clear();
      hospitalController.clear();
      regNoController.clear();
      phoneController.clear();
      emailController.clear();
      passwordController.clear();
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
      appBar: AppBar(title: const Text("Doctor Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Doctor Name"),
            ),
            TextField(
              controller: hospitalController,
              decoration: const InputDecoration(labelText: "Hospital Name"),
            ),
            TextField(
              controller: regNoController,
              decoration:
              const InputDecoration(labelText: "Medical Council Reg No"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : registerDoctor,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Register Doctor"),
            ),
          ],
        ),
      ),
    );
  }
}
