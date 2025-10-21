import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/features/room/ui/widget/users/remote_user.dart';
import 'package:m_cubit/m_cubit.dart';

import 'local_user.dart';

class DynamicUser extends StatelessWidget {
  const DynamicUser({super.key, required this.participant, this.fit = VideoViewFit.contain});

  final VideoViewFit fit;
  final Participant participant;

  @override
  Widget build(BuildContext context) {
    if (participant is LocalParticipant) {
      return LocalUser(participantTrack: participant);
    } else if (participant is RemoteParticipant) {
      return RemoteUser(participantTrack: participant);
    }
    throw UnimplementedError('Unknown participant type');
  }
}

class UserImageOrName extends StatelessWidget {
  const UserImageOrName({super.key, required this.participant});

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    return (!participant.attributes['imageUrl'].toString().isBlank)
        ? ImageMultiType(
            url: participant.attributes['imageUrl'],
            fit: BoxFit.cover,
          )
        : Container(
            height: 60.0,
            width: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: participant.sid.colorFromId),
            ),
            alignment: AlignmentGeometry.center,
            child: DrawableText(
              text: participant.displayName.firstCharacter.toUpperCase(),
              size: 30.0.sp,
            ),
          );
  }
}
