import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';

import '../../bloc/room_cubit/room_cubit.dart';
import '../widget/item_user.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: cubit.disconnect,
        backgroundColor: Colors.red,
        child: const Icon(Icons.call_end, color: Colors.white),
      ),
      body: BlocBuilder<RoomCubit, RoomInitial>(
        builder: (context, state) {
          // loggerObject.i(state.raiseHands);
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.participantTracks.length,
                    padding: EdgeInsets.all(15.0),
                    itemBuilder: (context, i) {
                      return ItemUserRemote(i: i);
                    },
                  ),
                ),
                if (state.selectedParticipantTrack != null)
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 1.0.sh,
                      decoration: BoxDecoration(
                        color: AppColorManager.appBarColor,
                        borderRadius: BorderRadius.circular(12.0).r,
                      ),
                      padding: const EdgeInsets.all(15.0),
                      child: DynamicUser(participantTrack: state.selectedParticipantTrack!),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
