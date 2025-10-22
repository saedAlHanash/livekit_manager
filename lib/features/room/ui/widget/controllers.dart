import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';

import '../../../../core/util/my_style.dart';
import '../../../../core/widgets/menu_widget.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/user_control_cubit/user_control_cubit.dart';

class Controllers extends StatelessWidget {
  const Controllers({super.key, required this.participant});

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserControlCubit, UserControlInitial>(
      builder: (context, state) {
        if (state.loading) {
          return SizedBox(
            height: 24.0.dg,
            width: 24.0.dg,
            child: MyStyle.loadingWidget(),
          );
        }
        return DynamicPopupMenu(
          icon: Icons.menu,
          items: [
            PopupMenuItemModel(
              label: (participant.isSuspend) ? S.of(context).resumeUser : S.of(context).suspendUser,
              icon: participant.isSuspend ? Icons.play_arrow : Icons.pause,
              onTap: () {
                if (participant.isSuspend) {
                  context.read<UserControlCubit>().resume(participant.identity);
                } else {
                  context.read<UserControlCubit>().suspend(participant.identity);
                }
              },
            ),
            if (!participant.isMuted)
              PopupMenuItemModel(
                label: S.of(context).mute,
                icon: Icons.mic_off,
                onTap: () {
                  context.read<UserControlCubit>().stopAudio(participant.identity);
                },
              ),
            if (participant.isCameraEnabled())
              PopupMenuItemModel(
                label: S.of(context).stopCamera,
                icon: Icons.videocam_off_outlined,
                onTap: () {
                  context.read<UserControlCubit>().stopCamera(participant.identity);
                },
              ),
            if (participant.isScreenShareEnabled())
              PopupMenuItemModel(
                label: S.of(context).stopShareScreen,
                icon: Icons.stop_screen_share_outlined,
                onTap: () {
                  context.read<UserControlCubit>().stopScreenShare(participant.identity);
                },
              ),
            PopupMenuItemModel(
              label: S.of(context).disconnect,
              icon: ImageMultiType(url: Icons.call_end, color: Colors.red),
              onTap: () {
                context.read<UserControlCubit>().kick(participant.identity);
              },
            ),
            PopupMenuItemModel(
              label: S.of(context).disconnectAndBan,
              icon: ImageMultiType(url: Icons.block, color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
