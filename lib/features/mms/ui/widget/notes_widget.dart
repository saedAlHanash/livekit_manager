import 'dart:convert';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/features/mms/bloc/room_cubit/room_cubit.dart';
import 'package:livekit_manager/features/mms/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/features/mms/ui/widget/users/dynamic_user.dart';

import '../../../../core/widgets/my_card_widget.dart';
import '../../../../generated/l10n.dart';
import '../../data/request/setting_message.dart';

class NotesWidget extends StatelessWidget {
  const NotesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return MyCardWidget(
          cardColor: AppColorManager.appBarColor,
          padding: EdgeInsets.all(15.0).r,
          child: Column(
            children: [
              DrawableText(
                text: S.of(context).notes,
                matchParent: true,
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(15.0).r,
                  itemCount: state.raiseHands.length,
                  separatorBuilder: (context, i) => 10.0.verticalSpace,
                  itemBuilder: (context, i) {
                    final item = state.raiseHands[i];

                    final p = state.getParticipantById(item.id);
                    switch (item.action) {
                      case ManagerActions.requestPermission:
                        return ListTile(
                          leading: UserImageOrName(
                            participant: p,
                            image: item.image,
                            name: item.name,
                            size: 30.0.r,
                          ),
                          title: DrawableText(text: '${item.name} ${S.of(context).requestedPermission}'),
                          subtitle: DrawableText(text: S.of(context).wantsToJoinOrGetPermission),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle, color: Colors.green),
                                onPressed: () {
                                  state.result.localParticipant?.publishData(
                                    utf8.encode(
                                      jsonEncode(
                                        SettingMessage(
                                          id: item.id,
                                          toUserType: LkUserType.user,
                                          toIdentity: item.id,
                                          action: ManagerActions.message,
                                          metadata: {
                                            'name': '',
                                            'message': 'Accept your permission request',
                                            'id': '',
                                          },
                                        ),
                                      ),
                                    ),
                                  );

                                  context.read<RoomCubit>().deleteFromCache(item.id);
                                  context.read<UserControlCubit>().allowToSpeak(item.id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () {
                                  state.result.localParticipant?.publishData(
                                    utf8.encode(
                                      jsonEncode(
                                        SettingMessage(
                                          id: item.id,
                                          toUserType: LkUserType.user,
                                          toIdentity: item.id,
                                          action: ManagerActions.message,
                                          metadata: {
                                            'name': '',
                                            'message': 'rejected your permission request',
                                            'id': '',
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                  context.read<RoomCubit>().deleteFromCache(item.id);
                                },
                              ),
                            ],
                          ),
                        );

                      case ManagerActions.message:
                        return ListTile(
                          leading: UserImageOrName(
                            participant: p,
                            image: item.image,
                            name: item.name,
                            size: 30.0.r,
                          ),
                          title: DrawableText(text: item.name),
                          subtitle: DrawableText(text: item.message),
                          trailing: IconButton(
                            onPressed: () {
                              context.read<RoomCubit>().deleteFromCache(item.id);
                            },
                            icon: ImageMultiType(url: Icons.delete_outline_rounded),
                          ),
                        );

                      case ManagerActions.chosen:
                      case ManagerActions.achievement:
                        return 0.0.verticalSpace;
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
