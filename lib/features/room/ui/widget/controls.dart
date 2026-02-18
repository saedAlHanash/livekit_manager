import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/generated/l10n.dart';

import '../../bloc/room_cubit/room_cubit.dart';

class ControlsWidget extends StatelessWidget {
  const ControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserControlCubit, UserControlInitial>(
      builder: (context, cState) {
        return BlocBuilder<RoomCubit, RoomInitial>(
          builder: (context, state) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Item(
                  onTap: context.read<UserControlCubit>().toggleLocalCamera,
                  title: cState.cameraEnabled ? S.of(context).stop : S.of(context).camera,
                  color: cState.cameraEnabled ? AppColorManager.secondColor : AppColorManager.appBarColor,
                  icon: cState.cameraEnabled ? Icons.videocam_off_outlined : Icons.videocam_outlined,
                ),
                12.w.horizontalSpace,
                _Item(
                  onTap: context.read<UserControlCubit>().toggleLocalMic,
                  title: cState.micEnabled ? S.of(context).stop : S.of(context).mic,
                  color: cState.micEnabled ? AppColorManager.secondColor : AppColorManager.appBarColor,
                  icon: cState.micEnabled ? Icons.mic_off : Icons.mic,
                ),
                12.w.horizontalSpace,
                _Item(
                  onTap: context.read<UserControlCubit>().toggleLocalScreenShare,
                  title: cState.screenShareEnabled ? S.of(context).stop : S.of(context).screen,
                  color: cState.screenShareEnabled ? AppColorManager.secondColor : AppColorManager.appBarColor,
                  icon: cState.screenShareEnabled ? Icons.stop_screen_share_outlined : Icons.screen_share_outlined,
                ),
                12.w.horizontalSpace,
                _Item(
                  onTap: () {
                    context.read<RoomCubit>().disconnect();
                  },
                  title: S.of(context).end,
                  color: AppColorManager.red,
                  icon: Icons.call_end,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    super.key,
    required this.icon,
    this.title,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final String? title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Tooltip(
        message: title,
        child: Container(
          width: 45.dg,
          height: 45.dg,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 26.dg,
          ),
        ),
      ),
    );
  }
}
