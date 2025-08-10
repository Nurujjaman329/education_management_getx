import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.card,
    dividerColor: AppColors.divider,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textSecondary),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    //  background: AppColors.background,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkSurface,
    dividerColor: AppColors.darkDivider,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
    //  background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      error: AppColors.darkError,
    ),
  );
}
