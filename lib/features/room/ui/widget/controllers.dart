import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final Participant? participant;

  @override
  State<ControllersDynamic> createState() => _ControllersDynamicState();
}

class _ControllersDynamicState extends State<ControllersDynamic> {
  Participant get participant => widget.participant!;

  @override
  Widget build(BuildContext context) {
    if (widget.participant == null) return 0.0.verticalSpace;
    return BlocBuilder<UserControlCubit, UserControlInitial>(
      buildWhen: (p, c) => c.id == participant.identity,
      builder: (context, state) {
        return DynamicPopupMenu(
          icon: widget.speaker ? Icons.more_vert_rounded : Icons.more_vert_rounded,
          items: [
            PopupMenuItemModel(
              label: participant.isAudioEnabled ? 'إيقاف الاستماع' : 'تشغيل الاستماع',
              icon: ImageMultiType(url: participant.isAudioEnabled ? Icons.volume_off : Icons.volume_up),
              onTap: () {
                context.read<UserControlCubit>().toggleRemoteUserAudio([participant]);
              },
            ),
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
      label: participant.permissions.isSilence ? 'إعطاء صلاحيات' : 'سحب صلاحيات',
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
