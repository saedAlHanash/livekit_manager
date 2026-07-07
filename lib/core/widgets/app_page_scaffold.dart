import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.child,
    this.padding = AppSpacing.page,
    this.maxWidth = 1180,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: AlignmentDirectional.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
