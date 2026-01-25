import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/widgets/app_bar/app_bar_widget.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';

class DonePage extends StatelessWidget {
  const DonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(zeroHeight: true),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          80.0.verticalSpace,
          DrawableText(
            text: S.of(context).logInToYourWallet,
            size: 24.0.sp,
            textAlign: TextAlign.center,
            matchParent: true,
          ),
          25.0.verticalSpace,
          ImageMultiType(
            url: Assets.images3dSafeLock,
            height: 240.0.h,
            width: 240.0.w,
          ),
          40.0.verticalSpace,
          DrawableText(
            size: 18.0,
            text: S.of(context).loginSuccessfulWelcomeBackTo,
          ),
        ],
      ),
    );
  }
}
