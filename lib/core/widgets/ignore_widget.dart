import 'package:flutter/material.dart';

class IgnoreWidget extends StatelessWidget {
  const IgnoreWidget({super.key, required this.isIgnore, required this.child});

  final bool isIgnore;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isIgnore ? 0.3 : 1,
      child: IgnorePointer(
        ignoring: isIgnore,
        child: child,
      ),
    );
  }
}
