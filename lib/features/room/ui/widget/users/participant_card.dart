import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/util/my_style.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';

import 'no_video.dart';

class ParticipantCard extends StatefulWidget {
  const ParticipantCard({
    super.key,
    required this.participant,
    required this.fit,
    this.isMaster = false,
    this.onTap,
    this.small = false,
  });

  final Participant? participant;
  final VideoViewFit fit;
  final bool isMaster;
  final VoidCallback? onTap;
  final bool small;

  @override
  State<ParticipantCard> createState() => _ParticipantCardState();
}

class _ParticipantCardState extends State<ParticipantCard> {
  @override
  void initState() {
    super.initState();
    widget.participant?.addListener(_update);
  }

  @override
  void dispose() {
    widget.participant?.removeListener(_update);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ParticipantCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.participant?.identity != widget.participant?.identity) {
      oldWidget.participant?.removeListener(_update);
      widget.participant?.addListener(_update);
    }
  }

  void _update() {
    if (mounted) setState(() {});
  }

  var loadingChoseUser = false;

  @override
  Widget build(BuildContext context) {
    final participant = widget.participant;
    if (participant == null) return Container();
    final primaryTrack = participant.primaryTrack;
    final secondaryTrack = participant.secondaryTrack;
    final chosen = participant.isChosen;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColorManager.appBarColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: chosen ? AppColorManager.secondColor : AppColorManager.secondColor, width: 2.0),
          boxShadow: chosen
              ? [
                  BoxShadow(color: Colors.black, blurRadius: 12, offset: const Offset(0, 4)),
                ]
              : null,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Video or Placeholder
            Positioned.fill(
              child: primaryTrack != null
                  ? VideoTrackRenderer(primaryTrack, fit: widget.fit, renderMode: VideoRenderMode.auto)
                  : Center(child: NoVideoWidget(type: participant.userType)),
            ),

            if (secondaryTrack != null)
              Align(
                alignment: .topRight,
                child: Container(
                  width: widget.small ? 35.r : 60.r,
                  height: widget.small ? 35.r : 60.r,
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
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: BoxDecoration(color: Colors.black45),
                child: DrawableText(
                  text: participant.displayName,
                  color: Colors.white,
                  size: 10.0.sp,
                  // drawablePadding: 5.0,
                  // drawableStart: participant.connectionQuality.icon,
                ),
              ),
            ),
            if (participant.isRemoteUser)
              Align(
                alignment: .topLeft,
                child: IconButton(
                  onPressed: () async {
                    setState(() => loadingChoseUser = true);
                    await context.read<RoomCubit>().choseUser(participant.identity);
                    setState(() => loadingChoseUser = false);
                  },
                  icon: loadingChoseUser
                      ? MyStyle.loadingW()
                      : ImageMultiType(url: chosen ? Icons.check_box : Icons.check_box_outline_blank),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
