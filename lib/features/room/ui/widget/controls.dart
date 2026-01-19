import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/util/snack_bar_message.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/features/room/ui/widget/send_message_dialog.dart';

import '../../../../core/widgets/my_button.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/room_cubit/room_cubit.dart';

class ControlsWidget extends StatelessWidget {
  const ControlsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserControlCubit, UserControlInitial>(
      builder: (context, cState) {
        return BlocBuilder<RoomCubit, RoomInitial>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12.0,
              children: [
                MyButton(
                  onTap: () {},
                  text: state.result.localParticipant?.isScreenShareEnabled() == true
                      ? 'إيقاف مشاركة الشاشة'
                      : 'مشاركة الشاشة',
                  color: AppColorManager.appBarColor,
                  icon: 24.0.dg.horizontalSpace,
                  iconStart: ImageMultiType(
                    height: 24.0.dg,
                    width: 24.0.dg,
                    url: Icons.screen_share_outlined,
                    color: AppColorManager.textColor,
                  ),
                ),
                MyButton(
                  loading: cState.loading,
                  onTap: () {
                    context.read<UserControlCubit>().suspendAll();
                  },
                  text: S.of(context).suspendAll,
                  color: AppColorManager.appBarColor,
                  icon: 24.0.dg.horizontalSpace,
                  iconStart: ImageMultiType(
                    height: 24.0.dg,
                    width: 24.0.dg,
                    url: Assets.imagesSilenceIcon,
                    color: AppColorManager.textColor,
                  ),
                ),
                MyButton(
                  onTap: () {
                    NoteMessage.showMyDialog(child: SendMessageDialog());
                  },
                  text: S.of(context).groupMessage,
                  color: AppColorManager.appBarColor,
                  icon: 24.0.dg.horizontalSpace,
                  iconStart: ImageMultiType(
                    url: Icons.message,
                    height: 24.0.dg,
                    width: 24.0.dg,
                    color: AppColorManager.textColor,
                  ),
                ),
                MyButton(
                  text: 'إنهاء الجلسة',
                  textColor: Colors.white,
                  color: AppColorManager.red,
                  onTap: () {
                    context.read<RoomCubit>().disconnect();
                  },
                  icon: 24.0.dg.horizontalSpace,
                  iconStart: ImageMultiType(
                    url: Icons.call_end,
                    color: Colors.white,
                    height: 24.0.dg,
                    width: 24.0.dg,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
