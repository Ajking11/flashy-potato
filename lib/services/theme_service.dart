// theme_service.dart
import 'package:flutter/material.dart';
import '../constants.dart';

class ThemeService {
  // Light theme
  static ThemeData getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: costaRed,
      scaffoldBackgroundColor: italianPorcelain,
      colorScheme: const ColorScheme.light(
        primary: costaRed,
        secondary: accentRed,
        surface: italianPorcelain, // Changed from background to surface
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: costaRed,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      // Add other theme properties as needed
    );
  }
}