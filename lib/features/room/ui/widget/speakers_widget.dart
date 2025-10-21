import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';

import '../../../../generated/l10n.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import 'item_user.dart';

class SpeakersWidget extends StatelessWidget {
  const SpeakersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final list = state.participantTracks.where((e) => e.permissions.canPublish);
        loggerObject.w(list.map((e) => e.permissions.printFun));
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
              Divider(),
              Expanded(
                child: ListView.builder(
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
