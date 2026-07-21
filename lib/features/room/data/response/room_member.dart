import 'package:livekit_client/livekit_client.dart';

import '../../../user/data/response/user_response.dart';

class RoomMember {
  const RoomMember({
    this.participant,
    this.user,
  });

  final Participant? participant;
  final User? user;

  String get identity => participant?.identity ?? user?.id ?? '';
}
