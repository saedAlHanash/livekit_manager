import 'package:flutter/material.dart';

class AppMotion {
  const AppMotion._();

  static const Duration fast = Duration(milliseconds: 160);
  static const Duration normal = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 420);

  static const Curve curve = Curves.easeOutCubic;

  static Widget fadeSlideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: curve);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.025),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
