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
    required this.participants,
    required this.raiseHands,
    required this.selectedParticipantId,
    required this.haveNewNote,
    this.layoutMode = ParticipantsLayoutMode.grid,
    this.showChat = false,
    required this.expectedUsers,
  });

  final String url;

  final String token;

  final bool haveNewNote;

  int get notifyIndex => id ?? 0;

  final EventsListener<RoomEvent> listener;

  final List<LkMessage> raiseHands;
  final List<Participant> participants;
  final String selectedParticipantId;
  final ParticipantsLayoutMode layoutMode;
  final bool showChat;
  final List<User> expectedUsers;

  factory RoomInitial.initial() {
    final room = Room(roomOptions: RoomConfig.instance.roomOptions);
    return RoomInitial(
      id: 0,
      result: room,
      request: '',
      url: '',
      token: '',
      listener: room.createListener(),
      raiseHands: [],
      participants: const [],
      selectedParticipantId: '',
      haveNewNote: false,
      expectedUsers: const [],
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
    participants,
    raiseHands,
    selectedParticipantId,
    haveNewNote,
    layoutMode,
    showChat,
    expectedUsers,
  ];

  RoomInitial copyWith({
    CubitStatuses? statuses,
    Room? result,
    String? error,
    int? id,
    String? request,
    String? url,
    String? token,
    EventsListener<RoomEvent>? listener,
    List<Participant>? participants,
    List<LkMessage>? raiseHands,
    String? selectedParticipantId,
    bool? haveNewNote,
    ParticipantsLayoutMode? layoutMode,
    bool? showChat,
    List<User>? expectedUsers,
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
      participants: participants ?? this.participants,
      raiseHands: raiseHands ?? this.raiseHands,
      selectedParticipantId: selectedParticipantId ?? this.selectedParticipantId,
      haveNewNote: haveNewNote ?? this.haveNewNote,
      layoutMode: layoutMode ?? this.layoutMode,
      showChat: showChat ?? this.showChat,
      expectedUsers: expectedUsers ?? this.expectedUsers,
    );
  }
}
