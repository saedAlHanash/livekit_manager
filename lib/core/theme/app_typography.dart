import 'package:flutter/material.dart';

class AppTypography {
  const AppTypography._();

  static const String regularFont = 'regular';
  static const String mediumFont = 'semeBold';
  static const String boldFont = 'bold';

  static TextTheme textTheme(Color color) {
    const baseHeight = 1.45;
    return TextTheme(
      displayLarge: _style(57, FontWeight.w700, color, height: 1.25),
      displayMedium: _style(45, FontWeight.w700, color, height: 1.28),
      displaySmall: _style(36, FontWeight.w700, color, height: 1.32),
      headlineLarge: _style(32, FontWeight.w700, color, height: 1.35),
      headlineMedium: _style(28, FontWeight.w700, color, height: 1.38),
      headlineSmall: _style(24, FontWeight.w700, color, height: 1.4),
      titleLarge: _style(22, FontWeight.w700, color, height: baseHeight),
      titleMedium: _style(16, FontWeight.w600, color, height: baseHeight),
      titleSmall: _style(14, FontWeight.w600, color, height: baseHeight),
      bodyLarge: _style(16, FontWeight.w400, color, height: 1.6),
      bodyMedium: _style(14, FontWeight.w400, color, height: 1.6),
      bodySmall: _style(12, FontWeight.w400, color, height: 1.55),
      labelLarge: _style(14, FontWeight.w700, color, height: 1.35),
      labelMedium: _style(12, FontWeight.w600, color, height: 1.35),
      labelSmall: _style(11, FontWeight.w600, color, height: 1.35),
    );
  }

  static TextStyle _style(
    double size,
    FontWeight weight,
    Color color, {
    required double height,
  }) {
    return TextStyle(
      fontFamily: weight.value >= FontWeight.w600.value ? boldFont : regularFont,
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: color,
      letterSpacing: 0,
    );
  }
}
