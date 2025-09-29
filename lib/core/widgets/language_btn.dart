import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../generated/assets.dart';
import '../app/app_widget.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0).r,
      child: PopupMenuButton<int>(
        tooltip: 'Language',
        offset: const Offset(0, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0.r)),
        elevation: 8.0,
        onSelected: (value) {
          switch (value) {
            case 0:
              MyApp.setLocale(context, 'ar');
              break;
            case 1:
              MyApp.setLocale(context, 'en');
              break;
          }
        },
        itemBuilder:
            (context) => [
              _buildMenuItem(Icons.language, "Arabic", 0),
              _buildMenuItem(Icons.language, "English", 1),
            ],
        child: ImageMultiType(url: Assets.iconsLanguage),
      ),
    );
  }

  PopupMenuItem<int> _buildMenuItem(dynamic icon, String text, int value) {
    return PopupMenuItem<int>(
      value: value,
      child: DrawableText(
        text: text,
        drawablePadding: 7.0.w,
        drawableStart: ImageMultiType(url: icon, height: 20.0.r, width: 20.0.r),
      ),
    );
  }
}
