import 'dart:math';

import 'package:callisto/screens/video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class StartMeetingScreen extends StatefulWidget {
  const StartMeetingScreen({super.key});

  @override
  _StartMeetingScreenState createState() => _StartMeetingScreenState();
}

class _StartMeetingScreenState extends State<StartMeetingScreen> {
  String meetingCode = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    meetingCode = _generateMeetingCode();
  }

  String _generateMeetingCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  void _copyCodeToClipboard() {
    final data = ClipboardData(text: meetingCode);
    Clipboard.setData(data);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meeting code copied to clipboard!')),
    );
  }

  void _shareInvite() {
    final meetingLink = 'https://example.com/meeting/$meetingCode';

    Share.share(
      'Join my meeting using the following link: $meetingLink',
      subject: 'Meeting Invite',
    );
  }

  Future<void> _promptForNameAndStartMeeting() async {
    final nameController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Your Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Your Name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(nameController.text),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        userName = result;
      });
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => VideoCallScreen(
            meetingCode: meetingCode,
            userName: userName,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start Meeting"),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(105, 146, 58, 184),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2B2E4A),
              Color(0xFF1B1D2F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: meetingCode,
                readOnly: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _copyCodeToClipboard,
                  ),
                ),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _shareInvite,
                icon: const Icon(Icons.share),
                label: const Text('Share Invite'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  backgroundColor: const Color.fromARGB(105, 146, 58, 184),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _promptForNameAndStartMeeting,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  backgroundColor: const Color.fromARGB(105, 146, 58, 184),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Start Meeting',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
