import 'package:flutter/cupertino.dart';
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

class AppTextStyles {
  static TextStyle headline = GoogleFonts.fraunces(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.ivory,
  );

  static TextStyle navTitle = GoogleFonts.fraunces(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.ivory,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.ivory,
  );

  static TextStyle bodyMuted = GoogleFonts.inter(
    fontSize: 12,
    color: AppColors.muted,
  );

  static TextStyle priceLabel = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.garnet,
  );
}

class AppTheme {
  static CupertinoThemeData get cupertinoTheme {
    return CupertinoThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.ink,
      barBackgroundColor: AppColors.ink,
      primaryColor: AppColors.garnet,
      textTheme: CupertinoTextThemeData(
        navTitleTextStyle: AppTextStyles.navTitle.copyWith(inherit: false),
        navLargeTitleTextStyle: AppTextStyles.navTitle.copyWith(
          inherit: false,
          fontSize: 32,
        ),
        navActionTextStyle: AppTextStyles.body.copyWith(inherit: false),
        textStyle: AppTextStyles.body.copyWith(inherit: false),
        actionTextStyle: AppTextStyles.body.copyWith(
          inherit: false,
          color: AppColors.garnet,
        ),
        tabLabelTextStyle: AppTextStyles.bodyMuted.copyWith(inherit: false),
        pickerTextStyle: AppTextStyles.body.copyWith(inherit: false),
        dateTimePickerTextStyle: AppTextStyles.body.copyWith(inherit: false),
      ),
    );
  }
}