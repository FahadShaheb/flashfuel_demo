import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _plateNumberController = TextEditingController();
  bool _loading = false;
  String _error = '';

  Future<void> _signup() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': _emailController.text.trim(),
        'vehicleType': _vehicleTypeController.text.trim(),
        'vehicleModel': _vehicleModelController.text.trim(),
        'plateNumber': _plateNumberController.text.trim(),
      });

      // Navigate to home or login
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      setState(() {
        _error = 'Signup failed. Please try again.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
              TextField(controller: _vehicleTypeController, decoration: const InputDecoration(labelText: 'Vehicle Type')),
              TextField(controller: _vehicleModelController, decoration: const InputDecoration(labelText: 'Vehicle Model')),
              TextField(controller: _plateNumberController, decoration: const InputDecoration(labelText: 'Plate Number')),
              if (_error.isNotEmpty) Text(_error, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _signup,
                child: _loading ? const CircularProgressIndicator() : const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
