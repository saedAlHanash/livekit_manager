part of 'user_control_cubit.dart';

class MMSUserControlInitial extends AbstractState<String> {
  const MMSUserControlInitial({
    required super.result,
    super.error,
    super.request,
    super.statuses,
    super.createUpdateRequest,
    super.id,
  });

  Room? get room => request as Room?;

  LocalParticipant? get localParticipant => room?.localParticipant;

  UpdateParticipantRequest get updateRequest => createUpdateRequest;

  bool get micEnabled => localParticipant?.isMicrophoneEnabled() == true;

  bool get cameraEnabled => localParticipant?.isCameraEnabled() == true;

  bool get screenShareEnabled => localParticipant?.isScreenShareEnabled() == true;

  factory MMSUserControlInitial.initial() {
    return MMSUserControlInitial(
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

  MMSUserControlInitial copyWith({
    CubitStatuses? statuses,
    String? result,
    String? error,
    dynamic id,
    Room? request,
    UpdateParticipantRequest? updateRequest,
  }) {
    return MMSUserControlInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
      request: request ?? this.request,
      createUpdateRequest: updateRequest ?? createUpdateRequest,
    );
  }
}
