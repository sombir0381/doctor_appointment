import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF00A6A6);

  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color textColor = Color(0xFF1F2937);
  static const Color secondaryTextColor = Color(0xFF6B7280);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: backgroundColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: textColor,
      elevation: 0,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),

      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),

      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        color: textColor,
      ),

      bodyMedium: TextStyle(
        fontSize: 14,
        color: secondaryTextColor,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(
          double.infinity,
          52,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
    ),
  );
}