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
  const LocalUser({super.key, required this.participant, this.fit = VideoViewFit.contain});

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
    return widget.participant.videoActive
        ? Row(
            children: [
              for (var o in widget.participant.localVideoPublication)
                Expanded(
                  child: VideoTrackRenderer(
                    renderMode: VideoRenderMode.auto,
                    fit: widget.fit,
                    o.track as VideoTrack,
                  ),
                ),
            ],
          )
        : const NoVideoWidget();
  }
}
