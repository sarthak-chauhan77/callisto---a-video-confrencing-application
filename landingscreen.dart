import 'package:callisto/userPanel/userLogin.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 165, 139, 217),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2B2E4A), Color(0xFF1B1D2F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
                  borderRadius: const BorderRadius.only(
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
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 32.0, vertical: 20.0), // Reduced vertical padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Space between image and welcome note
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 120.0), // Reduced space below the image
                  child: Image.asset(
                    "assets/images/frontpic.png",
                    height: 350, // Increased image height
                    fit: BoxFit.contain,
                  ),
                ),
                // Welcome Note
                Text(
                  "Welcome to Callisto",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                // Space between welcome note and content
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0), // Reduced vertical padding
                  child: Text(
                    "Connect with your team, friends, and family effortlessly with Callisto, your ultimate video conferencing solution.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
                //  const Spacer(), // Pushes the button to the bottom
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 70),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 112, 18, 43),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 16.0),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Reduced spacing below the button
              ],
            ),
          ),
        ],
      ),
    );
  }
}
