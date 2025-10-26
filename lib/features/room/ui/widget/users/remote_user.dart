import 'package:flutter/material.dart';
import 'package:image_multi_type/image_multi_type_pakage.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:lk_assistant/core/extensions/extensions.dart';
import 'package:lk_assistant/features/room/ui/widget/participant_info.dart';

import '../../../../../core/strings/enum_manager.dart';

class RemoteUser extends StatefulWidget {
  const RemoteUser({super.key, required this.participant});

  final Participant participant;

  @override
  State<RemoteUser> createState() => _RemoteUserState();
}

class _RemoteUserState extends State<RemoteUser> {
  Participant get participant => widget.participant;

  @override
  void initState() {
    super.initState();
    participant.addListener(_onParticipantChanged);
    _onParticipantChanged();
  }

  @override
  void dispose() {
    participant.removeListener(_onParticipantChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RemoteUser oldWidget) {
    oldWidget.participant.removeListener(_onParticipantChanged);
    participant.addListener(_onParticipantChanged);
    _onParticipantChanged();
    super.didUpdateWidget(oldWidget);
  }

  void _onParticipantChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return participant.videoActive
        ? VideoTrackRenderer(
            renderMode: VideoRenderMode.auto,
            participant.activeVideoTrack!,
          )
        : Center(
            child: RoundImageWidget(
              url: participant.attributes['imageUrl'],
              fit: BoxFit.cover,
            ),
          );
  }
}
