import 'package:livekit_client/livekit_client.dart';

class ParticipantTrackSource {
  final Participant participant;
  final TrackPublication? videoPublication;

  ParticipantTrackSource({
    required this.participant,
    this.videoPublication,
  });

  /// Unique ID for this track source.
  /// If it's a specific track, use track SID. Otherwise, use participant SID.
  String get id => videoPublication?.sid ?? participant.sid;

  String get displayName {
    if (videoPublication?.source == TrackSource.screenShareVideo) {
      return (participant.name.isNotEmpty ? participant.name : participant.identity) + '\'s screen';
    }
    return participant.name.isNotEmpty ? participant.name : participant.identity;
  }

  bool get isScreenShare => videoPublication?.source == TrackSource.screenShareVideo;

  bool get isVideoActive =>
      videoPublication != null &&
      !videoPublication!.muted &&
      (videoPublication is RemoteTrackPublication ? (videoPublication as RemoteTrackPublication).subscribed : true);

  VideoTrack? get videoTrack => videoPublication?.track as VideoTrack?;
}
