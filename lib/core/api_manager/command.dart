//
// import 'package:drawable_text/drawable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'connectivity_cubit/connectivity_cubit.dart';
//
// class ConnectivityWidget extends StatelessWidget {
//   const ConnectivityWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ConnectivityCubit, ConnectivityInitial>(
//       builder: (context, state) {
//         return AnimatedSwitcher(
//           duration: Duration(milliseconds: 600),
//           transitionBuilder: (widget, animation) =>
//               SizeTransition(sizeFactor: animation, child: widget),
//           child: !state.result.isInitial
//               ? Material(
//                   color: Colors.white,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 10.0).r,
//                     key: ValueKey(state.result.index),
//                     width: 1.0.sw,
//                     color: state.result.getColor,
//                     alignment: Alignment.center,
//                     child: DrawableText(
//                       text: state.result.name,
//                       size: 18.0.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 )
//               : SizedBox.shrink(),
//         );
//       },
//     );
//   }
// }
