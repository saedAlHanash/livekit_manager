import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/features/room/ui/widget/audiences_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/controls.dart';
import 'package:livekit_manager/features/room/ui/widget/notes_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/speakers_widget.dart';

import '../../bloc/room_cubit/room_cubit.dart';
import '../widget/managers_widget.dart';
import '../widget/users/dynamic_user.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  RoomCubit get cubit => context.read<RoomCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserControlCubit, UserControlInitial>(
        builder: (context, state) {
          return BlocBuilder<RoomCubit, RoomInitial>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: AudiencesWidget()),
                          Expanded(
                              child: Column(
                            children: [
                              Expanded(flex: 3, child: SpeakersWidget()),
                              10.0.verticalSpace,
                              Expanded(child: ManagersWidget()),
                            ],
                          )),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                if (state.selectedParticipant != null)
                                  Expanded(
                                    child: Container(
                                      width: 1.0.sw,
                                      decoration: BoxDecoration(
                                        color: AppColorManager.appBarColor,
                                        borderRadius: BorderRadius.circular(12.0).r,
                                      ),
                                      padding: const EdgeInsets.all(15.0),
                                      child: DynamicUser(participant: state.selectedParticipant!),
                                    ),
                                  ),
                                Expanded(
                                  child: NotesWidget(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    ControlsWidget(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
//audiences
