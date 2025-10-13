part of 'room_cubit.dart';

class RoomInitial extends AbstractState<Room> {
  const RoomInitial({
    required super.result,
    super.error,
    required super.request,
    super.statuses,
    super.id,
    required this.url,
    required this.token,
    required this.listener,
    required this.participantTracks,
    required this.selectedUserId,
  });

  final String url;

  final String token;

  final EventsListener<RoomEvent> listener;

  final List<ParticipantTrack> participantTracks;

  final String selectedUserId;

  List<ParticipantTrack> get participantTracksWithoutSelected => participantTracks
      .where((e) => e.participant.sid != selectedParticipantTrack?.participant.sid)
      .toList(growable: false);

  ParticipantTrack? get selectedParticipantTrack =>
      participantTracks.firstWhereOrNull((e) => e.participant.sid == selectedUserId) ?? participantTracks.firstOrNull;

  ConnectionState get connectionState => result.connectionState;
  bool get isConnect => result.connectionState == ConnectionState.connected;

  factory RoomInitial.initial() {
    final room = Room();
    return RoomInitial(
      result: room,
      request: '',
      url: 'ws://192.168.1.69:7880',
      // url: 'wss://coretik.coretech-mena.com',
      token:
          'eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiQWRtaW4gdXNlciIsImF0dHJpYnV0ZXMiOnsibGtVc2VyVHlwZSI6IjAifSwidmlkZW8iOnsicm9vbUpvaW4iOnRydWUsImNhblB1Ymxpc2giOnRydWUsImNhblN1YnNjcmliZSI6dHJ1ZSwiY2FuUHVibGlzaERhdGEiOnRydWUsInJvb20iOiJtMyJ9LCJpc3MiOiJBUElReFpQandwR29jY3IiLCJleHAiOjE3NjAzODMwMjQsIm5iZiI6MCwic3ViIjoibWFuYWdlcjEifQ.TaW9EC2MyHku7ZiZp1_E08HHluuagLtwzzrGEWlVtC8',
      listener: room.createListener(),
      participantTracks: const [],
      selectedUserId: '',
    );
  }

  @override
  List<Object> get props => [
        statuses,
        result,
        error,
        if (request != null) request,
        if (id != null) id,
        if (filterRequest != null) filterRequest!,
        listener,
        url,
        token,
        participantTracks,
        selectedUserId,
      ];

  RoomInitial copyWith(
      {CubitStatuses? statuses,
      Room? result,
      String? error,
      dynamic id,
      String? request,
      String? url,
      String? token,
      EventsListener<RoomEvent>? listener,
      List<ParticipantTrack>? participantTracks,
      String? selectedUserId}) {
    return RoomInitial(
        statuses: statuses ?? this.statuses,
        result: result ?? this.result,
        error: error ?? this.error,
        id: id ?? this.id,
        request: request ?? this.request,
        url: url ?? this.url,
        token: token ?? this.token,
        listener: listener ?? this.listener,
        participantTracks: participantTracks ?? this.participantTracks,
        selectedUserId: selectedUserId ?? this.selectedUserId);
  }
}
