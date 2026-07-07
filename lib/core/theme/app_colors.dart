import 'package:flutter/material.dart';

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
    required this.live,
    required this.onLive,
  });

  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;
  final Color live;
  final Color onLive;

  static const light = AppSemanticColors(
    success: Color(0xFF067647),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFFB54708),
    onWarning: Color(0xFFFFFFFF),
    info: Color(0xFF175CD3),
    onInfo: Color(0xFFFFFFFF),
    live: Color(0xFF15803D),
    onLive: Color(0xFFFFFFFF),
  );

  static const dark = AppSemanticColors(
    success: Color(0xFF47CD89),
    onSuccess: Color(0xFF052E16),
    warning: Color(0xFFFDB022),
    onWarning: Color(0xFF3B1D00),
    info: Color(0xFF84CAFF),
    onInfo: Color(0xFF062C52),
    live: Color(0xFF22C55E),
    onLive: Color(0xFF052E16),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
    Color? live,
    Color? onLive,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      live: live ?? this.live,
      onLive: onLive ?? this.onLive,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      live: Color.lerp(live, other.live, t)!,
      onLive: Color.lerp(onLive, other.onLive, t)!,
    );
  }
}

class AppColors {
  const AppColors._();

  static const seed = Color(0xFF006B5F);
  static const primary = Color(0xFF006B5F);
  static const secondary = Color(0xFF8A6F3D);
  static const tertiary = Color(0xFF2563EB);
  static const error = Color(0xFFBA1A1A);

  static const darkSeed = Color(0xFF7DD8CA);
  static const darkSurface = Color(0xFF101817);
  static const darkSurfaceContainer = Color(0xFF17211F);
  static const darkBackground = Color(0xFF061311);

  static const lightSurface = Color(0xFFFBFFFD);
  static const lightSurfaceContainer = Color(0xFFF0F7F4);
  static const lightBackground = Color(0xFFF7FBF9);
}
