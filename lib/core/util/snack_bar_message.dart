import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../generated/l10n.dart';
import '../app/app_widget.dart';
import '../strings/app_color_manager.dart';
import '../widgets/my_button.dart';
import '../widgets/snake_bar_widget.dart';

class NoteMessage {
  static void showTopMessage({required String message, required BuildContext context}) {
    // if (ctx != null) return;
    showTopSnackBar(
      Overlay.of(context),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      CustomSnackBar.success(
        message: message,
      ),
      safeAreaValues: SafeAreaValues(top: true),
    );
  }

  static void showSuccessSnackBar({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: DrawableText(
          text: message,
          color: Colors.white,
          fontFamily: FontManager.bold.name,
        ),
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16, // احترام SafeArea
          left: 16,
          right: 16,
        ),
        backgroundColor: Colors.green,
        elevation: 6,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Future<void> showErrorSnackBar({
    required String message,
    required BuildContext context,
    Function()? onCancel,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColorManager.mainColor,
        duration: const Duration(seconds: 5),
        content: DrawableText(text: message, color: Colors.white),
      ),
    );
    if (onCancel == null) return;
    Future.delayed(const Duration(seconds: 3), () => onCancel.call());
  }

  static void showSnakeBar({required String? message, required BuildContext context}) {
    final snack = SnackBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      content: SnakeBarWidget(text: message ?? ''),
    );

    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  static void showBottomSheet({required Widget child, bool isDismissible = false}) {
    showModalBottomSheet(
      context: ctx!,
      isDismissible: isDismissible,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      isScrollControlled: true,
      builder: (cx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(cx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: child,
          ),
        );
      },
    );
  }

  static Future<bool> showBottomSheet1({required Widget child}) async {
    final result = await showModalBottomSheet(
      isScrollControlled: true,
      context: ctx!,
      backgroundColor: Colors.transparent,
      // barrierColor: Colors.transparent,
      builder: (context) => child,
    );

    return result ?? false;
  }

  static Future<bool> showBottomSheetScrollable({required List<Widget> children}) async {
    final result = await showModalBottomSheet(
      context: ctx!,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        builder: (context, scrollController) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            controller: scrollController,
            children: children,
          );
        },
      ),
    );

    return result ?? false;
  }

  static Future<bool> showConfirm(BuildContext context, {required String text}) async {
    // show the dialog
    final result = await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0.r))),
          elevation: 10.0,
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.all(15.0).r,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DrawableText(
                  text: text,
                  size: 22.0.spMin,
                  fontFamily: FontManager.bold.name,
                  color: AppColorManager.mainColorDark,
                ),
                40.0.verticalSpace,
                MyButton(text: S.of(context).confirm, onTap: () => Navigator.pop(context, true)),
                10.0.verticalSpace,
                MyButton(
                  text: S.of(context).cancel,
                  onTap: () => Navigator.pop(context, false),
                  color: AppColorManager.black,
                ),
                20.0.verticalSpace,
              ],
            ),
          ),
        );
      },
    );
    return (result ?? false);
  }

  static Future<bool> showErrorDialog({
    required String text,
    bool tryAgne = true,
  }) async {
    // show the dialog
    final result = await showDialog(
      context: ctx!,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0.r))),
          elevation: 10.0,
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DrawableText(
                text: 'Oops!',
                size: 20.0.spMin,
                padding: const EdgeInsets.symmetric(vertical: 15.0).h,
                fontFamily: FontManager.bold.name,
              ),
              Divider(height: 30.0.h, color: Colors.black),
              DrawableText(
                text: text,
                textAlign: TextAlign.center,
                size: 16.0.spMin,
                padding: const EdgeInsets.symmetric(vertical: 20.0).h,
                fontFamily: FontManager.bold.name,
              ),
              Divider(height: 30.0.h, color: Colors.black),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: DrawableText(text: tryAgne ? 'Try Again' : 'OK'),
              ),
            ],
          ),
        );
      },
    );

    return (result ?? false);
  }

  static void showDialogError(BuildContext context, {required String text}) {
    // show the dialog
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0.r))),
          elevation: 10.0,
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DrawableText(
                text: 'Oops!',
                size: 20.0.spMin,
                padding: const EdgeInsets.symmetric(vertical: 15.0).h,
                fontFamily: FontManager.bold.name,
              ),
              Divider(height: 30.0.h, color: Colors.black),
              DrawableText(
                text: text,
                textAlign: TextAlign.center,
                size: 16.0.spMin,
                padding: const EdgeInsets.symmetric(vertical: 20.0).h,
                fontFamily: FontManager.bold.name,
              ),
              Divider(height: 30.0.h, color: Colors.black),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const DrawableText(text: 'OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> showMyDialog({
    required Widget child,
    Function(dynamic val)? onCancel,
  }) async {
    final result = await showDialog(
      context: ctx!,
      barrierColor: Colors.black.withAlpha(76), // بدل withValues
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Dialog(
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0.r))),
            insetPadding: const EdgeInsets.all(0).r,
            elevation: 10.0,
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                child,
              ],
            ),
          ),
        );
      },
    );
    onCancel?.call(result);
    return (result ?? false);
  }

  static Future<void> showAwesomeError({
    required String message,
  }) async {
    await AwesomeDialog(
      context: ctx!,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: S().oops,
      desc: message,
    ).show();
  }

  static Future<void> showAwesomeDoneDialog(
    BuildContext context, {
    required String message,
    Function()? onCancel,
  }) async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: S.of(context).done,
      desc: message,
      onDismissCallback: (type) => onCancel?.call(),
    ).show();
  }

  static Future<void> showCheckDialog(
    BuildContext context, {
    required String text,
    required String textButton,
    dynamic image,
    Function()? onConfirm,
  }) async {
    // show the dialog
    await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Dialog(
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0.r))),
            elevation: 10.0,
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 1.0.sw,
                  padding: const EdgeInsets.all(15.0).r,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0.r)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (image != null)
                        ImageMultiType(
                          url: image,
                          height: 60.0.r,
                          width: 60.0.r,
                        ),
                      20.0.verticalSpace,
                      DrawableText(
                        text: text,
                        size: 20.0.sp,
                        textAlign: TextAlign.center,
                        fontFamily: FontManager.semeBold.name,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0).r,
                  child: Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          color: Colors.red,
                          onTap: () {
                            context.pop(true);
                            onConfirm?.call();
                          },
                          text: textButton,
                        ),
                      ),
                      15.0.horizontalSpace,
                      Expanded(
                        child: MyButton(
                          onTap: () => context.pop(false),
                          text: 'No',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
