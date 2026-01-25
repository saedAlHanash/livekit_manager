part of 'signal_r_cubit.dart';

class SignalRInitial extends AbstractState<HubConnection?> {
  const SignalRInitial({
    super.result,
    super.error,
    super.statuses,
    super.request,
    required this.connectionIds,
    required this.connectionState,

    required super.id,
  });

  final List<String> connectionIds;

  final SignalRStatus connectionState;

  SignalMessage get message => request;

  SignalStudentStatus get signalStudentStatus => SignalStudentStatus.values[id];

  factory SignalRInitial.initial() {
    return SignalRInitial(
      connectionState: SignalRStatus.notConnected,

      id: SignalStudentStatus.nun.index,
      connectionIds: [],
    );
  }

  @override
  List<Object> get props => [
    statuses,
    if (result != null) result!,
    error,
    connectionIds,
    id,
    connectionState,

    if (request != null) request,
    if (filterRequest != null) filterRequest!,
  ];

  SignalRInitial copyWith({
    CubitStatuses? statuses,
    HubConnection? result,
    String? error,
    SignalStudentStatus? signalStudentStatus,
    String? request,
    List<String>? connectionIds,
    SignalRStatus? connectionState,
  }) {
    return SignalRInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      connectionIds: connectionIds ?? this.connectionIds,
      connectionState: connectionState ?? this.connectionState,
      request: request ?? this.request,
      id: signalStudentStatus?.index ?? SignalStudentStatus.nun.index,
    );
  }
}
