import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../../core/strings/enum_manager.dart';

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
        ? VideoTrackRenderer(
            renderMode: VideoRenderMode.auto,
            fit: widget.fit,
            widget.participant.activeVideoTrack!,
          )
        : (!widget.participant.attributes['imageUrl'].toString().isBlank)
            ? ImageMultiType(
                url: widget.participant.attributes['imageUrl'],
                fit: BoxFit.contain,
                height: 100.0.r,
                width: 100.0.r,
              )
            : Container(
                height: 60.0,
                width: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.participant.sid.colorFromId),
                ),
                alignment: AlignmentGeometry.center,
                child: DrawableText(
                  text: widget.participant.displayName.firstCharacter.toUpperCase(),
                  size: 30.0.sp,
                ),
              );
  }
}
