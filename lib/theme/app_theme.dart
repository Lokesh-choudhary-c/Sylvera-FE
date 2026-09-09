import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const ink = Color(0xFF16111A);
  static const surface = Color(0xFF211A20);
  static const ivory = Color(0xFFF4EEE6);
  static const muted = Color(0xFF9C8F93);
  static const garnet = Color(0xFF8C2F39);

  static const goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE9C46A), Color(0xFFB8860B)],
  );

  static const silverGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8E8E8), Color(0xFFA8ACAF)],
  );
}

class AppTheme {
  static ThemeData get theme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.ink,
      colorScheme: base.colorScheme.copyWith(
        surface: AppColors.ink,
        primary: AppColors.garnet,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.ink,
        elevation: 0,
        titleTextStyle: GoogleFonts.fraunces(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.ivory,
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: GoogleFonts.fraunces(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.ivory,
        ),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: AppColors.ivory),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: AppColors.muted),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.garnet,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.garnet,
          foregroundColor: AppColors.ivory,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
    );
  }
}
