import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../strings/app_color_manager.dart';

class TitleText extends StatelessWidget {
  const TitleText(this.hint, {super.key});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return DrawableText.title(
      text: '$hint: ',
      color: AppColorManager.mainColor,
      padding: const EdgeInsets.only(bottom: 7.0).r,

    );
  }
}
