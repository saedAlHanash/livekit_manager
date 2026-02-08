import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/widgets/my_button.dart';
import 'package:livekit_manager/features/room/ui/widget/users/dynamic_user.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/sounds_service.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import '../../bloc/user_control_cubit/user_control_cubit.dart';
import 'item_user.dart';

class SpeakersWidget extends StatefulWidget {
  const SpeakersWidget({super.key});

  @override
  State<SpeakersWidget> createState() => _SpeakersWidgetState();
}

class _SpeakersWidgetState extends State<SpeakersWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserControlCubit, UserControlInitial>(
      listener: (context, state) {
        setState(() {});
      },
      child: BlocBuilder<RoomCubit, RoomInitial>(
        builder: (context, state) {
          final list = state.participantTracksWithoutMe;
          final isAudioEnabled = list.any((e) => e.isAudioEnabled);
          return Container(
            decoration: BoxDecoration(
              color: AppColorManager.appBarColor,
              borderRadius: BorderRadius.circular(12.0).r,
            ),
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0).r,
            child: Column(
              children: [
                10.0.verticalSpace,
                DrawableText(
                  text: 'أعضاء الصف',
                  padding: EdgeInsets.symmetric(horizontal: 20.0).r,
                  matchParent: true,
                  drawableEnd: TextButton(
                    onPressed: () {
                      context.read<UserControlCubit>().toggleRemoteUserAudio(list);
                    },
                    child: DrawableText(
                      text: isAudioEnabled ? 'كتم الكل' : 'تشغيل الكل',
                      drawablePadding: 5.0,
                      drawableStart: ImageMultiType(url: isAudioEnabled ? Icons.volume_up : Icons.volume_off),
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => 10.0.verticalSpace,
                    itemCount: list.length,
                    padding: EdgeInsets.all(15.0),
                    itemBuilder: (context, i) {
                      return UserImageOrName(
                        participant: list[i],
                        isSelected: list[i].identity == state.selectedUserId,
                        onTap: () {
                          context.read<RoomCubit>().selectParticipant(list[i].identity);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
