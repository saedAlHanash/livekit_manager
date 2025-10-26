import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:lk_assistant/core/extensions/extensions.dart';
import 'package:lk_assistant/core/widgets/my_card_widget.dart';
import 'package:lk_assistant/features/room/ui/widget/participant_info.dart';
import 'package:lk_assistant/features/room/ui/widget/sound_waveform.dart';

import '../../../../../core/strings/enum_manager.dart';
import '../no_video.dart';

class LocalUser extends StatefulWidget {
  const LocalUser({super.key, required this.participant});

  final Participant participant;

  @override
  State<LocalUser> createState() => _LocalUserState();
}

class _LocalUserState extends State<LocalUser> {
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
  void didUpdateWidget(covariant LocalUser oldWidget) {
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
    return Stack(
      children: [
        participant.videoActive
            ? MyCardWidget(
                margin: EdgeInsets.all(20.0).r,
                radios: 20.0,
                child: VideoTrackRenderer(
                  renderMode: VideoRenderMode.auto,
                  participant.activeVideoTrack!,
                ),
              )
            : const NoVideoWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: ParticipantInfoWidget(
            title: participant.displayName,
            connectionQuality: participant.connectionQuality,
            enabledE2EE: participant.isEncrypted,
          ),
        ),
        if (participant.activeAudioTrack != null)
          Padding(
            padding: const EdgeInsets.all(20.0).r,
            child: Align(
                alignment: Alignment.topRight,
                child: SoundWaveformWidget(
                  key: ValueKey(participant.activeAudioTrack!.hashCode),
                  audioTrack: participant.activeAudioTrack!,
                  width: 8,
                )),
          ),
      ],
    );
  }
}
