import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/features/room/ui/widget/users/dynamic_user.dart';

import '../../bloc/room_cubit/room_cubit.dart';

class ItemUserSpeaker extends StatelessWidget {
  const ItemUserSpeaker({super.key, required this.participant});

  final Participant<TrackPublication<Track>> participant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {

        return InkWell(
          onTap: () {
            context.read<RoomCubit>().selectParticipant(participant.identity);
          },
          child: UserImageOrName(participant: participant),
        );
      },
    );
  }
}
