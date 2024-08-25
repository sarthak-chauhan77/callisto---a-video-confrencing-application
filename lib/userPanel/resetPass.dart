import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _sendPasswordResetEmail() async {
    if (_emailController.text.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
        Navigator.pop(context); // Go back to the previous page
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Email does not exist. Please enter a valid email address.'),
              ),
            );
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1D2F), // Updated background color
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2B2E4A),
                  Color(0xFF1B1D2F)
                ], // Gradient update
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color:
                      Color(0xFF2B2E4A), // Updated container background color
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Updated text color
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email address',
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                  255, 251, 251, 251), // Updated label color
                            ),
                            hintStyle: TextStyle(
                                color: Colors.white70), // Updated hint color
                          ),
                          style: const TextStyle(
                              color: Colors.white), // Updated input text color
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _sendPasswordResetEmail,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                            backgroundColor: const Color.fromARGB(
                                255, 112, 49, 128), // Updated button color
                          ),
                          child: const Text('Send Password Reset Email'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
