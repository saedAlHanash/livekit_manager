import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';import 'package:m_cubit/util.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';

import '../../../mms/ui/widget/controllers.dart';
import '../../../mms/ui/widget/users/dynamic_user.dart';
import '../../bloc/room_cubit/room_cubit.dart';

class ManagersWidget extends StatelessWidget {
  const ManagersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final l = state.participants.where((e) => !e.userType.isUser).toList();
        return Container(
          decoration: BoxDecoration(
            color: AppColorManager.appBarColor,
            borderRadius: BorderRadius.circular(12.0).r,
          ),
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0).r,
          child: ListView.separated(
            separatorBuilder: (context, index) => 10.0.verticalSpace,
            itemCount: l.length,
            padding: EdgeInsets.all(15.0),
            itemBuilder: (context, i) {
              return ItemUserRemoteLT(
                participant: l[i],
                isSelected: l[i].identity == state.selectedParticipant?.identity,
              );
            },
          ),
        );
      },
    );
  }
}

class ItemUserRemoteLT extends StatelessWidget {
  const ItemUserRemoteLT({super.key, required this.participant, required this.isSelected});

  final Participant participant;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: participant.isSuspend ? 0.5 : 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColorManager.cardColor,
          borderRadius: BorderRadius.circular(12.0).r,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0).r,
          leading: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(200),
            child: UserImageOrName(
              participant: participant,
              size: 40.0.dg,
            ),
          ),
          title: DrawableText(text: participant.displayName, selectable: true),
          trailing: participant.userType.isUser ? ControllersDynamic(participant: participant) : null,
        ),
      ),
    );
  }
}
