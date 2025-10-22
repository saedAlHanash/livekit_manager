import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/util/snack_bar_message.dart';

import '../../../../generated/l10n.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import 'item_user.dart';
import 'item_user_lt.dart';

class AudiencesWidget extends StatelessWidget {
  const AudiencesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
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
                text: S.of(context).audiences,
                padding: EdgeInsets.symmetric(horizontal: 20.0).r,
                matchParent: true,
              ),
              Divider(),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => 10.0.verticalSpace,
                  itemCount: state.participantTracks.length,
                  padding: EdgeInsets.all(15.0),
                  itemBuilder: (context, i) {
                    return ItemUserRemoteLT(i: i);
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
