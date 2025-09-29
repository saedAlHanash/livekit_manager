import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleWithDote extends StatelessWidget {
  const TitleWithDote({super.key, required this.text});

  final Widget text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        DrawableText(
          text: '•',
          size: 20.0.sp,
          // style: TextStyle(fontSize: 20),
        ),
        5.0.horizontalSpace,
        text,
      ],
    );
  }
}
