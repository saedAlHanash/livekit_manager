part of 'user_control_cubit.dart';

class UserControlInitial extends AbstractState<String> {
  const UserControlInitial({
    required super.result,
    super.error,
    super.request,
    super.statuses,
    super.createUpdateRequest,
    super.id,
  });

  LocalParticipant? get localParticipant => request;

  UpdateParticipantRequest get updateRequest => createUpdateRequest;

  bool get micEnabled => localParticipant?.isMicrophoneEnabled() == true;

  bool get cameraEnabled => localParticipant?.isCameraEnabled() == true;

  bool get screenShareEnabled => localParticipant?.isScreenShareEnabled() == true;

  factory UserControlInitial.initial() {
    return UserControlInitial(
      result: '',
      createUpdateRequest: UpdateParticipantRequest.fromJson({}),
    );
  }

  @override
  List<Object> get props => [
    statuses,
    result,
    error,
    ?request,
    ?createUpdateRequest,
    ?id,
    ?filterRequest,
  ];

  UserControlInitial copyWith({
    CubitStatuses? statuses,
    String? result,
    String? error,
    dynamic id,
    LocalParticipant? request,
    UpdateParticipantRequest? updateRequest,
  }) {
    return UserControlInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
      request: request ?? this.request,
      createUpdateRequest: updateRequest ?? createUpdateRequest,
    );
  }
}
