import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerDoctor({
    required String name,
    required String hospital,
    required String regNo,
    required String phone,
    required String email,
    required String password,
  }) async {
    // CREATE AUTH USER
    UserCredential userCredential =
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String uid = userCredential.user!.uid;

    // SAVE DOCTOR DATA
    await _firestore.collection('doctors').doc(uid).set({
      "name": name,
      "hospital": hospital,
      "registrationNo": regNo,
      "phone": phone,
      "email": email,
      "role": "doctor",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
