part of 'setting_cubit.dart';

class SettingInitial extends AbstractState<Setting> {
  const SettingInitial({
    required super.result,
    super.error,
    required super.request,
    super.statuses,
    super.id,
  });

  factory SettingInitial.initial() {
    return SettingInitial(
      result: Setting.fromJson({}),
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
      
  SettingInitial copyWith({
    CubitStatuses? statuses,
    Setting? result,
    String? error,
    dynamic id,
    String? request,
  }) {
    return SettingInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
      request: request ?? this.request,
    );
  }
}

   