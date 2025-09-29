import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../strings/app_color_manager.dart';

class TextWithListDote extends StatelessWidget {
  const TextWithListDote({
    super.key,
    this.textWidget,
    this.matchParent,
    this.color,
    this.text = '',
    this.title,
  });

  final Widget? textWidget;
  final String text;
  final String? title;
  final bool? matchParent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (textWidget == null && text.isEmpty) {
      return 0.0.verticalSpace;
    }
    return SizedBox(
      width: (matchParent ?? false) ? 1.0.sw : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          20.0.horizontalSpace,
          DrawableText(
            text: '.',
            size: 40.0.spMin,
            padding: const EdgeInsets.only(left: 10.0, right: 5.0).w,
            color: color ?? AppColorManager.mainColor,
          ),
          if (title != null)
            DrawableText(
              text: '$title',
              fontWeight: FontWeight.bold,
              color: AppColorManager.mainColor,
            ),
          Expanded(
            child: DrawableText(text: text, textAlign: TextAlign.end),
          ),
          20.0.horizontalSpace,
        ],
      ),
    );
  }
}
