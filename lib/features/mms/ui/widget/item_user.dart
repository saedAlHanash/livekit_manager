import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/features/mms/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/features/mms/ui/widget/users/dynamic_user.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import 'controllers.dart';

class ItemUserRemote extends StatelessWidget {
  const ItemUserRemote({super.key, required this.i});

  final int i;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MMSRoomCubit, MMSRoomInitial>(
      builder: (context, state) {
        final participant = state.participant[i];
        // final audio = state.participantTracks[i].activeAudioTrack;
        final isSelected = participant.identity == state.selectedParticipant?.identity;
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
                  participant: state.participant[i],
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
                if (state.requestPermissions.contains(participant.identity))
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
    return BlocBuilder<MMSRoomCubit, MMSRoomInitial>(
      builder: (context, state) {
        final participant = state.speakers[i];
        final isSelected = participant.identity == state.selectedParticipant?.identity;
        return InkWell(
          onTap: () {
            context.read<MMSRoomCubit>().selectParticipant(participant.identity);
          },
          child: Container(
            height: 120.0.h,
            decoration: BoxDecoration(
              color: AppColorManager.appBarColor,
              borderRadius: BorderRadius.circular(12.0).r,
              border: Border.all(color: isSelected ? AppColorManager.mainColor : Colors.transparent, width: 3.0),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              alignment: AlignmentGeometry.center,
              children: [
                UserImageOrName(
                  participant: participant,
                ),
                Align(
                  alignment: AlignmentGeometry.bottomCenter,
                  child: Container(
                    width: 1.0.sw,
                    height: 30.0.h,
                    padding: EdgeInsets.all(4.0).r,
                    color: Colors.black26,
                    child: DrawableText(
                      text: participant.name,
                      matchParent: true,
                      textAlign: TextAlign.center,
                      size: 11.0.sp,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentGeometry.topLeft,
                  child: participant.userType.isManager
                      ? null
                      : ControllersDynamic(participant: participant, speaker: true),
                ),
                Align(
                  alignment: AlignmentGeometry.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 7.0.w,
                      children: [
                        if (!participant.isMuted)
                          InkWell(
                            child: ImageMultiType(
                              url: !participant.isMuted ? Icons.mic : Icons.mic_off,
                            ),
                          ),
                        if (participant.isCameraEnabled())
                          InkWell(
                            child: ImageMultiType(
                              url: !participant.isCameraEnabled()
                                  ? Icons.videocam_off_outlined
                                  : Icons.videocam_outlined,
                              // color: participant.isMuted ? Colors.red : Colors.green,
                            ),
                          ),
                        if (participant.isScreenShareEnabled())
                          InkWell(
                            child: ImageMultiType(
                              url: !participant.isScreenShareEnabled()
                                  ? Icons.stop_screen_share_outlined
                                  : Icons.screen_share_outlined,
                              // color: participant.isMuted ? Colors.red : Colors.green,
                            ),
                          ),
                      ],
                    ),
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
