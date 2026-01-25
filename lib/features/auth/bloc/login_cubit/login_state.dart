part of 'login_cubit.dart';

class LoginInitial extends AbstractState<LoginResponse> {
  const LoginInitial({
    required super.result,
    super.error,
    required super.request,
    super.statuses,
  });

  factory LoginInitial.initial() {
    return LoginInitial(
      result: LoginResponse.fromJson({}),
      error: '',
      request: LoginRequest(),
      statuses: CubitStatuses.init,
    );
  }

  LoginRequest get mRequest => request as LoginRequest;

  @override
  List<Object> get props => [
        statuses,
        result,
        error,
        if (request != null) request,
        if (filterRequest != null) filterRequest!
      ];

  LoginInitial copyWith({
    CubitStatuses? statuses,
    LoginResponse? result,
    String? error,
    LoginRequest? request,
  }) {
    return LoginInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      request: request ?? this.request,
    );
  }
}
