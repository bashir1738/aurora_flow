import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF05060F);
  static const surface = Color(0xFF0C0E1E);
  static const pink = Color(0xFFFF5FA2);
  static const violet = Color(0xFF7C5CFF);
  static const cyan = Color(0xFF4FE3D2);
  static const amber = Color(0xFFFFC46B);

  static const textPrimary = Color(0xFFF4F1FF);
  static const textMuted = Color(0xFF9A97B8);

  static const aurora = <Color>[pink, violet, cyan];
  static const sunset = <Color>[amber, pink, violet];
  static const ocean = <Color>[cyan, violet, pink];
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.violet,
    brightness: Brightness.dark,
  ).copyWith(
    surface: AppColors.background,
    primary: AppColors.violet,
    secondary: AppColors.cyan,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    splashFactory: InkRipple.splashFactory,
  );

  final text = base.textTheme
      .apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      )
      .copyWith(
        displayLarge: const TextStyle(
          fontSize: 46,
          height: 1.04,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.8,
          color: AppColors.textPrimary,
        ),
        headlineMedium: const TextStyle(
          fontSize: 28,
          height: 1.15,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.6,
          color: AppColors.textPrimary,
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          height: 1.55,
          color: AppColors.textMuted,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          height: 1.4,
          color: AppColors.textMuted,
        ),
        labelSmall: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.8,
          color: AppColors.textMuted,
        ),
      );

  return base.copyWith(
    textTheme: text,
    iconTheme: const IconThemeData(color: AppColors.textPrimary),
    dividerColor: Colors.white.withValues(alpha: 0.08),
  );
}
