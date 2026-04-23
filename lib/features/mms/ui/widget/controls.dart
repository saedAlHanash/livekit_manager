import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/features/mms/bloc/user_control_cubit/user_control_cubit.dart';

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
    return BlocBuilder<MMSUserControlCubit, MMSUserControlInitial>(
      builder: (context, cState) {
        return BlocBuilder<MMSRoomCubit, MMSRoomInitial>(
          builder: (context, state) {
            return Row(
              spacing: 12.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                MyButton(
                  loading: cState.loading,
                  onTap: () {
                    context.read<MMSUserControlCubit>().suspendAll();
                  },
                  width: 150.0.w,
                  text: 'تعليق الكل',
                  color: AppColorManager.appBarColor,
                  icon: ImageMultiType(
                    height: 24.0.dg,
                    width: 24.0.dg,
                    url: Assets.imagesSilenceIcon,
                    color: AppColorManager.textColor,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    context.read<MMSRoomCubit>().disconnect();
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
