import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark mode

  ThemeNotifier() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();

    // Save the theme mode to persistent storage
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('themeMode', themeMode.toString().split('.').last);
    } catch (e) {
      // Handle error
      print('Failed to save theme mode: $e');
    }
  }

  Future<void> _loadThemeMode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? themeString = prefs.getString('themeMode');
      if (themeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString().split('.').last == themeString,
          orElse: () => ThemeMode.dark, // Default to dark mode
        );
      }
    } catch (e) {
      // Handle error
      print('Failed to load theme mode: $e');
    }
    // Notify listeners after theme mode is loaded
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    return _themeMode;
  }
}
