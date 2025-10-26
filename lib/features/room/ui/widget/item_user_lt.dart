import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/features/room/ui/widget/controllers.dart';
import 'package:livekit_manager/features/room/ui/widget/users/dynamic_user.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../bloc/room_cubit/room_cubit.dart';

class ItemUserRemoteLT extends StatelessWidget {
  const ItemUserRemoteLT({super.key, required this.i});

  final int i;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final participant = state.participant[i];
        final isSelected = participant.identity == state.selectedParticipant?.identity;
        return Opacity(
          opacity: participant.isSuspend ? 0.5 : 1,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColorManager.cardColor : AppColorManager.appBarColor,
              borderRadius: BorderRadius.circular(12.0).r,
            ),
            child: ListTile(
              onTap: () {
                context.read<RoomCubit>().selectParticipant(participant.identity);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0).r,
              leading: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(200),
                child: UserImageOrName(
                  participant: state.participant[i],
                  size: 40.0.dg,
                ),
              ),
              title: DrawableText(text: participant.displayName),
              trailing: participant.isAdmin ? null : ControllersDynamic(participant: participant),
            ),
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
