part of 'room_cubit.dart';

class MMSRoomInitial extends AbstractState<Room> {
  const MMSRoomInitial({
    required super.result,
    super.error,
    required super.request,
    super.statuses,
    super.id,
    required this.url,
    required this.token,
    required this.listener,
    required this.participant,
    required this.requestPermissions,
    required this.selectedUserId,
  });

  final String url;

  final String token;

  int get notifyIndex => id ?? 0;

  final EventsListener<RoomEvent> listener;

  final List<SettingMessage> requestPermissions;
  final List<Participant> participant;

  final String selectedUserId;

  List<Participant> get participantTracksWithoutSelected =>
      participant.where((e) => e.identity != selectedParticipant?.identity).toList(growable: false);

  Participant? getParticipantById(String id) => participant.firstWhereOrNull((e) => e.identity == id);

  Participant? get selectedParticipant =>
      participant.firstWhereOrNull((e) => e.identity == selectedUserId) ?? participant.firstOrNull;

  ConnectionState get connectionState => result.connectionState;

  bool get isConnect => result.connectionState == ConnectionState.connected;

  factory MMSRoomInitial.initial() {
    final room = Room(roomOptions: RoomConfig.instance.roomOptions);
    return MMSRoomInitial(
      id: 0,
      result: room,
      request: '',
      url: '',
      // url: 'wss://coretik.coretech-mena.com',
      token: '',
      listener: room.createListener(),
      requestPermissions: [],
      participant: const [],

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
    participant,
    requestPermissions,
    selectedUserId,
  ];

  List<Participant> get speakers => participant.where((e) => e.permissions.canPublish).toList();

  String get sharerId => participant.firstWhereOrNull((e) => e.userType.isSharer)?.identity ?? '';

  MMSRoomInitial copyWith({
    CubitStatuses? statuses,
    Room? result,
    String? error,
    int? id,
    String? request,
    String? url,
    String? token,
    EventsListener<RoomEvent>? listener,
    List<Participant>? participant,
    List<SettingMessage>? requestPermissions,
    String? selectedUserId,
  }) {
    return MMSRoomInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
      request: request ?? this.request,
      url: url ?? this.url,
      token: token ?? this.token,
      listener: listener ?? this.listener,
      participant: participant ?? this.participant,
      requestPermissions: requestPermissions ?? this.requestPermissions,
      selectedUserId: selectedUserId ?? this.selectedUserId,
    );
  }
}
