import 'package:flutter/material.dart';

class AppSpacing {
  const AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const EdgeInsets page = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets card = EdgeInsets.all(md);
  static const EdgeInsets control = EdgeInsets.symmetric(horizontal: md, vertical: sm);
}

class AppRadius {
  const AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  static const BorderRadius small = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(md));
  static const BorderRadius large = BorderRadius.all(Radius.circular(lg));
}

class AppShadows {
  const AppShadows._();

  static const soft = [
    BoxShadow(
      color: Color(0x1A111827),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const lifted = [
    BoxShadow(
      color: Color(0x24111827),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];
}
