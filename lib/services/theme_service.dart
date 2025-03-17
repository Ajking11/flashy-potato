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
      colorScheme: ColorScheme.light(
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

  // Dark theme
  static ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: costaRed,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.dark(
        primary: costaRed,
        secondary: accentRed,
        surface: const Color(0xFF121212), // Changed from background to surface
        // You can still set surface specifically if needed
        // surface: const Color(0xFF1E1E1E),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF2C2C2C),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
      ),
      // Add other theme properties as needed
    );
  }
}