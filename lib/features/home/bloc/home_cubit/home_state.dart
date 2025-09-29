part of 'home_cubit.dart';

class HomeInitial extends AbstractState<Home> {
  const HomeInitial({
    required super.result,
    super.error,
    required super.request,
    super.statuses,
    super.id,
  });

  factory HomeInitial.initial() {
    return HomeInitial(
      result: Home.fromJson({}),
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
      
  HomeInitial copyWith({
    CubitStatuses? statuses,
    Home? result,
    String? error,
    dynamic id,
    String? request,
  }) {
    return HomeInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
      request: request ?? this.request,
    );
  }
}

   