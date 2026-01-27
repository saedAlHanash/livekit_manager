part of 'active_session_cubit.dart';

class ActiveSessionInitial extends AbstractState<ActiveSessionResponse> {
  const ActiveSessionInitial({
    required super.result,
    super.error,
    super.request,
    super.filterRequest,
    super.cubitCrud,
    super.createUpdateRequest,
    super.statuses,
    super.id,
  });

  factory ActiveSessionInitial.initial() {
    return ActiveSessionInitial(
      result: ActiveSessionResponse.fromJson({}),
    );
  }

  @override
  List<Object?> get props => [
    statuses,
    result,
    error,
    cubitCrud,
    id,
    request,
    filterRequest,
    createUpdateRequest,
  ];

  ActiveSessionInitial copyWith({
    CubitStatuses? statuses,
    CubitCrud? cubitCrud,
    ActiveSessionResponse? result,
    String? error,
    FilterRequest? filterRequest,
    dynamic request,
    dynamic cRequest,
    dynamic id,
  }) {
    return ActiveSessionInitial(
      statuses: statuses ?? this.statuses,
      cubitCrud: cubitCrud ?? this.cubitCrud,
      result: result ?? this.result,
      error: error ?? this.error,
      filterRequest: filterRequest ?? this.filterRequest,
      request: request ?? this.request,
      createUpdateRequest: cRequest ?? this.createUpdateRequest,
      id: id ?? this.id,
    );
  }
}
