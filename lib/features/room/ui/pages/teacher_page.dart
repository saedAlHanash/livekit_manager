import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/features/room/ui/widget/audiences_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/controls.dart';
import 'package:livekit_manager/features/room/ui/widget/local_media.dart';
import 'package:livekit_manager/features/room/ui/widget/notes_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/speakers_widget.dart';

import '../../../../core/widgets/my_card_widget.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import '../widget/managers_widget.dart';
import '../widget/users/dynamic_user.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
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
                          Expanded(child: SpeakersWidget()),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                if (state.selectedParticipant != null)
                                  Expanded(
                                    flex: 2,
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
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 10,
                                        child: NotesWidget(),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: LocalMedia(),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: ControlsWidget(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
