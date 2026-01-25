import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/features/lesson/data/response/lesson_response.dart';
import 'package:livekit_manager/router/go_router.dart';
import 'package:go_router/go_router.dart';

class ItemLesson extends StatelessWidget {
  const ItemLesson({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('RouteName.lesson', extra: lesson),
      child: Container(
        padding: const EdgeInsets.all(16.0).r,
        // margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0).r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0.r),
          color: AppColorManager.tileColor,
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_lesson_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(width: 12.0.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawableText(
                    text: lesson.title,
                    size: 16.0.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 4.0.h),
                  DrawableText(
                    text: 'Sequence: ${lesson.sequence}',
                    size: 14.0.sp,
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18.0.r, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
