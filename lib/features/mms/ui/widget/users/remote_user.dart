import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';

import '../no_video.dart';

class RemoteUser extends StatefulWidget {
  const RemoteUser({super.key, required this.participant, this.fit = VideoViewFit.contain});

  final Participant participant;
  final VideoViewFit fit;

  @override
  State<RemoteUser> createState() => _RemoteUserState();
}

class _RemoteUserState extends State<RemoteUser> {
  @override
  void initState() {
    super.initState();
    widget.participant.addListener(_onParticipantChanged);
    _onParticipantChanged();
  }

  @override
  void dispose() {
    widget.participant.removeListener(_onParticipantChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RemoteUser oldWidget) {
    oldWidget.participant.remoteParticipant.removeListener(_onParticipantChanged);
    widget.participant.addListener(_onParticipantChanged);
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
    return widget.participant.primaryTrack != null
        ? Row(
            children: [
              Expanded(
                child: VideoTrackRenderer(
                  renderMode: VideoRenderMode.auto,
                  fit: widget.fit,
                  widget.participant.primaryTrack!,
                ),
              ),
            ],
          )
        : const NoVideoWidget();
  }
}
