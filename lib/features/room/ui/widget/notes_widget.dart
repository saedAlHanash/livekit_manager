import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/widgets/my_button.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/features/room/ui/widget/users/dynamic_user.dart';

import '../../../../generated/l10n.dart';

class NotesWidget extends StatelessWidget {
  const NotesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return Column(
          children: [
            DrawableText(
              text: S.of(context).notes,
              matchParent: true,
              drawableEnd: IconButton(
                onPressed: () {
                  context.read<RoomCubit>().clearNotes();
                },
                icon: ImageMultiType(url: Icons.cleaning_services_rounded),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0).r,
                itemCount: state.raiseHands.length,
                separatorBuilder: (context, i) => 10.0.verticalSpace,
                itemBuilder: (context, i) {
                  final item = state.raiseHands[i];

                  final p = state.getParticipantById(item.id);
                  switch (item.action) {
                    case ManagerActions.raiseHand:
                      return ListTile(
                        title: DrawableText(
                          text: item.name,
                          drawableAlin: .between,
                          matchParent: true,
                          drawableEnd: DrawableText(
                            text: '${item.createdAt?.formatDateTime1}',
                            size: 8.0.sp,
                          ),
                        ),
                        subtitle: Column(
                          spacing: 5.0,
                          children: [
                            DrawableText(
                              text: S.of(context).wantsToJoinOrGetPermission,
                              size: 10.0.sp,
                              matchParent: true,
                            ),

                            Row(
                              spacing: 5.0.w,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.check_circle),
                                    onPressed: () {
                                      context.read<RoomCubit>().choseUser(item.userId);
                                      context.read<RoomCubit>().deleteFromCache([item.id]);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.cancel),
                                    color: AppColorManager.red,
                                    onPressed: () {
                                      context.read<RoomCubit>().deleteFromCache([item.id]);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: AppColorManager.secondColor),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                      );
                    case ManagerActions.message:
                      return ListTile(
                        leading: p == null
                            ? 0.0.verticalSpace
                            : UserImageOrName(
                                participant: p,
                                image: item.image,
                                name: item.name,
                                size: 30.0.r,
                              ),
                        title: DrawableText(text: item.name),
                        subtitle: DrawableText(text: item.message),
                        trailing: IconButton(
                          onPressed: () {
                            context.read<RoomCubit>().deleteFromCache([item.id]);
                          },
                          icon: ImageMultiType(url: Icons.delete_outline_rounded),
                        ),
                      );
                    case ManagerActions.achievement:
                    case ManagerActions.chosen:
                    case ManagerActions.lowerHand:
                      return 0.0.verticalSpace;
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
