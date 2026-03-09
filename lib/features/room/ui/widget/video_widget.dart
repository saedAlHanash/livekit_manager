import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/features/room/ui/widget/users/participants_layout.dart';

import '../../../room/bloc/room_cubit/room_cubit.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({super.key});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RoomCubit>();
    return ParticipantsLayout(
      onTap: (participant) {
        cubit.selectParticipant(participant.identity);
      },
    );
  }
}
