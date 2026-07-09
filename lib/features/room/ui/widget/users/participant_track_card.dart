import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';

import '../../../../../core/widgets/no_video.dart';
import 'participant_track_source.dart';

class ParticipantTrackCard extends StatefulWidget {
  const ParticipantTrackCard({
    super.key,
    required this.source,
    required this.fit,
    this.isMaster = false,
    this.onTap,
    this.controllers,
    this.isSelected = false,
  });

  final ParticipantTrackSource source;
  final VideoViewFit fit;
  final bool isMaster;
  final VoidCallback? onTap;
  final Widget? controllers;
  final bool isSelected;

  @override
  State<ParticipantTrackCard> createState() => _ParticipantTrackCardState();
}

class _ParticipantTrackCardState extends State<ParticipantTrackCard> {
  @override
  void initState() {
    super.initState();
    widget.source.participant.addListener(_update);
  }

  @override
  void dispose() {
    widget.source.participant.removeListener(_update);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ParticipantTrackCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source.id != widget.source.id) {
      oldWidget.source.participant.removeListener(_update);
      widget.source.participant.addListener(_update);
    }
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final participant = widget.source.participant;
    final track = widget.source.videoTrack;
    final isVideoVisible = widget.source.isVideoActive && track != null;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: widget.isSelected ? AppColorManager.mainColor : Colors.transparent,
            width: 2.0,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Video or Placeholder (The Display)
            Positioned.fill(
              child: isVideoVisible
                  ? VideoTrackRenderer(
                      track,
                      fit: widget.fit,
                      renderMode: VideoRenderMode.auto,
                    )
                  : const Center(child: NoVideoWidget()),
            ),

            // Name & Status Overlay (Display Part)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    // Mute Status Icon
                    Icon(
                      participant.isMuted ? Icons.mic_off : Icons.mic,
                      color: participant.isMuted ? Colors.red : Colors.green,
                      size: 14.r,
                    ),
                    8.horizontalSpace,
                    // Name
                    Expanded(
                      child: DrawableText(
                        text: widget.source.displayName,
                        size: 12.r,
                        color: Colors.white,
                        maxLines: 1,
                      ),
                    ),
                    // Connection Quality
                    _buildConnectionQuality(participant.connectionQuality),
                  ],
                ),
              ),
            ),

            // Controllers slot
            if (widget.controllers != null)
              Positioned(
                top: 5,
                right: 5,
                child: widget.controllers!,
              ),

            // Small screen share icon overlay if applicable
            if (widget.source.isScreenShare)
              Positioned(
                top: 8.r,
                left: 8.r,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(Icons.screen_share, size: 16.r, color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionQuality(ConnectionQuality quality) {
    Color color;
    switch (quality) {
      case ConnectionQuality.excellent:
        color = Colors.green;
        break;
      case ConnectionQuality.good:
        color = Colors.yellow;
        break;
      case ConnectionQuality.poor:
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => Container(
          width: 4.r,
          height: 4.r,
          margin: EdgeInsets.only(left: 2.r),
          decoration: BoxDecoration(
            color: (quality == ConnectionQuality.poor && index > 0) ? color.withValues(alpha: 0.3) : color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
