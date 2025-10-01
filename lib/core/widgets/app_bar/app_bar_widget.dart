import 'dart:io';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../strings/app_color_manager.dart';
import '../../strings/enum_manager.dart';
import '../../util/my_style.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.titleText,
    this.elevation,
    this.zeroHeight,
    this.leading,
    this.actions,
    this.title,
    this.color,
    this.canPop = true,
    this.flexibleSpace = false,
    this.onPopInvoked,
  });

  final String? titleText;
  final Widget? title;
  final Widget? leading;
  final Color? color;
  final bool? zeroHeight;
  final double? elevation;
  final List<Widget>? actions;
  final bool canPop;
  final bool flexibleSpace;

  final Function(bool, dynamic result)? onPopInvoked;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onPopInvoked,
      child: AppBar(
        backgroundColor: color ?? Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: color ?? Theme.of(context).appBarTheme.surfaceTintColor,
        flexibleSpace: !flexibleSpace ? null : Container(decoration: BoxDecoration(gradient: MyStyle.appGradient)),

        toolbarHeight: (zeroHeight ?? false) ? 0 : 70.0.h,
        // scrolledUnderElevation: 0,
        title: title ??
            DrawableText(
              text: titleText ?? '',
              size: 20.0.spMin,
              // color: isColorDark(color ?? AppColorManager.mainColor) ? Colors.white : null,
              fontFamily: FontManager.bold.name,
            ),
        leading: leading ??
            (context.canPop()
                ? BackBtnWidget(
                    canPop: canPop,
                    onPopInvoked: onPopInvoked,
                    appBarColor: color ?? Theme.of(context).appBarTheme.backgroundColor ?? AppColorManager.mainColor,
                  )
                : null),
        centerTitle: true,
        actions: actions,
        elevation: elevation ?? 0.0,
        shadowColor: elevation == 0 ? Colors.transparent : AppColorManager.black.withValues(alpha: 0.28),
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
      ),
    );
  }

  @override
  Size get preferredSize => Size(1.0.sw, (zeroHeight ?? false) ? 0 : 70.0.h);
}

class BackBtnWidget extends StatelessWidget {
  const BackBtnWidget({
    super.key,
    required this.appBarColor,
    this.canPop = true,
    this.onPopInvoked,
  });

  final Color appBarColor;
  final bool canPop;

  final Function(bool, dynamic)? onPopInvoked;

  @override
  Widget build(BuildContext context) {
    if (!context.canPop()) return 0.0.verticalSpace;
    return IconButton(
      onPressed: () {
        HapticFeedback.selectionClick();
        if (!canPop) {
          onPopInvoked?.call(false, null);
          return;
        }
        if (!context.canPop()) return;
        context.pop();
      },
      icon: Icon(
        Icons.arrow_back_ios,
        color: isColorDark(appBarColor)
            ? Colors.white
            : Theme.of(context).appBarTheme.iconTheme?.color ?? AppColorManager.black,
      ),
    );
  }
}
