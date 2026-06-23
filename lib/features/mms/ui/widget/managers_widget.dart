import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';import 'package:m_cubit/util.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';

import '../../bloc/room_cubit/room_cubit.dart';
import 'item_user_lt.dart';

class ManagersWidget extends StatelessWidget {
  const ManagersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MMSRoomCubit, MMSRoomInitial>(
      builder: (context, state) {
        final l = state.participant.where((e) => !e.userType.isUser).toList();
        return Container(
          decoration: BoxDecoration(
            color: AppColorManager.appBarColor,
            borderRadius: BorderRadius.circular(12.0).r,
          ),
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0).r,
          child: ListView.separated(
            separatorBuilder: (context, index) => 10.0.verticalSpace,
            itemCount: l.length,
            padding: EdgeInsets.all(15.0),
            itemBuilder: (context, i) {
              return ItemUserRemoteLT(
                participant: l[i],
                isSelected: l[i].identity == state.selectedParticipant?.identity,
              );
            },
          ),
        );
      },
    );
  }
}
