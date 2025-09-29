import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../generated/l10n.dart';
import '../strings/app_color_manager.dart';

class ListHeader extends StatelessWidget {
  const ListHeader({super.key, required this.headerTitle, this.seeAllFunction});

  final String headerTitle;
  final Function()? seeAllFunction;

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      text: headerTitle,
      padding: EdgeInsets.only(bottom: 20.0).r,
      fontFamily: FontManager.bold.name,
      matchParent: true,
      color: AppColorManager.mainColor,
      drawableEnd: seeAllFunction != null
          ? InkWell(
              onTap: seeAllFunction,
              child: DrawableText(
                text: S.of(context).seeAll,
                size: 12.0.sp,
                drawableAlin: DrawableAlin.withText,
                drawableEnd: ImageMultiType(
                  url: Icons.arrow_forward_ios,
                  color: AppColorManager.mainColor,
                  height: 12.0.sp,
                  width: 12.0.sp,
                ),
              ),
            )
          : null,
    );
  }
}
