import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../strings/app_color_manager.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    this.child,
    this.onTap,
    this.text = '',
    this.color,
    this.elevation = false,
    this.textColor,
    this.width,
    this.shadowColor,
    this.height,
    this.enable = true,
    this.loading = false,
    this.bold = true,
    this.margin,
    this.icon,
    this.iconStart,
    this.borderColor,
    this.overlayColor,
    this.radios,
    this.padding,
  });

  final Widget? child;
  final String text;
  final Color? textColor;
  final Color? overlayColor;
  final Color? color;
  final Color? shadowColor;
  final Color? borderColor;
  final bool elevation;
  final double? width;
  final double? height;
  final bool enable;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Function()? onTap;
  final bool loading;
  final bool bold;
  final dynamic icon;
  final dynamic iconStart;
  final double? radios;

  factory MyButton.outline({
    String text = '',
    dynamic icon,
    dynamic iconStart,
    Function()? onTap,
    Color? borderColor,
    Color? color,
    double? width,
    Widget? child,
    double? height,
    EdgeInsets? padding,
  }) {
    return MyButton(
      text: text,
      onTap: onTap,
      width: width,
      height: height,
      color: color ?? Colors.white,
      margin: padding,
      elevation: false,
      borderColor: borderColor ?? AppColorManager.mainColor,
      textColor: borderColor ?? AppColorManager.mainColor,
      icon: icon,
      bold: false,
      iconStart: iconStart,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final child = this.child ??
        DrawableText(
          text: text,
          color: Colors.white,
          fontWeight: bold ? FontWeight.bold : null,
          drawablePadding: 5.0.w,
          drawableEnd: loading
              ? SizedBox(
                  height: 15.0.r,
                  width: 15.0.r,
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: color,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      color == Colors.white ? AppColorManager.mainColor : Colors.white,
                    ),
                  ),
                )
              : icon == null
                  ? null
                  : ImageMultiType(url: icon, color: textColor ?? Colors.white, height: 24.0.r, width: 24.0.r),
          drawableStart: iconStart == null ? null : ImageMultiType(url: iconStart, color: textColor ?? Colors.white),
        );

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: enable ? onTap : null,
        child: Container(
          width: width ?? .9.sw,
          height: height ?? 35.0.h,
          // padding: padding ?? EdgeInsets.symmetric(vertical: 10.0).r,
          decoration: BoxDecoration(
            color: !enable ? Colors.grey : color ?? AppColorManager.mainColor,
            borderRadius: BorderRadius.circular(radios ?? 8.0.r),
            border: borderColor == null ? null : Border.all(color: borderColor!),
            boxShadow: ((!enable || color != null) || !elevation)
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x26464646),
                      blurRadius: 7,
                      offset: Offset(0, 6),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
