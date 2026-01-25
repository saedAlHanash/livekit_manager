part of 'logged_user_cubit.dart';

class LoggedUserInitial extends AbstractState<User> {
  const LoggedUserInitial({
    required super.result,
    super.error,
    required super.request,
    super.statuses,
  });

  factory LoggedUserInitial.initial() {
    return LoggedUserInitial(
      result: AppProvider.loginUser,
      error: '',
      request: '',
      statuses: CubitStatuses.init,
    );
  }

  @override
  List<Object> get props => [
        statuses,
        result,
        error,
        if (request != null) request,
        if (filterRequest != null) filterRequest!
      ];

  LoggedUserInitial copyWith({
    CubitStatuses? statuses,
    User? result,
    String? error,
    String? request,
  }) {
    return LoggedUserInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      request: request ?? this.request,
    );
  }
}
