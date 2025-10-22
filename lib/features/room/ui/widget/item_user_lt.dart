import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/widgets/menu_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/sound_waveform.dart';
import 'package:livekit_manager/features/room/ui/widget/users/dynamic_user.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/my_style.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import '../../bloc/user_control_cubit/user_control_cubit.dart';

class ItemUserRemoteLT extends StatelessWidget {
  const ItemUserRemoteLT({super.key, required this.i});

  final int i;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final participant = state.participantTracks[i];
        // final audio = state.participantTracks[i].activeAudioTrack;
        final isSelected = participant.sid == state.selectedParticipant?.sid;
        return Container(
          decoration: BoxDecoration(
              color: isSelected ? AppColorManager.cardColor : AppColorManager.appBarColor,
              borderRadius: BorderRadius.circular(12.0).r),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(200),
              child: UserImageOrName(
                participant: state.participantTracks[i],
                size: 40.0.dg,
              ),
            ),
            title: DrawableText(text: participant.displayName),
            trailing: BlocBuilder<UserControlCubit, UserControlInitial>(
              builder: (context, state) {
                if (state.loading) {
                  return SizedBox(
                    height: 24.0.dg,
                    width: 24.0.dg,
                    child: MyStyle.loadingWidget(),
                  );
                }
                return DynamicPopupMenu(
                  icon: Icons.menu,
                  items: [
                    PopupMenuItemModel(
                      label: (participant.isSuspend) ? S.of(context).resumeUser : S.of(context).suspendUser,
                      icon: participant.isSuspend ? Icons.play_arrow : Icons.pause,
                      onTap: () {
                        if (participant.isSuspend) {
                          context.read<UserControlCubit>().resume(participant.identity);
                        } else {
                          context.read<UserControlCubit>().suspend(participant.identity);
                        }
                      },
                    ),
                    PopupMenuItemModel(
                      label: participant.isMicrophoneEnabled() ? S.of(context).mute : S.of(context).allowToSpeak,
                      icon: participant.isMicrophoneEnabled() ? Icons.mic_off : Icons.mic,
                      onTap: () {
                        if (participant.permissions.canPublish) {
                          context.read<UserControlCubit>().muteUser(participant.identity);
                        } else {
                          context.read<UserControlCubit>().resume(participant.identity);
                        }
                      },
                    ),
                    PopupMenuItemModel(
                      label: S.of(context).disconnect,
                      icon: ImageMultiType(url: Icons.call_end, color: Colors.red),
                      onTap: () {
                        context.read<UserControlCubit>().disconnect(participant.identity);
                      },
                    ),
                    PopupMenuItemModel(
                      label: S.of(context).disconnectAndBan,
                      icon: ImageMultiType(url: Icons.block, color: Colors.red),
                    ),
                  ],
                );
              },
            ),
            subtitle: ListStateUser(participant: participant),
          ),
        );
      },
    );
  }
}

class ListStateUser extends StatelessWidget {
  const ListStateUser({super.key, required this.participant});

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    final l = ManagerActions.values.where((e) => e != ManagerActions.raseHand);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: l.map(
          (e) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ImageMultiType(
                url: e.icon,
                height: 15.0.r,
                width: 15.0.r,
                color: switch (e) {
                  ManagerActions.mic => participant.isMicrophoneEnabled(),
                  ManagerActions.video => participant.isCameraEnabled(),
                  ManagerActions.shareScreen => participant.isScreenShareEnabled(),
                  ManagerActions.raseHand => true,
                }
                    ? Colors.green
                    : Colors.red,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
