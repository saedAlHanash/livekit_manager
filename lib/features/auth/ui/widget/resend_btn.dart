// import 'dart:async';
//
// import 'package:drawable_text/drawable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:livekit_manager/core/app/app_provider.dart';
// import 'package:livekit_manager/core/extensions/extensions.dart';
//
// import '../../../../core/strings/app_color_manager.dart';
// import '../../../../generated/l10n.dart';
// import '../../bloc/resend_code_cubit/resend_code_cubit.dart';
//
// class ResendBtn extends StatefulWidget {
//   const ResendBtn({super.key});
//
//   @override
//   State<ResendBtn> createState() => _ResendBtnState();
// }
//
// class _ResendBtnState extends State<ResendBtn> {
//   Timer? timer;
//
//   var countRemaining = 0;
//
//   void startTimer() {
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (countRemaining <= 0) {
//         countRemaining = 0;
//         setState(() => timer.cancel());
//         return;
//       }
//       setState(() => countRemaining--);
//     });
//   }
//
//   @override
//   void initState() {
//     countRemaining = AppProvider.getRemaining;
//     startTimer();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ResendCodeCubit, ResendCodeInitial>(
//       listenWhen: (p, c) => c.statuses.done,
//       listener: (context, state) {
//         countRemaining = AppProvider.getRemaining;
//         if (countRemaining <= 0) {
//           setState(() {});
//           return;
//         }
//         timer?.cancel();
//         startTimer();
//       },
//       builder: (context, state) {
//         return DrawableText(
//           text: S.of(context).didntReceiveTheOtp,
//           color: AppColorManager.secondColor,
//           drawablePadding: 10.0.w,
//           drawableEnd: countRemaining <= 0
//               ? TextButton(
//                   onPressed: () {
//                     // if (AppProvider.getCachedEmail.isEmpty) {
//                     //   context.pushReplacementNamed(RouteName.login);
//                     //   return;
//                     // }
//
//                     context.read<ResendCodeCubit>().resendCode();
//                   },
//                   child: DrawableText(
//                     text: S.of(context).resend,
//                     textAlign: TextAlign.center,
//                     textDecoration: TextDecoration.underline,
//                     color: AppColorManager.secondColor,
//                   ),
//                 )
//               : DrawableText(
//                   text: countRemaining.toString(),
//                   textAlign: TextAlign.center,
//                   textDecoration: TextDecoration.underline,
//                   color: AppColorManager.secondColor,
//                 ),
//         );
//       },
//     );
//   }
// }
