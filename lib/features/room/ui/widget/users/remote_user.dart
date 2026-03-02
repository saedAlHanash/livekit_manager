import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'participants_layout.dart';

class RemoteUser extends StatelessWidget {
  const RemoteUser({super.key, required this.participant, this.fit = VideoViewFit.contain});

  final Participant participant;
  final VideoViewFit fit;

  @override
  Widget build(BuildContext context) {
    // Picking the first camera track for simplicity here, or just use the ParticipantCard
    final videoPub = participant.videoPublicationList.firstOrNull;
    if (videoPub == null || videoPub.track == null) return const SizedBox();

    return VideoTrackRenderer(
      videoPub.track as VideoTrack,
      fit: fit,
      renderMode: VideoRenderMode.auto,
    );
  }
}

class ListRemoteUser extends StatelessWidget {
  const ListRemoteUser({super.key, required this.participants, required this.fit});

  final List<Participant> participants;
  final VideoViewFit fit;

  @override
  Widget build(BuildContext context) {
    // The ParticipantsLayout now handles layout (grid or master/sidebar)
    return ParticipantsLayout(
      participants: participants,
      fit: fit,
    );
  }
}
