import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
import 'package:livekit_manager/features/room/ui/widget/users/participant_card.dart';

class LocalMedia extends StatelessWidget {
  const LocalMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return ParticipantCard(
          participant: state.result.localParticipant,
        );
      },
    );
  }
}
