part of 'user_cubit.dart';

class UserInitial extends AbstractState<User> {
  const UserInitial({
    required super.result,
    super.error,
    required super.request,
    super.statuses,
    super.id,
  });

  factory UserInitial.initial() {
    return UserInitial(
      result: User.fromJson({}),
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
      
  UserInitial copyWith({
    CubitStatuses? statuses,
    User? result,
    String? error,
    dynamic id,
    String? request,
  }) {
    return UserInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
      request: request ?? this.request,
    );
  }
}

   