import 'dart:convert';

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
import '../../data/request/setting_message.dart';

class ItemUserRemote extends StatelessWidget {
  const ItemUserRemote({super.key, required this.i});

  final int i;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final participant = state.participantTracks[i];
        // final audio = state.participantTracks[i].activeAudioTrack;
        final isSelected = participant.sid == state.selectedParticipant?.sid;
        return Container(
          height: 120.0.h,
          decoration: BoxDecoration(
            color: AppColorManager.appBarColor,
            borderRadius: BorderRadius.circular(12.0).r,
            border: Border.all(color: isSelected ? AppColorManager.mainColor : Colors.transparent, width: 3.0),
          ),
          clipBehavior: Clip.hardEdge,
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(12.0).r,
            child: Stack(
              alignment: AlignmentGeometry.center,
              children: [
                UserImageOrName(
                  participant: state.participantTracks[i],
                ),
                Align(
                  alignment: AlignmentGeometry.topCenter,
                  child: Container(
                    width: 1.0.sw,
                    height: 30.0.h,
                    padding: EdgeInsets.all(4.0).r,
                    color: Colors.black38,
                    child: DrawableText(
                      text: participant.name,
                      size: 11.0.sp,
                    ),
                  ),
                ),
                if (state.raiseHands.contains(participant.sid))
                  Align(
                    alignment: AlignmentGeometry.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ImageMultiType(
                        url: Icons.back_hand_outlined,
                        width: 18.0.w,
                      ),
                    ),
                  ),
                Align(
                  alignment: AlignmentGeometry.topLeft,
                  child: BlocBuilder<UserControlCubit, UserControlInitial>(
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ItemUserSpeaker extends StatelessWidget {
  const ItemUserSpeaker({super.key, required this.i});

  final int i;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final participant = state.participantTracks[i];
        final audio = state.participantTracks[i].activeAudioTrack;
        final isSelected = participant.sid == state.selectedParticipant?.sid;
        return Container(
          height: 120.0.h,
          decoration: BoxDecoration(
            color: AppColorManager.appBarColor,
            borderRadius: BorderRadius.circular(12.0).r,
            border: Border.all(color: isSelected ? AppColorManager.mainColor : Colors.transparent, width: 3.0),
          ),
          clipBehavior: Clip.hardEdge,
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(12.0).r,
            child: Stack(
              alignment: AlignmentGeometry.center,
              children: [
                UserImageOrName(
                  participant: state.participantTracks[i],
                ),
                Align(
                  alignment: AlignmentGeometry.topCenter,
                  child: Container(
                    width: 1.0.sw,
                    height: 30.0.h,
                    padding: EdgeInsets.all(4.0).r,
                    color: Colors.black38,
                    child: DrawableText(
                      text: participant.name,
                      size: 11.0.sp,
                    ),
                  ),
                ),
                if (audio != null)
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SoundWaveformWidget(
                        key: ValueKey(audio.hashCode),
                        audioTrack: audio,
                        barCount: 3,
                      ),
                    ),
                  ),
                if (state.raiseHands.contains(participant.sid))
                  Align(
                    alignment: AlignmentGeometry.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ImageMultiType(
                        url: Icons.back_hand_outlined,
                        width: 18.0.w,
                      ),
                    ),
                  ),
                if (participant.userType.isSharer)
                  Align(
                    alignment: AlignmentGeometry.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ImageMultiType(
                        url: Icons.screenshot_monitor,
                        width: 18.0.w,
                      ),
                    ),
                  ),
                Align(
                  alignment: AlignmentGeometry.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: _Switch(participant: participant),
                      ),
                      BlocBuilder<UserControlCubit, UserControlInitial>(
                        builder: (context, state) {
                          if (state.loading) {
                            return SizedBox(
                              height: 24.0.dg,
                              width: 24.0.dg,
                              child: MyStyle.loadingWidget(),
                            );
                          }
                          return DynamicPopupMenu(
                            items: [
                              PopupMenuItemModel(
                                label: (participant.isSuspend) ? 'Resume User' : 'Suspend User',
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
                                label: participant.isMicrophoneEnabled() ? 'Mute' : 'Allow to Speak',
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
                                label: 'Disconnect',
                                icon: ImageMultiType(url: Icons.call_end, color: Colors.red),
                                onTap: () {
                                  context.read<UserControlCubit>().disconnect(participant.identity);
                                },
                              ),
                              PopupMenuItemModel(
                                label: 'Disconnect and Ban',
                                icon: ImageMultiType(url: Icons.block, color: Colors.red),
                              ),
                            ],
                          );
                        },
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

class _Switch extends StatelessWidget {
  const _Switch({required this.participant});

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    final l = ManagerActions.values.where((e) => e != ManagerActions.raseHand);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: l.map(
          (e) {
            return InkWell(
              onTap: () {
                // if (ManagerActions.mic == e) {
                //   context.read<UserControlCubit>()
                //     ..setMuteRequest(
                //       ChangeTrackRequest(
                //         room: context.read<RoomCubit>().state.result.name!,
                //         identity: participant.identity,
                //         trackSid: participant.activeAudioTrack?.sid ?? '',
                //         muted: true,
                //       ),
                //     )
                //     ..muteUser();
                //   return;
                // }
                context.read<RoomCubit>().state.result.localParticipant?.publishData(
                      utf8.encode(
                        jsonEncode(
                          SettingMessage(
                            sid: participant.sid,
                            name: participant.name,
                            action: e,
                          ),
                        ),
                      ),
                    );
              },
              child: BlocBuilder<UserControlCubit, UserControlInitial>(
                buildWhen: (p, c) => e.index == ManagerActions.mic.index,
                builder: (context, state) {
                  if (state.loading) {
                    return MyStyle.loadingWidget();
                  }
                  return ImageMultiType(
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
                  );
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
