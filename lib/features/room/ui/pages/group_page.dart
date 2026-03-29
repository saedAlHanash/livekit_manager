import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/features/room/ui/widget/controls.dart';
import 'package:livekit_manager/features/room/ui/widget/local_media.dart';
import 'package:livekit_manager/features/room/ui/widget/notes_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/speakers_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/video_widget.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../user/bloc/users_cubit/users_cubit.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import '../widget/group/group_students.dart';
import '../widget/users/participants_layout.dart';
import '../widget/users/remote_user.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> {
  RoomCubit get cubit => context.read<RoomCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersCubit, UsersInitial>(
      listenWhen: (p, c) => c.done,
      listener: (context, state) {
        context.read<RoomCubit>().setExpectedUsers(state.result);
      },
      child: Scaffold(
        body: BlocBuilder<RoomCubit, RoomInitial>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(child: GroupStudents()),
                  ControlsWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

//audiences
