part of 'staff_record_cubit.dart';

class StaffRecordInitial extends AbstractState<StaffRecord> {
  const StaffRecordInitial({
    required super.result,
    super.error,
    required super.request,
    super.statuses,
    super.id,
  });

  factory StaffRecordInitial.initial() {
    return StaffRecordInitial(
      result: StaffRecord.fromJson({}),
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
      
  StaffRecordInitial copyWith({
    CubitStatuses? statuses,
    StaffRecord? result,
    String? error,
    dynamic id,
    String? request,
  }) {
    return StaffRecordInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
      request: request ?? this.request,
    );
  }
}

   