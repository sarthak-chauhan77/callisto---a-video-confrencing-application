import 'package:flutter/material.dart';

class JoinMeetingScreen extends StatelessWidget {
  const JoinMeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Meeting'),
        backgroundColor: const Color.fromARGB(105, 146, 58, 184),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2B2E4A), Color(0xFF1B1D2F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Background Design Elements
          Positioned(
            top: -50,
            right: -50,
            child: Opacity(
              opacity: 0.2,
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Opacity(
              opacity: 0.2,
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            child: Opacity(
              opacity: 0.2,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 0,
            child: Opacity(
              opacity: 0.2,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
          // Main Content
          const Center(
            child: Text(
              'Join Meeting Screen',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
