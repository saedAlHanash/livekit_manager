import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:lk_assistant/features/room/ui/widget/users/remote_user.dart';

import '../participant_info.dart';
import 'local_user.dart';

class DynamicUser extends StatelessWidget {
  const DynamicUser({super.key, required this.participant});

  final Participant participant;
  @override
  Widget build(BuildContext context) {
    if (participant is LocalParticipant) {
      return LocalUser(participant: participant);
    } else if (participant is RemoteParticipant) {
      return RemoteUser(participant: participant);
    }
    throw UnimplementedError('Unknown participant type');
  }
}
