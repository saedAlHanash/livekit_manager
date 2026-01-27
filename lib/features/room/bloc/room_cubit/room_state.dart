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
    required this.selectedUserId,
    required this.haveNewNote,
  });

  final String url;

  final String token;

  final bool haveNewNote;

  int get notifyIndex => id ?? 0;

  final EventsListener<RoomEvent> listener;

  final List<SettingMessage> raiseHands;
  final List<Participant> participant;

  final String selectedUserId;

  List<Participant> get participantTracksWithoutSelected =>
      participant.where((e) => e.identity != selectedParticipant?.identity).toList(growable: false);

  List<Participant> get participantTracksWithoutManager => participant
      .where((e) => e.userType.isUser || e.userType.isSharer)
      .sorted(
        (a, b) => (b.permissions.canPublish ? 1 : 0) - (a.permissions.canPublish ? 1 : 0),
      )
      .toList(growable: false);

  List<Participant> get students =>
      participant.where((e) => e.userType.isUser && e is! LocalParticipant).toList(growable: false);

  Participant? getParticipantById(String id) => participant.firstWhereOrNull((e) => e.identity == id);

  Participant? get selectedParticipant =>
      participant.firstWhereOrNull((e) => e.identity == selectedUserId) ?? participant.firstOrNull;

  ConnectionState get connectionState => result.connectionState;

  bool get isConnect => result.connectionState == ConnectionState.connected;

  factory RoomInitial.initial() {
    final room = Room();
    return RoomInitial(
      id: 0,
      result: room,
      request: '',
      url: '',
      token: '',
      listener: room.createListener(),
      raiseHands: [],
      participant: const [],
      selectedUserId: '',
      haveNewNote: false,
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
    selectedUserId,
    haveNewNote,
  ];

  List<Participant> get speakers => participant.where((e) => e.permissions.canPublish).toList();

  String get sharerId => participant.firstWhereOrNull((e) => e.userType.isSharer)?.identity ?? '';

  RoomInitial copyWith({
    CubitStatuses? statuses,
    Room? result,
    String? error,
    int? id,
    String? request,
    String? url,
    String? token,
    EventsListener<RoomEvent>? listener,
    List<Participant>? participant,
    List<SettingMessage>? raiseHands,
    String? selectedUserId,
    bool? haveNewNote,
  }) {
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
      selectedUserId: selectedUserId ?? this.selectedUserId,
      haveNewNote: haveNewNote ?? this.haveNewNote,
    );
  }
}
