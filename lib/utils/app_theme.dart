// lib/utils/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Firebase Inspired Color Palette
  static const Color primaryColor = Color(0xFFFFA000);   // Firebase Amber
  static const Color secondaryColor = Color(0xFF1976D2); // Firebase Blue
  static const Color backgroundColor = Color(0xFFF5F7FA); // Off-white
  static const Color textColor = Color(0xFF37474F);       // Dark Blue Grey
  static const Color statusAlert = Color(0xFFD32F2F);     // Red
  static const Color statusNormal = Color(0xFF388E3C);    // Green

  // Background Gradient
  static final BoxDecoration backgroundGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        secondaryColor.withOpacity(0.5),
        const Color(0xFF673AB7).withOpacity(0.3), // A hint of purple
        primaryColor.withOpacity(0.5),
      ],
    ),
  );

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Poppins',
      
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: statusAlert,
        onPrimary: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins'
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: primaryColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20)
        ),
      ),
    );
  }
}