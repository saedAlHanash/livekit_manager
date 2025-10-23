import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/widgets/my_button.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/sounds_service.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import 'item_user.dart';

class SpeakersWidget extends StatelessWidget {
  const SpeakersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final list = state.participantTracks.where((e) => e.permissions.canPublish);
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
                text: S.of(context).speakers,
                padding: EdgeInsets.symmetric(horizontal: 20.0).r,
                matchParent: true,
              ),
              10.0.verticalSpace,
              MyButton(
                color: Colors.green,
                text: 'soundsAcceptRequest',
                // textColor: Colors.black,
                onTap: () => SoundService.play(Assets.soundsAcceptRequest),
              ),
              10.0.verticalSpace,
              MyButton(
                color: Colors.red,
                text: 'soundsDisconnectUser',
                // textColor: Colors.black,
                onTap: () => SoundService.play(Assets.soundsDisconnectUser),
              ),
              10.0.verticalSpace,
              MyButton(
                color: Colors.blue,
                text: 'soundsNewJoin',
                // textColor: Colors.black,
                onTap: () => SoundService.play(Assets.soundsNewJoin),
              ),
              10.0.verticalSpace,
              MyButton(
                color: Colors.orange,
                text: 'soundsNote',
                // textColor: Colors.black,
                onTap: () => SoundService.play(Assets.soundsNote),
              ),
              10.0.verticalSpace,
              MyButton(
                color: Colors.purple,
                text: 'soundsShareScreen',
                // textColor: Colors.black,
                onTap: () => SoundService.play(Assets.soundsShareScreen),
              ),
              Divider(),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => 10.0.verticalSpace,
                  itemCount: list.length,
                  padding: EdgeInsets.all(15.0),
                  itemBuilder: (context, i) {
                    return ItemUserSpeaker(i: i);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
