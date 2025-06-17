// lib/utils/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // --- WARNA UNTUK LIGHT THEME ---
  static const Color lightPrimaryColor = Color(0xFFFFA000);   // Firebase Amber
  static const Color lightSecondaryColor = Color(0xFF1976D2); // Firebase Blue
  static const Color lightBackgroundColor = Color(0xFFF5F7FA); // Off-white
  static const Color lightTextColor = Color(0xFF37474F);       // Dark Blue Grey
  static const Color lightStatusAlert = Color(0xFFD32F2F);
  static const Color lightStatusNormal = Color(0xFF388E3C);

  static final BoxDecoration lightBackgroundGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        lightSecondaryColor.withOpacity(0.5),
        const Color(0xFF673AB7).withOpacity(0.3),
        lightPrimaryColor.withOpacity(0.5),
      ],
    ),
  );

  // --- WARNA UNTUK DARK THEME ---
  static const Color darkPrimaryColor = Color(0xFFFFCA28);   // Firebase Amber (lebih cerah)
  static const Color darkSecondaryColor = Color(0xFF64B5F6); // Firebase Blue (lebih cerah)
  static const Color darkBackgroundColor = Color(0xFF121212); // Almost black
  static const Color darkTextColor = Color(0xFFE0E0E0);       // Off-white text
  static const Color darkGlassColor = Color(0xFF212121);      // Warna kaca gelap
  static const Color darkStatusAlert = Color(0xFFEF5350);
  static const Color darkStatusNormal = Color(0xFF66BB6A);
  
  static final BoxDecoration darkBackgroundGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF0D47A1).withOpacity(0.8), // Darker blue
        const Color(0xFF4A148C).withOpacity(0.7), // Darker purple
        darkBackgroundColor,
      ],
    ),
  );

  // Define color
  static const Color lightWarningColor = Color(0xFFFFA726);
  static const Color darkWarningColor = Color(0xFFFFB74D);

  // --- DEFINISI TEMA LIGHT ---
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimaryColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.light(
        primary: lightPrimaryColor,
        secondary: lightSecondaryColor,
        error: lightStatusAlert,
        onPrimary: Colors.black87,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: lightTextColor),
        titleTextStyle: TextStyle(
          color: lightTextColor, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Poppins'
        ),
      ),
      elevatedButtonTheme: _getElevatedButtonTheme(lightPrimaryColor),
    );
  }

  // --- DEFINISI TEMA DARK ---
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.dark(
        primary: darkPrimaryColor,
        secondary: darkSecondaryColor,
        error: darkStatusAlert,
        onPrimary: Colors.black,
        surface: darkGlassColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextColor),
        titleTextStyle: TextStyle(
          color: darkTextColor, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Poppins'
        ),
      ),
      elevatedButtonTheme: _getElevatedButtonTheme(darkPrimaryColor),
    );
  }

  static ElevatedButtonThemeData _getElevatedButtonTheme(Color primary) {
     return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black87,
          elevation: 5,
          shadowColor: primary.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20)
        ),
      );
  }
}