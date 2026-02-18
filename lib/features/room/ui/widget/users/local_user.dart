import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/features/room/ui/widget/sound_waveform.dart';

import '../no_video.dart';

class LocalUser extends StatefulWidget {
  const LocalUser({super.key, required this.participant});

  final Participant? participant;

  @override
  State<LocalUser> createState() => _LocalUserState();
}

class _LocalUserState extends State<LocalUser> {
  @override
  void initState() {
    super.initState();
    widget.participant?.addListener(_onParticipantChanged);
    _onParticipantChanged();
  }

  @override
  void dispose() {
    widget.participant?.removeListener(_onParticipantChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LocalUser oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update listeners if the participant actually changed
    if (oldWidget.participant?.sid != widget.participant?.sid) {
      oldWidget.participant?.removeListener(_onParticipantChanged);
      widget.participant?.addListener(_onParticipantChanged);
      _onParticipantChanged();
    }
  }

  void _onParticipantChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (widget.participant == null) return const NoVideoWidget();

    // Check if video is active and track is not muted
    final activeVideoTrack = widget.participant!.activeVideoTrack;
    final isVideoActive = widget.participant!.videoActive && activeVideoTrack != null && !activeVideoTrack.muted;

    return Stack(
      children: [
        isVideoActive
            ? VideoTrackRenderer(
                renderMode: VideoRenderMode.auto,
                fit: VideoViewFit.contain,
                activeVideoTrack,
              )
            : const NoVideoWidget(),
        if (widget.participant!.activeAudioTrack != null)
          Padding(
            padding: const EdgeInsets.all(20.0).r,
            child: Align(
              alignment: Alignment.topRight,
              child: SoundWaveformWidget(
                key: ValueKey(widget.participant!.activeAudioTrack!.hashCode),
                audioTrack: widget.participant!.activeAudioTrack!,
                width: 8,
              ),
            ),
          ),
      ],
    );
  }
}
