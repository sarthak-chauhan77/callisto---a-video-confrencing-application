import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoCallScreen extends StatefulWidget {
  final String meetingCode;
  final String userName;

  const VideoCallScreen({
    super.key,
    required this.meetingCode,
    required this.userName,
  });

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RTCPeerConnection _peerConnection;
  late MediaStream _localStream;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  bool isMuted = false;
  bool isCameraOff = false;
  bool isChatOpen = false;
  bool showReactions = false;
  final List<String> _messages = [];
  final _messageController = TextEditingController();
  String _userName = '';
  late DateTime startTime;

  @override
  void initState() {
    super.initState();
    _initWebRTC();
    _userName = widget.userName;
    startTime = DateTime.now();
  }

  Future<void> _initWebRTC() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
      'sdpSemantics': 'unified-plan',
    };
    _peerConnection = await createPeerConnection(config);

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });

    _localRenderer.srcObject = _localStream;

    _localStream.getTracks().forEach((track) {
      _peerConnection.addTrack(track, _localStream);
    });

    _peerConnection.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video' && event.streams.isNotEmpty) {
        setState(() {
          _remoteRenderer.srcObject = event.streams[0];
        });
      }
    };
  }

  Future<void> _endMeeting() async {
    DateTime endTime = DateTime.now();

    final meetingDetails = {
      'code': widget.meetingCode,
      'startTime': startTime.toString(),
      'endTime': endTime.toString(),
      'userName': widget.userName,
    };

    await _saveMeetingDetails(meetingDetails);

    // Navigate back or close the screen
    Navigator.of(context).pop();
  }

  Future<void> _saveMeetingDetails(Map<String, String> meetingDetails) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the existing list of meetings
    List<String>? meetings = prefs.getStringList('meetings') ?? [];

    // Convert the meeting details to a query string
    final meetingString = Uri(queryParameters: meetingDetails).query;

    // Append the new meeting details
    meetings.add(meetingString);

    // Debugging logs to check the saved meetings
    print("New Meeting Details to Save: $meetingString");
    print("Updated Meetings List: $meetings");

    // Save the updated list back to SharedPreferences
    await prefs.setStringList('meetings', meetings);

    // Verify if the data was successfully saved
    List<String>? savedMeetings = prefs.getStringList('meetings');
    print("Final Saved Meetings in SharedPreferences: $savedMeetings");
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    _localStream.getAudioTracks().forEach((track) {
      track.enabled = !isMuted;
    });
  }

  void _toggleCamera() {
    setState(() {
      isCameraOff = !isCameraOff;
    });
    _localStream.getVideoTracks().forEach((track) {
      track.enabled = !isCameraOff;
    });
  }

  void _openChat() {
    setState(() {
      isChatOpen = !isChatOpen;
    });
  }

  void _showReactions() {
    setState(() {
      showReactions = !showReactions;
    });
  }

  void _shareScreen() {
    // Implement screen sharing functionality here
  }

  void _people() {}

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add('$_userName: ${_messageController.text}');
        _messageController.clear();
      });
    }
  }

  @override
  void dispose() {
    _localStream.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection.close();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
        backgroundColor: const Color.fromARGB(105, 146, 58, 184),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 15, 15, 16), Color(0xFF1B1D2F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    flex: isChatOpen ? 1 : 3,
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: RTCVideoView(_remoteRenderer, mirror: true),
                    ),
                  ),
                  if (isChatOpen)
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Color.fromARGB(105, 63, 34, 75),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                children: _messages
                                    .map((message) => ListTile(
                                          title: Text(
                                            message,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _messageController,
                                      decoration: const InputDecoration(
                                        hintText: 'Type a message',
                                        hintStyle:
                                            TextStyle(color: Colors.white70),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white70),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white70),
                                        ),
                                      ),
                                      style:
                                          const TextStyle(color: Colors.white),
                                      onSubmitted: (_) => _sendMessage(),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.send,
                                        color: brightness == Brightness.dark
                                            ? Colors.white
                                            : Colors.black),
                                    onPressed: _sendMessage,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                width: 100,
                height: 150,
                child: RTCVideoView(_localRenderer, mirror: true),
              ),
            ),
            if (showReactions)
              Positioned(
                bottom: 80,
                left: MediaQuery.of(context).size.width * 0.4,
                child: const Row(
                  children: [
                    Text(
                      "👍",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "❤️",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "😡",
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: _openChat,
                            icon: Icon(Icons.chat,
                                color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                            iconSize: 30,
                          ),
                          IconButton(
                            onPressed: _showReactions,
                            icon: Icon(Icons.emoji_emotions,
                                color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                            iconSize: 30,
                          ),
                          IconButton(
                            onPressed: _toggleMute,
                            icon: Icon(
                              isMuted ? Icons.mic_off : Icons.mic,
                              color: brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            iconSize: 30,
                          ),
                          IconButton(
                            onPressed: _endMeeting,
                            icon: Icon(Icons.call_end, color: Colors.red),
                            iconSize: 50,
                          ),
                          IconButton(
                            onPressed: _toggleCamera,
                            icon: Icon(
                              isCameraOff ? Icons.videocam_off : Icons.videocam,
                              color: brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            iconSize: 30,
                          ),
                          IconButton(
                            onPressed: _shareScreen,
                            icon: Icon(Icons.screen_share,
                                color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                            iconSize: 30,
                          ),
                          IconButton(
                            onPressed: _people,
                            icon: Icon(Icons.group,
                                color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                            iconSize: 30,
                          ),
                        ],
                      ),
                    ),
                    if (isChatOpen)
                      Positioned(
                        bottom: 80,
                        left: MediaQuery.of(context).size.width * 0.1,
                        child: IconButton(
                          onPressed: _openChat,
                          icon: Icon(Icons.chat,
                              color: brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black),
                          iconSize: 30,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
