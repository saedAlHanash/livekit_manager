part of 'room_cubit.dart';

class RoomInitial extends AbstractState<Room> {
  const RoomInitial({
    required super.result,
    super.error,
    required super.request,
    super.statuses,
    super.id,
  });

  factory RoomInitial.initial() {
    return RoomInitial(
      result: Room.fromJson({}),
      request: '',
      
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
      ];
      
  RoomInitial copyWith({
    CubitStatuses? statuses,
    Room? result,
    String? error,
    dynamic id,
    String? request,
  }) {
    return RoomInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
      request: request ?? this.request,
    );
  }
}

   