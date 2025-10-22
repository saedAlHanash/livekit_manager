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
import 'item_user_lt.dart';

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
              ],
            ),
          ),
        );
      },
    );
  }
}
