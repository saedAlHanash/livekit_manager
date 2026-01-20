import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../../core/strings/enum_manager.dart';
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
    return widget.participant.videoActive
        ? Row(
            children: [
              for (var o in widget.participant.remoteVideoPublications)
                if (o.track != null)
                  Expanded(
                    child: VideoTrackRenderer(
                      renderMode: VideoRenderMode.auto,
                      fit: widget.fit,
                      o.track!,
                    ),
                  ),
            ],
          )
        : const NoVideoWidget();
  }
}

class ListRemoteUser extends StatelessWidget {
  const ListRemoteUser({super.key, required this.participants, required this.fit});

  final List<Participant> participants;
  final VideoViewFit fit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: participants
          .map(
            (e) => Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: AppColorManager.mainColor)),
                child: RemoteUser(participant: e),
              ),
            ),
          )
          .toList(),
    );
  }
}
