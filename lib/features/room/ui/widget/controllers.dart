import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/widgets/menu_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/user_control_cubit/user_control_cubit.dart';
import '../../data/request/setting_message.dart';

class ControllersDynamic extends StatefulWidget {
  const ControllersDynamic({super.key, this.speaker = false, required this.participant});

  final bool speaker;
  final Participant participant;

  @override
  State<ControllersDynamic> createState() => _ControllersDynamicState();
}

class _ControllersDynamicState extends State<ControllersDynamic> {
  Participant get participant => widget.participant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserControlCubit, UserControlInitial>(
      buildWhen: (p, c) => c.id == participant.identity,
      builder: (context, state) {
        return DynamicPopupMenu(
          icon: widget.speaker ? Icons.more_vert_rounded : Icons.menu,
          items: [
            if (widget.speaker) ...[
              if (!participant.isMuted)
                PopupMenuItemModel(
                  label: S.of(context).mute,
                  icon: Icons.mic_off,
                  onTap: () {
                    context.read<UserControlCubit>().mute(participant.identity);
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
                label: S.of(context).makeMainView,
                icon: ImageMultiType(url: Icons.screenshot_monitor),
                onTap: () {
                  final m = SettingMessage(
                    toIdentity: context.read<RoomCubit>().state.sharerId,
                    action: ManagerActions.changeScreen,
                    toUserType: LkUserType.sharer,
                    metadata: {
                      'name': participant.name,
                      if (participant.image.isNotEmpty) 'image': participant.image,
                      'id': participant.identity,
                    },
                  );

                  context.read<RoomCubit>().state.result.localParticipant?.publishData(m.toBytes);
                },
              ),
              silence(),
            ] else ...[
              suspend(),
              if (!participant.permissions.isSuspend) silence(),
              PopupMenuItemModel(
                label: S.of(context).disconnect,
                icon: ImageMultiType(url: Icons.call_end, color: Colors.red),
                onTap: () {
                  context.read<UserControlCubit>().kick(participant.identity);
                },
              ),
              PopupMenuItemModel(
                onTap: () {
                  context.read<UserControlCubit>().kick(participant.identity, block: true);
                },
                label: S.of(context).disconnectAndBan,
                icon: ImageMultiType(url: Icons.block, color: Colors.red),
              ),
            ],
          ],
        );
      },
    );
  }

  PopupMenuItemModel suspend() {
    return PopupMenuItemModel(
      label: (participant.isSuspend) ? S.of(context).resumeUser : S.of(context).suspendUser,
      icon: participant.isSuspend ? Icons.play_arrow : Icons.pause,
      onTap: () {
        if (participant.isSuspend) {
          context.read<UserControlCubit>().resume(participant.identity);
        } else {
          context.read<UserControlCubit>().suspend(participant.identity);
        }
      },
    );
  }

  PopupMenuItemModel silence() {
    return PopupMenuItemModel(
      label: participant.permissions.isSilence ? S.of(context).speech : S.of(context).silence,
      icon: ImageMultiType(
        url: participant.permissions.isSilence ? Assets.imagesSpeak : Assets.imagesSilenceIcon,
        color: Colors.white,
        width: 30.0,
        height: 30.0,
      ),
      onTap: () {
        if (participant.permissions.isSilence) {
          context.read<UserControlCubit>().grant(participant, PermissionType.speak);
        } else {
          context.read<UserControlCubit>().revoke(participant, PermissionType.speak);
        }
      },
    );
  }

  PopupMenuItemModel deafblind() {
    return PopupMenuItemModel(
      label: participant.permissions.isDeafblind ? S.of(context).seeAndHear : S.of(context).deafblinding,
      icon: ImageMultiType(
        url: participant.permissions.isDeafblind ? Assets.imagesLookIcon : Assets.imagesDeafblind,
        color: Colors.white,
        width: 30.0,
        height: 30.0,
      ),
      onTap: () {
        if (participant.permissions.isDeafblind) {
          context.read<UserControlCubit>().grant(participant, PermissionType.listen);
        } else {
          context.read<UserControlCubit>().revoke(participant, PermissionType.listen);
        }
      },
    );
  }
}
