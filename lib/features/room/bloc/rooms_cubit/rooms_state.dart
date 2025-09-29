part of 'rooms_cubit.dart';

class RoomsInitial extends AbstractState<List<Room>> {
  const RoomsInitial({
    required super.result,
    super.error,
    super.request,
    super.filterRequest,
    super.cubitCrud,
    super.createUpdateRequest,
    super.statuses,
    super.id,
  });

  factory RoomsInitial.initial() {
    return  RoomsInitial(
      result: [],
      createUpdateRequest: CreateRoomRequest.fromJson({}),
    );
  }

  CreateRoomRequest get cRequest => createUpdateRequest;

  String get mId => id;

  @override
  List<Object> get props => [
        statuses,
        result,
        error,
        cubitCrud,
        if (id != null) id,
        if (request != null) request,
        if (filterRequest != null) filterRequest!,
        if (createUpdateRequest != null) createUpdateRequest!,
      ];

  RoomsInitial copyWith({
    CubitStatuses? statuses,
    CubitCrud? cubitCrud,
    List<Room>? result,
    String? error,
    FilterRequest? filterRequest,
    dynamic request,
    dynamic cRequest,
    dynamic id,
  }) {
    return RoomsInitial(
      statuses: statuses ?? this.statuses,
      cubitCrud: cubitCrud ?? this.cubitCrud,
      result: result ?? this.result,
      error: error ?? this.error,
      filterRequest: filterRequest ?? this.filterRequest,
      request: request ?? this.request,
      createUpdateRequest: cRequest ?? this.cRequest,
      id: id ?? this.id,
    );
  }
}

