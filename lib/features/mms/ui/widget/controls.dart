import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/util/snack_bar_message.dart';
import 'package:livekit_manager/core/widgets/my_text_form_widget.dart';
import 'package:livekit_manager/features/mms/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/features/mms/ui/widget/send_message_dialog.dart';

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
            return Row(
              spacing: 12.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                MyButton(
                  loading: cState.loading,
                  onTap: () {
                    context.read<UserControlCubit>().suspendAll();
                  },
                  text: 'تعليق الكل',
                  color: AppColorManager.appBarColor,
                  icon: ImageMultiType(
                    height: 24.0.dg,
                    width: 24.0.dg,
                    url: Assets.imagesSilenceIcon,
                    color: AppColorManager.textColor,
                  ),
                ),
                // MyButton(
                //   onTap: () {
                //     NoteMessage.showMyDialog(child: SendMessageDialog());
                //   },
                //   text: S.of(context).groupMessage,
                //   color: AppColorManager.appBarColor,
                //   icon: ImageMultiType(
                //     height: 24.0.dg,
                //     width: 24.0.dg,
                //     url: Icons.message,
                //     color: AppColorManager.textColor,
                //   ),
                // ),
                IconButton(
                  onPressed: () {
                    context.read<RoomCubit>().disconnect();
                  },
                  icon: const Icon(
                    Icons.call_end,
                    color: Colors.red,
                  ),
                  tooltip: S.of(context).disconnect,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
