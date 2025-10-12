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
  });

  final String url;

  final String token;

  final EventsListener<RoomEvent> listener;

  factory RoomInitial.initial() {
    final room = Room();
    return RoomInitial(
      result: room,
      request: '',
      url: 'wss://coretik.coretech-mena.com',
      token: '',
      listener: room.createListener(),
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
      ];

  RoomInitial copyWith(
      {CubitStatuses? statuses,
      Room? result,
      String? error,
      dynamic id,
      String? request,
      String? url,
      String? token,
      EventsListener<RoomEvent>? listener}) {
    return RoomInitial(
        statuses: statuses ?? this.statuses,
        result: result ?? this.result,
        error: error ?? this.error,
        id: id ?? this.id,
        request: request ?? this.request,
        url: url ?? this.url,
        token: token ?? this.token,
        listener: listener ?? this.listener);
  }
}
