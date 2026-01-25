part of 'staff_records_cubit.dart';

class StaffRecordsInitial extends AbstractState<List<StaffRecord>> {
  const StaffRecordsInitial({
    required super.result,
    super.error,
    super.request,
    super.filterRequest,
    super.cubitCrud,
    super.createUpdateRequest,
    super.statuses,
    super.id,
  });

  factory StaffRecordsInitial.initial() {
    return  StaffRecordsInitial(
      result: [],
      createUpdateRequest: CreateStaffRecordRequest.fromJson({}),
    );
  }

  CreateStaffRecordRequest get cRequest => createUpdateRequest;

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

  StaffRecordsInitial copyWith({
    CubitStatuses? statuses,
    CubitCrud? cubitCrud,
    List<StaffRecord>? result,
    String? error,
    FilterRequest? filterRequest,
    dynamic request,
    dynamic cRequest,
    dynamic id,
  }) {
    return StaffRecordsInitial(
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

