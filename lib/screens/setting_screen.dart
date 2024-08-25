import 'package:callisto/theme/theme.dart';
import 'package:callisto/userPanel/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this package to your pubspec.yaml

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(105, 146, 58, 184)
            : const Color(0xFF1B1D2F),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? null : Colors.white,
          gradient: isDarkMode
              ? const LinearGradient(
                  colors: [Color(0xFF1B1D2F), Color(0xFF2B2E4A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.brightness_6,
                  color: isDarkMode ? Colors.white : Colors.black),
              title: Text('Theme',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black)),
              subtitle: Text('Choose light or dark mode',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54)),
              onTap: () {
                _showThemeSelectionDialog(context);
              },
            ),
            Divider(color: isDarkMode ? Colors.white24 : Colors.black12),
            ListTile(
              leading: Icon(Icons.notifications,
                  color: isDarkMode ? Colors.white : Colors.black),
              title: Text('Notifications',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black)),
              subtitle: Text('Manage notification settings',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54)),
              onTap: () {
                _showNotificationSettingsDialog(context);
              },
            ),
            Divider(color: isDarkMode ? Colors.white24 : Colors.black12),
            ListTile(
              leading: Icon(Icons.lock,
                  color: isDarkMode ? Colors.white : Colors.black),
              title: Text('Privacy',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black)),
              subtitle: Text('Privacy and security options',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54)),
              onTap: () {
                // Navigate to privacy settings
              },
            ),
            Divider(color: isDarkMode ? Colors.white24 : Colors.black12),
            // Inside SettingScreen class
            ListTile(
              leading: Icon(Icons.account_circle,
                  color: isDarkMode ? Colors.white : Colors.black),
              title: Text('Account',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black)),
              subtitle: Text('Manage your account',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserProfileScreen()),
                );
              },
            ),

            Divider(color: isDarkMode ? Colors.white24 : Colors.black12),
            ListTile(
              leading: Icon(Icons.help,
                  color: isDarkMode ? Colors.white : Colors.black),
              title: Text('Help & Support',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black)),
              subtitle: Text('Get help or provide feedback',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54)),
              onTap: () {
                _showHelpAndSupportDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Light Theme'),
                onTap: () {
                  _changeTheme(context, ThemeMode.light);
                },
              ),
              ListTile(
                title: const Text('Dark Theme'),
                onTap: () {
                  _changeTheme(context, ThemeMode.dark);
                },
              ),
              ListTile(
                title: const Text('System Default'),
                onTap: () {
                  _changeTheme(context, ThemeMode.system);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeTheme(BuildContext context, ThemeMode mode) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    themeNotifier.setThemeMode(mode);
    Navigator.pop(context);
  }

  void _showNotificationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notification Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Enable Notifications'),
                value: true, // Add logic to manage notification toggle
                onChanged: (bool value) {
                  // Handle notification enable/disable
                },
              ),
              SwitchListTile(
                title: const Text('Receive Meeting Reminders'),
                value: true, // Add logic for meeting reminders
                onChanged: (bool value) {
                  // Handle meeting reminder toggle
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelpAndSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'If you need assistance or have any issues, please reach out to us at:'),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _sendEmail();
                },
                child: const Text(
                  'sarthakc981@gmail.com',
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                  'Or, you can check our FAQ section for common issues and solutions.'),
            ],
          ),
        );
      },
    );
  }

  void _sendEmail() async {
    final url = Uri.parse(
        'mailto:sarthakc981@gmail.com?subject=Help & Support Request');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
