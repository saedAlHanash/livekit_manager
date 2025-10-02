// import 'package:lk_assistant/core/extensions/extensions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../api_manager/request_models/command.dart';
// import '../strings/enum_manager.dart';
// import 'my_button.dart';
//
// class LoadMoreWidget extends StatelessWidget {
//   const LoadMoreWidget({
//     Key? key,
//     required this.child,
//     required this.length,
//     required this.totalCount,
//     this.statuses = CubitStatuses.init,
//     required this.onNewCommand,
//     required this.command,
//   }) : super(key: key);
//
//   final Widget child;
//   final int length;
//   final int totalCount;
//   final CubitStatuses statuses;
//   final Command command;
//   final Function(Command command) onNewCommand;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         child,
//         10.0.verticalSpace,
//         if (length < totalCount)
//           Builder(builder: (context) {
//             return MyButton(
//               loading: statuses.loading,
//               width: 177.0.w,
//               text: 'تحميل المزيد',
//               onTap: () {
//                 // command.pag = (command.pag ?? 0) + 1;
//                 onNewCommand(command);
//               },
//             );
//           }),
//         70.0.verticalSpace,
//       ],
//     );
//   }
// }
