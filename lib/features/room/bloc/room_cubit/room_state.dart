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
    required this.participant,
    required this.raiseHands,
    required this.selectedParticipantId,
  });

  final String url;

  final String token;

  int get notifyIndex => id ?? 0;

  final EventsListener<RoomEvent> listener;

  final Set<String> raiseHands;
  final List<Participant> participant;

  final String selectedParticipantId;

  List<Participant> get participantTracksWithoutSelected =>
      participant.where((e) => e.identity != selectedParticipant?.identity).toList();

  Participant? get selectedParticipant =>
      participant.firstWhereOrNull((e) => e.identity == selectedParticipantId) ?? participant.firstOrNull;

  ConnectionState get connectionState => result.connectionState;

  bool get isConnect => result.connectionState == ConnectionState.connected;

  factory RoomInitial.initial() {
    final room = Room();
    return RoomInitial(
      id: 0,
      result: room,
      request: '',
      url: '',
      // url: 'wss://coretik.coretech-mena.com',
      token: '',
      listener: room.createListener(),
      raiseHands: {},
      participant: const [],
      selectedParticipantId: '',
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
        participant,
        raiseHands,
        selectedParticipantId,
      ];

  List<Participant> get speakers => participant.where((e) => !e.permissions.isSilence).toList();

  String get sharerId => participant.firstWhereOrNull((e) => e.userType.isSharer)?.identity ?? '';

  RoomInitial copyWith(
      {CubitStatuses? statuses,
      Room? result,
      String? error,
      int? id,
      String? request,
      String? url,
      String? token,
      EventsListener<RoomEvent>? listener,
      List<Participant>? participant,
      Set<String>? raiseHands,
      String? selectedParticipantId}) {
    return RoomInitial(
        statuses: statuses ?? this.statuses,
        result: result ?? this.result,
        error: error ?? this.error,
        id: id ?? this.id,
        request: request ?? this.request,
        url: url ?? this.url,
        token: token ?? this.token,
        listener: listener ?? this.listener,
        participant: participant ?? this.participant,
        raiseHands: raiseHands ?? this.raiseHands,
        selectedParticipantId: selectedParticipantId ?? this.selectedParticipantId);
  }
}
