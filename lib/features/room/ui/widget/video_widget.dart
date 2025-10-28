import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lk_assistant/features/room/ui/widget/users/dynamic_user.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../room/bloc/room_cubit/room_cubit.dart';
import 'no_video.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({super.key});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return Stack(
          children: [
            state.selectedParticipant == null
                ? NoVideoWidget()
                : DynamicUser(
                    participant: state.selectedParticipant!,
                  ),
            if (state.participantTracksWithoutSelected.isNotEmpty)
              Align(
                alignment: AlignmentGeometry.topCenter,
                child: SizedBox(
                  height: 100.0.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.participantTracksWithoutSelected.length,
                    itemBuilder: (context, i) {
                      final participant = state.participantTracksWithoutSelected[i];
                      return InkWell(
                        onTap: () {
                          context.read<RoomCubit>().selectParticipant(participant.identity);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: AppColorManager.appBarColor,
                            border: Border.all(color: AppColorManager.mainColor),
                          ),
                          padding: EdgeInsets.all(3),
                          clipBehavior: Clip.hardEdge,
                          width: 180.0.dg,
                          height: 120.0.dg,
                          child: DynamicUser(participant: participant),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
