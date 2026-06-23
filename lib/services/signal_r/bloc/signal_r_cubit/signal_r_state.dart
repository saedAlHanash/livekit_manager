part of 'signal_r_cubit.dart';

class SignalRInitial extends AbstractState<HubConnection?> {
  const SignalRInitial({
    super.result,
    super.error,
    super.statuses,
    super.request,
    required this.connectionIds,
    required this.connectionState,
  });

  final List<String> connectionIds;
  final SignalRStatus connectionState;

  SignalMessage get message => request ?? SignalMessage.fromJson({});

  factory SignalRInitial.initial() {
    return const SignalRInitial(
      connectionState: SignalRStatus.notConnected,
      connectionIds: [],
    );
  }

  @override
  List<Object> get props => [
    statuses,
    if (result != null) result!,
    error,
    connectionIds,
    if (id != null) id,
    connectionState,
    if (request != null) request,
    if (filterRequest != null) filterRequest!,
  ];

  SignalRInitial copyWith({
    CubitStatuses? statuses,
    HubConnection? result,
    String? error,
    SignalMessage? request,
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
    );
  }
}
