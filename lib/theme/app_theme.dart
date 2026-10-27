import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFFAFAF8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF2F2EF);
  static const border = Color(0xFFE6E6E1);
  static const ink = Color(0xFF171717);

  static const pink = Color(0xFF9C5F52);
  static const violet = ink;
  static const cyan = Color(0xFF4E6E62);
  static const amber = Color(0xFF8C6B3C);

  static const textPrimary = ink;
  static const textMuted = Color(0xFF73736D);

  static const aurora = <Color>[pink, violet, cyan];
  static const sunset = <Color>[amber, pink, violet];
  static const ocean = <Color>[cyan, violet, pink];
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.ink,
    brightness: Brightness.light,
  ).copyWith(
    surface: AppColors.surface,
    primary: AppColors.ink,
    secondary: AppColors.cyan,
    outline: AppColors.border,
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
          fontSize: 44,
          height: 1.06,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.6,
          color: AppColors.textPrimary,
        ),
        headlineMedium: const TextStyle(
          fontSize: 28,
          height: 1.15,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          color: AppColors.textPrimary,
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
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
          fontWeight: FontWeight.w600,
          letterSpacing: 1.6,
          color: AppColors.textMuted,
        ),
      );

  return base.copyWith(
    textTheme: text,
    iconTheme: const IconThemeData(color: AppColors.textPrimary),
    dividerColor: AppColors.border,
  );
}
