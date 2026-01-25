// import 'package:drawable_text/drawable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
// import 'package:livekit_manager/features/room/ui/widget/users/local_user.dart';
//
// import '../../../../core/strings/app_color_manager.dart';
// import '../../../../core/widgets/my_card_widget.dart';
//
// class LocalMedia extends StatelessWidget {
//   const LocalMedia({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RoomCubit, RoomInitial>(
//       builder: (context, state) {
//         return MyCardWidget(
//           cardColor: AppColorManager.appBarColor,
//           padding: EdgeInsets.all(7.0).r,
//           child: Column(
//             children: [
//               DrawableText(
//                 text: 'المحتوى الذي تتم مشاركته',
//                 matchParent: true,
//                 size: 12.0.sp,
//               ),
//               Expanded(
//                 child: LocalUser(participant: state.result.localParticipant),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
