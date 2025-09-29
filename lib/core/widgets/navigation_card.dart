import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../app_theme.dart';

class NavigationCard extends StatelessWidget {
  const NavigationCard({
    super.key,
    required this.color,
    required this.title,
    required this.icon,
    this.subtitle,
    this.onTap,
  });

  final Color color;
  final String title;
  final Widget? subtitle;
  final dynamic icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        minVerticalPadding: 25.0,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        leading: Container(
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: ImageMultiType(url: icon, width: 25.sp, color: color),
        ),
        title: DrawableText(text: title),
        subtitle: subtitle,
        trailing: onTap == null
            ? null
            : Icon(
                Icons.arrow_forward_ios,
                size: 18.sp,
                color: Colors.grey.withOpacity(0.7),
              ),
      ),
    );
  }
}
