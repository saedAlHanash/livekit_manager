import 'dart:math' as math;

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/generated/l10n.dart';

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
