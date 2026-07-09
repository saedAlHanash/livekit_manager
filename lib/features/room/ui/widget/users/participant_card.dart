import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/util/my_style.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
import 'package:livekit_manager/features/user/data/response/user_response.dart';
import 'package:livekit_manager/generated/l10n.dart';
import 'package:livekit_manager/services/signal_r/bloc/signal_r_cubit/signal_r_cubit.dart';
import 'package:m_cubit/m_cubit.dart';
import 'package:m_cubit/util.dart';

import '../../../../../core/strings/enum_manager.dart';
import '../../../data/request/setting_message.dart';
import 'no_video.dart';

class ParticipantCard extends StatefulWidget {
  const ParticipantCard({
    super.key,
    required this.participant,
    this.user,
     this.fit = .contain,
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
          if (chosen && !widget.justShow)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final color = Color.lerp(AppColorManager.ampere, Colors.white, _animation.value);
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: color!.withValues(alpha:0.3 * (1 - _animation.value)),
                          spreadRadius: 25.r * _animation.value,
                          blurRadius: 30.r * _animation.value,
                        ),
                        BoxShadow(
                          color: color.withValues(alpha:0.5 * (1 - _animation.value)),
                          spreadRadius: 10.r * _animation.value,
                          blurRadius: 15.r * _animation.value,
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
              color: AppColorManager.appBarColor,
              borderRadius: BorderRadius.circular(12.r),
              border: widget.justShow
                  ? null
                  : Border.all(
                      color: chosen ? AppColorManager.ampere : Colors.transparent,
                      width: chosen ? 4.r : 0,
                    ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
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
                    ),
                  ),
                ),
                if (!widget.justShow) ...[
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

                  if (participant.isRemoteUser)
                    Align(
                      alignment: .topRight,
                      child: IconButton(
                        icon: ImageMultiType(url: Icons.waving_hand),
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

                  if (participant.isRemoteUser)
                    Align(
                      alignment: .bottomLeft,
                      child: BlocBuilder<RoomCubit, RoomInitial>(
                        builder: (context, roomState) {
                          final allowed = roomState.whiteboardAllowedUsers.contains(participant.identity);
                          return IconButton(
                            icon: Icon(
                              allowed ? Icons.gesture : Icons.gesture_outlined,
                              color: allowed ? AppColorManager.green : Colors.white60,
                              size: widget.small ? 16.r : 24.r,
                            ),
                            tooltip: allowed ? S.of(context).revokeWhiteboard : S.of(context).grantWhiteboard,
                            onPressed: () {
                              context.read<RoomCubit>().toggleWhiteboardPermission(
                                    participant.identity,
                                    !allowed,
                                    context.read<SignalRCubit>(),
                                  );
                            },
                          );
                        },
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
      opacity: 0.3,
      child: Container(
        decoration: BoxDecoration(
          color: AppColorManager.appBarColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: RoundImageWidget(
                  url: (user?.studentImage).isBlank ? Icons.person : user?.studentImage.fixImageAvatar,
                  width: 1.0.sw,
                  height: 1.0.sw,
                ),
              ),
            ),
            Align(
              alignment: .bottomRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: BoxDecoration(color: Colors.white),
                child: DrawableText(
                  text: user?.studentName ?? '-',
                  color: Colors.black,
                  matchParent: true,
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

//https://lk-m.codemagic.app/?token=&url=wss://coretik.coretech-mena.com&theme=dark&groupTermId=f6a8ac35-293f-4204-96b9-14bbe164bd4e
