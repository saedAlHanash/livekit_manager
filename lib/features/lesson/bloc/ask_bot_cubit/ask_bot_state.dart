part of 'ask_bot_cubit.dart';

class AskBotInitial extends AbstractState<AskBotResponse> {
  const AskBotInitial({
    required super.result,
    super.error,
    super.request,
    super.filterRequest,
    super.cubitCrud,
    super.createUpdateRequest,
    super.statuses,
    super.id,
  });

  factory AskBotInitial.initial() {
    return AskBotInitial(
      result: AskBotResponse(answer: ""),
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

  AskBotInitial copyWith({
    CubitStatuses? statuses,
    CubitCrud? cubitCrud,
    AskBotResponse? result,
    String? error,
    FilterRequest? filterRequest,
    dynamic request,
    dynamic cRequest,
    dynamic id,
  }) {
    return AskBotInitial(
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
