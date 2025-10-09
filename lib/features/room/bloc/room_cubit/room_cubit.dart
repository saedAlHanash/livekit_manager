import 'package:livekit_client/livekit_client.dart';
import 'package:m_cubit/abstraction.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../ui/widget/participant_info.dart';

part 'room_state.dart';

class RoomCubit extends MCubit<RoomInitial> {
  RoomCubit() : super(RoomInitial.initial());

  Future<void> initial() async {
    await Permission.microphone.request();
    await state.result.prepareConnection(state.url, state.token);
  }

  void setListeners() {
    state.listener
      //end call
      ..on<RoomDisconnectedEvent>((e) {
        // end call and dispose all
      })
      //re sort list users
      ..on<ParticipantEvent>((e) => _sortParticipants())
      ..on<LocalTrackPublishedEvent>((e) => _sortParticipants())
      ..on<LocalTrackUnpublishedEvent>((e) => _sortParticipants())
      ..on<TrackSubscribedEvent>((e) => _sortParticipants())
      ..on<TrackUnsubscribedEvent>((e) => _sortParticipants())
      ..on<ParticipantNameUpdatedEvent>((e) => _sortParticipants())
      ..on<AudioPlaybackStatusChanged>((e) => _sortParticipants())
      ..on<DataReceivedEvent>((e) {
        // Events handler most be hear, not another place.
        // Cuse this is the listener for data event.
        // Data will be as JSON type with modl with MessageAction enum.
      });
  }

  void _sortParticipants() {
    List<ParticipantTrack> userMediaTracks = [];
    List<ParticipantTrack> screenTracks = [];

    for (var participant in state.result.remoteParticipants.values) {
      screenTracks.add(
        ParticipantTrack(
          participant: participant,
          type: participant.videoTrackPublications.any((e) => e.isScreenShare) ? MediaType.screen : MediaType.media,
        ),
      );
    }

    userMediaTracks.sort((a, b) {
      if (a.participant.isSpeaking && b.participant.isSpeaking) {
        if (a.participant.audioLevel > b.participant.audioLevel) {
          return -1;
        } else {
          return 1;
        }
      }

      // last spoken at
      final aSpokeAt = a.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      final bSpokeAt = b.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

      if (aSpokeAt != bSpokeAt) {
        return aSpokeAt > bSpokeAt ? -1 : 1;
      }

      // video on
      if (a.participant.hasVideo != b.participant.hasVideo) {
        return a.participant.hasVideo ? -1 : 1;
      }

      // joinedAt
      return a.participant.joinedAt.millisecondsSinceEpoch - b.participant.joinedAt.millisecondsSinceEpoch;
    });
  }

  Future<void> connect() async {
    await state.result.connect(
      state.url,
      state.token,
      fastConnectOptions: FastConnectOptions(
        camera: TrackOption(
          enabled: true,
        ),
      ),
    );
  }

  void setUrl(String url) => emit(state.copyWith(url: url));

  void setToken(String token) => emit(state.copyWith(token: token));
}
