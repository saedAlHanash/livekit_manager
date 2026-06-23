import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';import 'package:m_cubit/util.dart';

class RemoteUser extends StatelessWidget {
  const RemoteUser({super.key, required this.participant, this.fit = VideoViewFit.contain});

  final Participant participant;
  final VideoViewFit fit;

  @override
  Widget build(BuildContext context) {
    final videoPub = participant.videoPublicationList.firstOrNull;
    if (videoPub == null || videoPub.track == null) return const SizedBox();

    return VideoTrackRenderer(
      videoPub.track as VideoTrack,
      fit: fit,
      renderMode: VideoRenderMode.auto,
    );
  }
}
