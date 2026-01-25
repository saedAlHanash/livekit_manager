import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/widgets/my_card_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/sound_waveform.dart';

import '../../../../../core/strings/enum_manager.dart';
import '../no_video.dart';

class LocalUser extends StatefulWidget {
  const LocalUser({super.key, required this.participant, required this.fit});

  final Participant participant;
  final VideoViewFit fit;

  @override
  State<LocalUser> createState() => _LocalUserState();
}

class _LocalUserState extends State<LocalUser> {
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
  void didUpdateWidget(covariant LocalUser oldWidget) {
    oldWidget.participant.localParticipant.removeListener(_onParticipantChanged);
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
    return Stack(
      children: [
        _V(participant: widget.participant),
        if (widget.participant.activeAudioTrack != null)
          Padding(
            padding: const EdgeInsets.all(20.0).r,
            child: Align(
              alignment: Alignment.topRight,
              child: SoundWaveformWidget(
                key: ValueKey(widget.participant.activeAudioTrack!.hashCode),
                audioTrack: widget.participant.activeAudioTrack!,
                width: 8,
              ),
            ),
          ),
      ],
    );
  }
}

class _V extends StatelessWidget {
  const _V({super.key, required this.participant});

  final Participant participant;

  @override
  Widget build(BuildContext ctx) {
    final isHaveScreenSharing = participant.localVideoPublications.any((e) => e.isScreenShare);

    return Stack(
      children: participant.localVideoPublications.map(
            (e) {
          if (e.track == null || e.track!.muted) return 0.0.verticalSpace;

          if ((!e.isScreenShare) && isHaveScreenSharing) {
            return Align(
              alignment: .bottomRight,
              child: SafeArea(
                child: Container(
                  height: 100.0.r,
                  width: 100.0.r,
                  decoration: BoxDecoration(
                    shape: .circle,
                  ),
                  clipBehavior: .hardEdge,
                  child: VideoTrackRenderer(renderMode: VideoRenderMode.auto, fit: .cover, e.track!),
                ),
              ),
            );
          }
          return VideoTrackRenderer(renderMode: VideoRenderMode.auto, fit: .cover, e.track!);
        },
      ).toList(),
    );
  }
}
