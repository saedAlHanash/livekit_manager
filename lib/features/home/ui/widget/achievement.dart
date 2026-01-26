import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/circle_image_widget.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/services/sounds_service.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/assets.dart';

class AchievementToast extends StatelessWidget {
  final String studentName;
  final String imageUrl;
  final String message; // مثال: "قام بالتصفيق لـ" أو "أحسنت صنعاً!"
  final Widget? icon; // هنا ممكن تمرر الـ Lottie اللي جهزتها

  const AchievementToast({
    super.key,
    required this.studentName,
    required this.imageUrl,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColorManager.appBarColor.withValues(alpha: 0.8), // خلفية داكنة مثل Play Games
        borderRadius: BorderRadius.circular(40), // حواف دائرية جداً
        boxShadow: [
          BoxShadow(
            color: AppColorManager.appBarColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleImageWidget(url: imageUrl, size: 60.0),
            12.0.horizontalSpace,

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            15.0.horizontalSpace,
            LottieBuilder.asset(
              Assets.lottiesClapping,
              height: 70.0.h,
              width: 70.0.w,
            ),
          ],
        ),
      ),
    );
  }
}

void showApplaudNotification(BuildContext context, String name, String img, String msg, Function() onEnd) {
  OverlayState? overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50, // المسافة من الأعلى
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
          // تأثير ارتداد خفيف مثل الألعاب
          tween: Tween(begin: -100.0, end: 0.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, value),
              child: child,
            );
          },
          child: Center(
            child: AchievementToast(
              studentName: name,
              imageUrl: img,
              message: msg,
            ),
          ),
        ),
      ),
    ),
  );

  SoundService.play(Assets.soundsClapping);

  overlayState.insert(overlayEntry);

  // إخفاء الإشعار بعد 3 ثوانٍ
  Future.delayed(const Duration(seconds: 10), () {
    overlayEntry.remove();
    onEnd.call();
  });
}
