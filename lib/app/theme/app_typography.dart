import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextStyle codeFont({
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textPrimaryDark,
    double height = 1.4,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextTheme darkTextTheme() {
    final base = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        color: AppColors.textPrimaryDark,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: AppColors.textPrimaryDark,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: AppColors.textPrimaryDark,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: AppColors.textPrimaryDark,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: AppColors.textSecondaryDark,
      ),
      labelLarge: base.labelLarge?.copyWith(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static TextTheme lightTextTheme() {
    final base = GoogleFonts.interTextTheme(ThemeData.light().textTheme);
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        color: AppColors.textPrimaryLight,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: AppColors.textPrimaryLight,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: AppColors.textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: AppColors.textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: AppColors.textSecondaryLight,
      ),
      labelLarge: base.labelLarge?.copyWith(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
