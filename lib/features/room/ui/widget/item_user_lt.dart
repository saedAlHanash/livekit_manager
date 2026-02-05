import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/features/room/ui/widget/controllers.dart';
import 'package:livekit_manager/features/room/ui/widget/users/dynamic_user.dart';

import '../../../../core/strings/app_color_manager.dart';

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
              isSelected: false,
            ),
          ),
          title: DrawableText(text: participant.displayName, selectable: true),
          trailing: participant.userType.isUser ? ControllersDynamic(participant: participant) : null,
        ),
      ),
    );
  }
}
