import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_manager/features/room/ui/widget/controls.dart';

import '../../../user/bloc/users_cubit/users_cubit.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import '../widget/group/group_students.dart';

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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(child: GroupStudents()),
              ControlsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

//audiences
