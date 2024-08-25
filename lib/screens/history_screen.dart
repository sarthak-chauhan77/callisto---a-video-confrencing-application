import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, String>> _meetingHistory = [];

  @override
  void initState() {
    super.initState();
    _loadMeetingHistory();
  }

  Future<void> _loadMeetingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? meetings = prefs.getStringList('meetings');
    print("Retrieved Meetings from SharedPreferences: $meetings");

    if (meetings != null) {
      setState(() {
        _meetingHistory = meetings.map((meetingString) {
          return Uri.splitQueryString(meetingString);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Call History'),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(105, 146, 58, 184) // Dark theme color
            : const Color(0xFF1B1D2F), // Light theme color
      ),
      backgroundColor: isDarkMode ? null : Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  colors: [Color(0xFF1B1D2F), Color(0xFF2B2E4A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: _meetingHistory.isEmpty
            ? const Center(child: Text('No call history available'))
            : ListView.builder(
                itemCount: _meetingHistory.length,
                itemBuilder: (context, index) {
                  final meeting = _meetingHistory[index];
                  return ListTile(
                    title: Text('Meeting Code: ${meeting['code']}'),
                    subtitle: Text(
                        'Start Time: ${meeting['startTime']}\nEnd Time: ${meeting['endTime']}'),
                    trailing: Text('User: ${meeting['userName']}'),
                  );
                },
              ),
      ),
    );
  }
}
