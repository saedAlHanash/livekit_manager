part of 'staff_details_cubit.dart';

class StaffDetailsInitial extends AbstractState<StaffDetails> {
  const StaffDetailsInitial({
    required super.result,
    super.error,
    required super.request,
    super.statuses,
    super.id,
  });

  factory StaffDetailsInitial.initial() {
    return StaffDetailsInitial(
      result: StaffDetails.fromJson({}),
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

  StaffDetailsInitial copyWith({
    CubitStatuses? statuses,
    StaffDetails? result,
    String? error,
    dynamic id,
    String? request,
  }) {
    return StaffDetailsInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
      request: request ?? this.request,
    );
  }
}
