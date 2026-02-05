import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/circle_image_widget.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/features/room/ui/widget/users/remote_user.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../../generated/assets.dart';
import '../controllers.dart';
import 'local_user.dart';

class DynamicUser extends StatelessWidget {
  const DynamicUser({super.key, required this.participant, this.fit = VideoViewFit.contain});

  final VideoViewFit fit;
  final Participant participant;

  @override
  Widget build(BuildContext context) {
    if (participant is LocalParticipant) {
      return LocalUser(participant: participant);
    } else if (participant is RemoteParticipant) {
      return RemoteUser(participant: participant);
    }
    throw UnimplementedError('Unknown participant type');
  }
}

class UserImageOrName extends StatelessWidget {
  const UserImageOrName({
    super.key,
    required this.participant,
    this.size = 60.0,
    this.image,
    this.name,
    required this.isSelected,
    this.onTap,
  });

  final Participant participant;
  final String? image;
  final String? name;
  final double size;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColorManager.secondColor.withValues(alpha: 0.5) : null,
        borderRadius: BorderRadius.circular(12.0).r,
      ),
      child: ListTile(
        onTap: onTap,
        leading: SizedBox(
          height: 50.0.r,
          width: 50.0.r,
          child: Stack(
            children: [
              Center(
                child: CircleImageWidget(
                  url: participant.image,
                  size: 35.0.r,
                ),
              ),
              if (!participant.userType.isUser)
                Align(
                  alignment: .topRight,
                  child: ImageMultiType(url: Icons.star, color: AppColorManager.ampere, width: 15.0.r),
                ),
            ],
          ),
        ),
        title: DrawableText(text: participant.name ?? '-'),
        subtitle: Padding(
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
                    url: !participant.isCameraEnabled() ? Icons.videocam_off_outlined : Icons.videocam_outlined,
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
              Spacer(),
              if (!participant.isAudioEnabled)
                InkWell(
                  child: ImageMultiType(
                    url: !participant.isAudioEnabled ? Icons.volume_off : Icons.volume_up,
                    color: AppColorManager.ampere,
                  ),
                ),
            ],
          ),
        ),
        trailing: ControllersDynamic(participant: participant, speaker: true),
      ),
    );
  }
}
