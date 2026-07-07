import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/generated/l10n.dart';

import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:m_cubit/util.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/util/my_style.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
import 'package:livekit_manager/features/user/data/response/user_response.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../../core/strings/enum_manager.dart';
import '../../../data/request/setting_message.dart';

import 'no_video.dart';

class ParticipantCard extends StatefulWidget {
  const ParticipantCard({
    super.key,
    required this.participant,
    this.user,
    this.fit = VideoViewFit.contain,
    this.justShow = false,
    this.onTap,
    this.small = false,
  });

  final Participant? participant;
  final User? user;
  final VideoViewFit fit;
  final bool justShow;
  final VoidCallback? onTap;
  final bool small;

  @override
  State<ParticipantCard> createState() => _ParticipantCardState();
}

class _ParticipantCardState extends State<ParticipantCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    widget.participant?.addListener(_update);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    widget.participant?.removeListener(_update);
    _controller.dispose();
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

    if (participant == null) {
      return UserWider(user: widget.user);
    }

    final primaryTrack = participant.primaryTrack;
    final secondaryTrack = participant.secondaryTrack;
    final chosen = participant.isChosen;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          // Animated border for chosen speaker
          if (chosen && !widget.justShow)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final color = Color.lerp(AppColorManager.ampere, Colors.white, _animation.value);
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: color!.withOpacity(0.4 * (1 - _animation.value)),
                          spreadRadius: 15.r * _animation.value,
                          blurRadius: 20.r * _animation.value,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: AppColorManager.mainColorDark,
              borderRadius: BorderRadius.circular(16.r),
              border: widget.justShow
                  ? null
                  : Border.all(
                      color: chosen ? AppColorManager.ampere : Colors.white10,
                      width: chosen ? 3.r : 1.r,
                    ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                // Video Stream
                Positioned.fill(
                  child: primaryTrack != null
                      ? VideoTrackRenderer(primaryTrack, fit: widget.fit, renderMode: VideoRenderMode.auto)
                      : Center(child: NoVideoWidget(type: participant.userType)),
                ),

                // Pip Video (Screen share etc)
                if (secondaryTrack != null)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: widget.small ? 40.r : 80.r,
                      height: widget.small ? 40.r : 80.r,
                      margin: EdgeInsets.all(8.0).r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColorManager.secondColor, width: 2.r),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.r)],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: VideoTrackRenderer(
                        secondaryTrack,
                        fit: VideoViewFit.cover,
                      ),
                    ),
                  ),

                // Status Bar Bottom (Name + Permissions)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DrawableText(
                            text: participant.displayName,
                            color: Colors.white,
                            size: widget.small ? 10.sp : 14.sp,
                            fontWeight: FontWeight.bold,
                            maxLines: 1,
                          ),
                        ),
                        if (!widget.justShow && participant.isRemoteUser)
                          BlocBuilder<RoomCubit, RoomInitial>(
                            builder: (context, roomState) {
                              final allowedWhiteboard = roomState.whiteboardAllowedUsers.contains(participant.identity);
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (allowedWhiteboard) Icon(Icons.gesture, color: AppColorManager.ampere, size: 14.r),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    chosen ? Icons.mic : Icons.mic_off,
                                    color: chosen ? AppColorManager.green : Colors.white54,
                                    size: 16.r,
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                // Control Buttons (Overlays)
                if (!widget.justShow && participant.isRemoteUser) ...[
                  // Top Left: Speak Permission Toggle
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: CircleAvatar(
                        radius: widget.small ? 14.r : 18.r,
                        backgroundColor: chosen ? AppColorManager.green.withOpacity(0.9) : Colors.black45,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            setState(() => loadingChoseUser = true);
                            await context.read<RoomCubit>().choseUser(participant.identity);
                            setState(() => loadingChoseUser = false);
                          },
                          icon: loadingChoseUser
                              ? SizedBox(
                                  width: 12.r,
                                  height: 12.r,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Icon(
                                  chosen ? Icons.mic : Icons.mic_off,
                                  color: Colors.white,
                                  size: widget.small ? 16.r : 20.r,
                                ),
                          tooltip: chosen ? S.of(context).revokeSpeak : S.of(context).grantSpeak,
                        ),
                      ),
                    ),
                  ),

                  // Bottom Left (Inside Stack but above bottom bar): Whiteboard Control
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30.h, left: 4.w),
                      child: BlocBuilder<RoomCubit, RoomInitial>(
                        builder: (context, roomState) {
                          final allowed = roomState.whiteboardAllowedUsers.contains(participant.identity);
                          return CircleAvatar(
                            radius: widget.small ? 14.r : 18.r,
                            backgroundColor: allowed ? AppColorManager.ampere.withOpacity(0.9) : Colors.black45,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.gesture,
                                color: Colors.white,
                                size: widget.small ? 16.r : 20.r,
                              ),
                              onPressed: () {
                                context.read<RoomCubit>().toggleWhiteboardPermission(
                                  participant.identity,
                                  !allowed,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Top Right: Achievement/Hand Wave
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: CircleAvatar(
                        radius: widget.small ? 14.r : 18.r,
                        backgroundColor: Colors.black45,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.waving_hand, color: Colors.white, size: widget.small ? 14.r : 18.r),
                          onPressed: () {
                            final m = LkMessage(
                              action: ManagerActions.achievement,
                              metadata: {
                                'name': participant.name,
                                if (participant.image.isNotEmpty) 'image': participant.image,
                                'id': participant.identity,
                              },
                            );

                            context.read<RoomCubit>().state.result.localParticipant?.publishData(
                              m.toBytes,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserWider extends StatelessWidget {
  const UserWider({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        decoration: BoxDecoration(
          color: AppColorManager.mainColorDark,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white10),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: RoundImageWidget(
                  url: (user?.studentImage).isBlank ? Icons.person : user?.studentImage.fixImageAvatar,
                  width: 0.6.sw,
                  height: 0.6.sw,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(color: Colors.black45),
                child: DrawableText(
                  text: user?.studentName ?? '-',
                  color: Colors.white70,
                  textAlign: .center,
                  size: 10.0.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
