import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/strings/enum_manager.dart';

class NoVideoWidget extends StatelessWidget {
  //
  const NoVideoWidget({super.key, this.type = .sharer});

  final LkUserType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LkUserType.manager:
      case LkUserType.sharer:
      case LkUserType.user:
        return Container(
          alignment: Alignment.center,
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              return Icon(
                Icons.person,
                size: math.min(constraints.maxHeight, constraints.maxWidth) * 0.3,
              );
            },
          ),
        );
    }
  }
}
