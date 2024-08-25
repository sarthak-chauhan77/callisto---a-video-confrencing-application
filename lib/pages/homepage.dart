import 'package:callisto/screens/history_screen.dart';
import 'package:callisto/screens/meeting_screen.dart';
import 'package:callisto/screens/recording_screen.dart';
import 'package:callisto/screens/setting_screen.dart';
import 'package:callisto/theme/theme.dart';
import 'package:callisto/userPanel/userLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemNavigator
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  final User? user;

  const Homepage({super.key, required this.user});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  void _updateUser(User updatedUser) {
    setState(() {
      _user = updatedUser;
    });
  }

  Future<bool> _onWillPop() async {
    print('Back button pressed');
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  print('Cancel pressed');
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  print('Exit pressed');
                  SystemNavigator.pop(); // Close the app
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeTheme(ThemeMode mode) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    themeNotifier.setThemeMode(mode);
  }

  void _onLogout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Callisto'),
          backgroundColor: isDarkMode
              ? const Color.fromARGB(105, 146, 58, 184) // Dark theme color
              : const Color(0xFF1B1D2F), // Light theme color
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.black,
                ), // Black background for the header
                child: UserAccountsDrawerHeader(
                  accountName: Text(
                    _user?.displayName ?? 'Guest',
                    style: const TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    _user?.email ?? 'Not logged in',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: _user != null
                        ? ClipOval(
                            child: Image.network(_user!.photoURL ?? '',
                                fit: BoxFit.cover),
                          )
                        : const Icon(Icons.account_circle, size: 50),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home,
                    color: isDarkMode ? Colors.white : Colors.black),
                title: Text('Home',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Homepage(user: _user)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings,
                    color: isDarkMode ? Colors.white : Colors.black),
                title: Text('Settings',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingScreen()),
                  );
                },
              ),
              const Spacer(), // Push logout and terms to the bottom
              ListTile(
                leading: Icon(Icons.policy,
                    color: isDarkMode ? Colors.white : Colors.black),
                title: Text('Terms and Conditions',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Terms and Conditions'),
                      content: const Text(
                        'Here are the terms and conditions of the application. By using the app, you agree to abide by these terms. If you have any questions or concerns, please contact support.',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout,
                    color: isDarkMode ? Colors.white : Colors.black),
                title: Text('Logout',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black)),
                onTap: _onLogout,
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            const MeetingScreen(),
            HistoryScreen(),
            const RecordingScreen(),
            const SettingScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.video_call),
              label: 'Meetings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: 'Recordings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
