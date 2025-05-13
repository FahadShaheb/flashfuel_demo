import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> signUp(String email, String password, Map<String, String> vehicleInfo) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _db.collection('users').doc(credential.user!.uid).set({
      'email': email,
      ...vehicleInfo,
    });
    return credential.user;
  }

  Future<User?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
