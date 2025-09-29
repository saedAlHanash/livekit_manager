// import 'package:drawable_text/drawable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../strings/app_color_manager.dart';
//
// class PinCodeWidget extends StatelessWidget {
//   const PinCodeWidget({
//     super.key,
//     this.onCompleted,
//     this.onChange,
//     this.validator,
//   });
//
//   final Function(String)? onCompleted;
//   final Function(String)? onChange;
//   final String? Function(String?)? validator;
//
//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 50.0.r,
//       height: 50.0.r,
//       textStyle: TextStyle(
//         fontSize: 20.0.sp,
//       ),
//       decoration: BoxDecoration(
//         color: AppColorManager.mainColor,
//         borderRadius: BorderRadius.circular(8.0.r),
//         border: Border.all(color: AppColorManager.borderColor),
//       ),
//     );
//     return Center(
//       child: Directionality(
//         textDirection: TextDirection.ltr,
//         child: Pinput(
//           length: 6,
//           defaultPinTheme: defaultPinTheme,
//           focusedPinTheme: defaultPinTheme,
//           submittedPinTheme: defaultPinTheme,
//           showCursor: false,
//           preFilledWidget: const Center(
//             child: DrawableText(text: '-'),
//           ),
//           onCompleted: onCompleted,
//           onChanged: onChange,
//           validator: validator,
//         ),
//       ),
//     );
//   }
// }
