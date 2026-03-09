// import 'dart:convert';
//
// import 'package:drawable_text/drawable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_multi_type/image_multi_type.dart';
// import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
// import 'package:livekit_manager/features/room/data/request/message_request.dart';
// import 'package:livekit_manager/features/room/data/request/setting_message.dart';
//
// import '../../../../core/strings/app_color_manager.dart';
// import '../../../../core/strings/enum_manager.dart';
// import '../../../../core/widgets/my_button.dart';
// import '../../../../core/widgets/my_text_form_widget.dart';
// import '../../../../generated/l10n.dart';
// import '../../bloc/user_control_cubit/user_control_cubit.dart';
//
// class SendMessageDialog extends StatefulWidget {
//   const SendMessageDialog({super.key});
//
//   @override
//   State<SendMessageDialog> createState() => _SendMessageDialogState();
// }
//
// class _SendMessageDialogState extends State<SendMessageDialog> {
//   RoomCubit get roomC => context.read<RoomCubit>();
//
//   UserControlCubit get controlC => context.read<UserControlCubit>();
//
//   final message = LkMessage(action: ManagerActions.message, metadata: {});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 0.5.sw,
//       padding: EdgeInsets.all(20.0).r,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           DrawableText(
//             text: 'Write a message to the group',
//             fontWeight: FontWeight.bold,
//             size: 18.0.sp,
//           ),
//           20.0.verticalSpace,
//           MyTextFormWidget(
//             maxLines: 5,
//             hint: 'Message',
//             onChanged: (value) {},
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Row(
//               spacing: 20.0,
//               children: [
//                 Expanded(
//                   child: MyButton(
//                     onTap: () {
//                       context
//                         ..read<UserControlCubit>().sendMessage(
//                           MessageRequest(
//                             roomName: roomC.state.result.name ?? '',
//                             identities: [],
//                             data: jsonEncode(message),
//                           ),
//                         )
//                         ..pop();
//                     },
//                     width: 0.2.sw,
//                     text: S.of(context).send,
//                     color: AppColorManager.appBarColor,
//                     icon: ImageMultiType(
//                       height: 24.0.dg,
//                       width: 24.0.dg,
//                       url: Icons.send,
//                       color: AppColorManager.textColor,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: MyButton(
//                     onTap: context.pop,
//                     width: 0.2.sw,
//                     text: S.of(context).back,
//                     color: AppColorManager.appBarColor,
//                     icon: ImageMultiType(
//                       height: 24.0.dg,
//                       width: 24.0.dg,
//                       url: Icons.cancel_outlined,
//                       color: AppColorManager.textColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
