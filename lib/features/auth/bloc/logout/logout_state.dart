part of 'logout_cubit.dart';

class LogoutInitial extends AbstractState<bool> {


  const LogoutInitial({
    required super.statuses,
    required super.result,
    required super.error,
  });

  factory LogoutInitial.initial() {
    return const LogoutInitial(
      result: false,
      error: '',
      statuses: CubitStatuses.init,
    );
  }

  @override
  List<Object> get props => [
        statuses,
        result,
        error,

      ];

  LogoutInitial copyWith({
    CubitStatuses? statuses,
    bool? result,
    String? error,
  }) {
    return LogoutInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}
