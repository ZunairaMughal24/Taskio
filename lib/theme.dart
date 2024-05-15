import 'package:flutter/material.dart';

enum ThemeType { light, dark }

class ThemeProvider extends ChangeNotifier {
  final ThemeData _lightTheme = ThemeData.light().copyWith(
    // Override text theme to keep text color black
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );

  final ThemeData _darkTheme = ThemeData.dark().copyWith(
    // Override text theme to make text color white
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );

  ThemeData _selectedTheme = ThemeData.light();

  ThemeData getTheme() => _selectedTheme;

  void setTheme(ThemeType themeType) {
    _selectedTheme = themeType == ThemeType.light ? _lightTheme : _darkTheme;
    notifyListeners();
  }
}
