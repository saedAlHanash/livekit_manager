
part of 'whiteboard_standalone_cubit.dart';
class WhiteboardStandaloneState {
  final Map<String, StrokeModel> finalizedStrokes;
  final Map<String, StrokeModel> liveStrokes;
  final String userColor;
  final String backgroundUrl;
  final double backgroundScale;
  final double backgroundX;
  final double backgroundY;
  final bool hasWritePermission;
  final bool isLoading;
  final String error;
  final SignalRStatus connectionState;

  WhiteboardStandaloneState({
    required this.finalizedStrokes,
    required this.liveStrokes,
    required this.userColor,
    required this.backgroundUrl,
    required this.backgroundScale,
    required this.backgroundX,
    required this.backgroundY,
    required this.hasWritePermission,
    this.isLoading = false,
    this.error = '',
    this.connectionState = SignalRStatus.notConnected,
  });

  factory WhiteboardStandaloneState.initial({ bool isTeacher = true}) {
    return WhiteboardStandaloneState(
      finalizedStrokes: {},
      liveStrokes: {},
      userColor: '#000000',
      backgroundUrl: '',
      backgroundScale: 1.0,
      backgroundX: 0.0,
      backgroundY: 0.0,
      hasWritePermission: isTeacher,
      connectionState: SignalRStatus.notConnected,
    );
  }

  WhiteboardStandaloneState copyWith({
    Map<String, StrokeModel>? finalizedStrokes,
    Map<String, StrokeModel>? liveStrokes,
    String? userColor,
    String? backgroundUrl,
    double? backgroundScale,
    double? backgroundX,
    double? backgroundY,
    bool? hasWritePermission,
    bool? isLoading,
    String? error,
    SignalRStatus? connectionState,
  }) {
    return WhiteboardStandaloneState(
      finalizedStrokes: finalizedStrokes ?? this.finalizedStrokes,
      liveStrokes: liveStrokes ?? this.liveStrokes,
      userColor: userColor ?? this.userColor,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      backgroundScale: backgroundScale ?? this.backgroundScale,
      backgroundX: backgroundX ?? this.backgroundX,
      backgroundY: backgroundY ?? this.backgroundY,
      hasWritePermission: hasWritePermission ?? this.hasWritePermission,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      connectionState: connectionState ?? this.connectionState,
    );
  }
}
