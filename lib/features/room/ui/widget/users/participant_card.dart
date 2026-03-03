import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';

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
    final primaryTrack = participant.primaryTrack;
    final secondaryTrack = participant.secondaryTrack;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColorManager.mainColor,
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
                  ? VideoTrackRenderer(primaryTrack, fit: widget.fit, renderMode: VideoRenderMode.auto)
                  : const Center(child: NoVideoWidget()),
            ),

            if (secondaryTrack != null)
              Align(
                alignment: .topRight,
                child: Container(
                  width: widget.isMaster ? 120.r : 60.r,
                  height: widget.isMaster ? 120.r : 60.r,
                  margin: EdgeInsets.all(7.0).r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColorManager.secondColor, width: 2.r),
                    color: AppColorManager.secondColor,
                  ),
                  clipBehavior: .hardEdge,
                  child: Transform.scale(
                    scale: 1.1,
                    child: VideoTrackRenderer(
                      secondaryTrack,
                      fit: VideoViewFit.cover,
                    ),
                  ),
                ),
              ),

            Align(
              alignment: .bottomRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0).r, color: Colors.black45),
                child: DrawableText(
                  text: participant.displayName,
                  color: Colors.white,
                  maxLines: 1,
                  drawablePadding: 5.0,
                  drawableStart: participant.connectionQuality.icon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
