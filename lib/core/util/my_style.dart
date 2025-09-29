import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/app_widget.dart';
import '../strings/app_color_manager.dart';
import '../strings/enum_manager.dart';

class MyStyle {
  //region number style

  static final double cardRadios = 8.0.r;

  //endregion

//region margin/padding
  static EdgeInsets get cardPadding => EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h);

  static final pagePadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 8).r;

//endregion

  static const underLineStyle = TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline);

  static var drawerShape = ShapeDecoration(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: AppColorManager.mainColor.withValues(alpha: 0.9));

  static var normalShadow = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.1),
      blurRadius: 6,
      spreadRadius: 2,
      offset: const Offset(0, 3),
    )
  ];

  static var lightShadow = [
    BoxShadow(color: AppColorManager.grey.withValues(alpha: 0.5), blurRadius: 5, offset: const Offset(0, 2))
  ];

  static var allShadow = [
    BoxShadow(
      color: AppColorManager.grey.withValues(alpha: 0.5),
      blurRadius: 10,
    )
  ];

  static var allShadowDark = [
    BoxShadow(
      color: AppColorManager.grey.withValues(alpha: 0.6),
      blurRadius: 10.spMin,
    )
  ];

  static final formBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColorManager.offWhit.withValues(alpha: 0.27),
      ),
      borderRadius: BorderRadius.circular(10.0.r));

  static final hintStyle = TextStyle(
    fontFamily: FontManager.semeBold.name,
    fontSize: 18.0.spMin,
    color: AppColorManager.grey.withValues(alpha: 0.6),
  );

  static final textFormTextStyle = TextStyle(
    fontFamily: FontManager.bold.name,
    fontSize: 18.0.spMin,
    color: Colors.black87,
  );

  static BoxDecoration get cardBox => BoxDecoration(
        color: Theme.of(ctx!).primaryColorDark,
        borderRadius: BorderRadius.circular(8.0.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(ctx!).shadowColor,
            blurRadius: 4.r,
            offset: Offset(0, 1.r),
            spreadRadius: 0,
          )
        ],
      );

  static BoxDecoration get outlineBox => BoxDecoration(
        borderRadius: BorderRadius.circular(4.0.r),
        border: Border.all(color: AppColorManager.dividerColor, width: 1.0.w),
      );

  static var outlineBoxWhite1 = BoxDecoration(
    color: AppColorManager.white,
    borderRadius: BorderRadius.circular(4.0.r),
    border: Border.all(color: AppColorManager.dividerColor, width: 1.0.w),
  );

  static var roundBox12 = BoxDecoration(
    color: AppColorManager.white,
    borderRadius: BorderRadius.circular(12.0.r),
    boxShadow: MyStyle.allShadowDark,
  );

  static Widget loadingWidget({Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0).r,
      child: Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: color,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  static var outlineBorder = BoxDecoration(
    border: Border.all(color: Colors.green),
    borderRadius: BorderRadius.circular(12.0.r),
    color: AppColorManager.lightGray,
  );

  static LinearGradient appGradient = LinearGradient(
    colors: [
      AppColorManager.mainColorDark,
      AppColorManager.mainColorDark1,
      AppColorManager.mainColorDark2,
    ],
    begin: AlignmentDirectional.centerEnd,
    end: AlignmentDirectional.centerStart,
  );

  static final appBorderAll = Border.all(
    strokeAlign: BorderSide.strokeAlignOutside,
    color: AppColorManager.mainColor,
    width: 2.0.spMin,
  );

  static final authPagesPadding = const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 30.0).r;

  static SliverGridDelegate get productGridDelegate => SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisExtent: 180.0.h,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        maxCrossAxisExtent: 200.0.w,
      );
}
