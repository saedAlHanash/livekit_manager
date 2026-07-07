import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

class AppPressable extends StatefulWidget {
  const AppPressable({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final scale = _pressed ? 0.98 : 1.0;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: AppMotion.fast,
          curve: AppMotion.curve,
          child: AnimatedOpacity(
            opacity: enabled && _hovered ? 0.94 : 1,
            duration: AppMotion.fast,
            curve: AppMotion.curve,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
