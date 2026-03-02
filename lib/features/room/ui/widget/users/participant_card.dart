import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:collection/collection.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import '../no_video.dart';

class ParticipantCard extends StatefulWidget {
  const ParticipantCard({
    super.key,
    required this.participant,
    required this.fit,
    this.isMaster = false,
    this.onTap,
    this.isSelected = false,
  });

  final Participant participant;
  final VideoViewFit fit;
  final bool isMaster;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  State<ParticipantCard> createState() => _ParticipantCardState();
}

class _ParticipantCardState extends State<ParticipantCard> {
  @override
  void initState() {
    super.initState();
    widget.participant.addListener(_update);
  }

  @override
  void dispose() {
    widget.participant.removeListener(_update);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ParticipantCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.participant.identity != widget.participant.identity) {
      oldWidget.participant.removeListener(_update);
      widget.participant.addListener(_update);
    }
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final participant = widget.participant;

    final screenTrack =
        participant.videoTrackPublications.firstWhereOrNull((e) => e.isScreenShare)?.track as VideoTrack?;
    final cameraTrack =
        participant.videoTrackPublications.firstWhereOrNull((e) => !e.isScreenShare)?.track as VideoTrack?;

    final bool hasScreenShare = screenTrack != null && !screenTrack.muted;
    final bool hasCamera = cameraTrack != null && !cameraTrack.muted;

    final primaryTrack = hasScreenShare ? screenTrack : cameraTrack;

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
            // Video or Placeholder
            Positioned.fill(
              child: primaryTrack != null
                  ? VideoTrackRenderer(
                      primaryTrack,
                      fit: widget.fit,
                      renderMode: VideoRenderMode.auto,
                    )
                  : const Center(child: NoVideoWidget()),
            ),

            // Camera Overlay (Circle) if screen share is also active
            if (hasScreenShare && hasCamera)
              Positioned(
                top: 10.r,
                right: 10.r,
                child: Container(
                  width: widget.isMaster ? 120.r : 60.r,
                  height: widget.isMaster ? 120.r : 60.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColorManager.mainColor, width: 2.r),
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5.r,
                        spreadRadius: 1.r,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: VideoTrackRenderer(
                    cameraTrack,
                    fit: VideoViewFit.cover,
                  ),
                ),
              ),

            // Name & Status Overlay
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
                      participant.isAudioEnabled ? Icons.mic : Icons.mic_off,
                      color: participant.isAudioEnabled ? Colors.green : Colors.red,
                      size: 14.r,
                    ),
                    8.horizontalSpace,
                    // Name
                    Expanded(
                      child: DrawableText(
                        text: participant.displayName,
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
            color: (quality == ConnectionQuality.poor && index > 0) ? color.withOpacity(0.3) : color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
