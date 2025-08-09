import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color deepBlue = Color(0xFF1E3A8A);
  static const Color cyberYellow = Color(0xFFFFD700);
  static const Color graphiteBlack = Color(0xFF1F2937);
  
  // Supporting Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF3F4F6);
  static const Color mediumGray = Color(0xFF6B7280);
  static const Color darkGray = Color(0xFF374151);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}

class AppFonts {
  static const String poppins = 'Roboto'; // Default system font
  static const String jetBrainsMono = 'monospace'; // Default monospace font
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.deepBlue,
        secondary: AppColors.cyberYellow,
        surface: AppColors.white,
        background: AppColors.lightGray,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.graphiteBlack,
        onSurface: AppColors.graphiteBlack,
        onBackground: AppColors.graphiteBlack,
        onError: AppColors.white,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.graphiteBlack,
        ),
        displayMedium: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.graphiteBlack,
        ),
        displaySmall: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.graphiteBlack,
        ),
        headlineLarge: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.graphiteBlack,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.graphiteBlack,
        ),
        headlineSmall: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.graphiteBlack,
        ),
        titleLarge: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.graphiteBlack,
        ),
        titleMedium: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.graphiteBlack,
        ),
        titleSmall: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.mediumGray,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.graphiteBlack,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.graphiteBlack,
        ),
        bodySmall: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.mediumGray,
        ),
        labelLarge: TextStyle(
          fontFamily: AppFonts.jetBrainsMono,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.graphiteBlack,
        ),
        labelMedium: TextStyle(
          fontFamily: AppFonts.jetBrainsMono,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.graphiteBlack,
        ),
        labelSmall: TextStyle(
          fontFamily: AppFonts.jetBrainsMono,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.mediumGray,
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepBlue,
          foregroundColor: AppColors.white,
          elevation: 2,
          shadowColor: AppColors.deepBlue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepBlue,
          side: const BorderSide(color: AppColors.deepBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.white,
        elevation: 2,
        shadowColor: AppColors.graphiteBlack.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mediumGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.deepBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: const TextStyle(
          fontFamily: AppFonts.poppins,
          color: AppColors.mediumGray,
        ),
        hintStyle: const TextStyle(
          fontFamily: AppFonts.poppins,
          color: AppColors.mediumGray,
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.deepBlue,
        unselectedItemColor: AppColors.mediumGray,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.cyberYellow,
        secondary: AppColors.deepBlue,
        surface: AppColors.darkGray,
        background: AppColors.graphiteBlack,
        error: AppColors.error,
        onPrimary: AppColors.graphiteBlack,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        onBackground: AppColors.white,
        onError: AppColors.white,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.graphiteBlack,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      
      // Apply similar theming for dark mode...
      textTheme: lightTheme.textTheme.apply(
        bodyColor: AppColors.white,
        displayColor: AppColors.white,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cyberYellow,
          foregroundColor: AppColors.graphiteBlack,
          elevation: 2,
          shadowColor: AppColors.cyberYellow.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      cardTheme: CardTheme(
        color: AppColors.darkGray,
        elevation: 2,
        shadowColor: AppColors.cyberYellow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}
