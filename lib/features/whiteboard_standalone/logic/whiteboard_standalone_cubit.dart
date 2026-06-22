import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:signalr_core_new/signalr_core_new.dart';

import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/features/whiteboard_standalone/data/models/stroke_model.dart';
import 'package:livekit_manager/features/room/data/request/setting_message.dart';
import 'package:livekit_manager/services/signal_r/signal_message.dart';

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

  factory WhiteboardStandaloneState.initial({required bool isTeacher}) {
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

class WhiteboardStandaloneCubit extends Cubit<WhiteboardStandaloneState> {
  final String lessonId;
  final String userId;
  final String userName;
  final String userType;

  HubConnection? _hubConnection;

  WhiteboardStandaloneCubit({
    required this.lessonId,
    required this.userId,
    required this.userName,
    required this.userType,
  }) : super(WhiteboardStandaloneState.initial(
            isTeacher: userType.toLowerCase() == 'teacher' || userType.toLowerCase() == 'manager')) {
    _init();
  }

  String _signalRUrl(String id) => "https://signalr.coretech-mena.com/hub/$id";

  void _init() {
    final userColor = _determineColor();
    emit(state.copyWith(userColor: userColor));

    // Load cached drawing history from Hive box
    _loadCachedStrokes();

    // Start SignalR connection
    _connectSignalR();
  }

  String _determineColor() {
    final colorVal = userId.colorFromId.toARGB32();
    return '#${(colorVal & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  Future<void> _loadCachedStrokes() async {
    emit(state.copyWith(isLoading: true));
    try {
      final box = await Hive.openBox<String>('whiteboard_strokes');
      final cachedData = box.get(lessonId);
      if (cachedData != null) {
        final list = jsonDecode(cachedData) as List;
        final finalizedMap = <String, StrokeModel>{};
        for (final item in list) {
          final stroke = StrokeModel.fromJson(Map<String, dynamic>.from(item));
          if (stroke.status == 'active') {
            finalizedMap[stroke.strokeId] = stroke;
          }
        }
        emit(state.copyWith(finalizedStrokes: finalizedMap));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load cached strokes: $e'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _saveToHive() async {
    try {
      final box = await Hive.openBox<String>('whiteboard_strokes');
      final strokesJsonList = state.finalizedStrokes.values.map((s) => s.toJson()).toList();
      await box.put(lessonId, jsonEncode(strokesJsonList));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to cache strokes: $e'));
    }
  }

  Future<void> _connectSignalR() async {
    emit(state.copyWith(connectionState: SignalRStatus.reconnecting));
    try {
      _hubConnection = HubConnectionBuilder()
          .withUrl(_signalRUrl(lessonId))
          .withAutomaticReconnect()
          .build();

      _hubConnection?.onreconnected((connectionId) {
        emit(state.copyWith(connectionState: SignalRStatus.connected));
        _hubConnection?.invoke("JoinTopic", args: [lessonId, userId]);
      });

      _hubConnection?.onreconnecting((error) {
        emit(state.copyWith(connectionState: SignalRStatus.reconnecting));
      });

      _hubConnection?.onclose((error) {
        emit(state.copyWith(connectionState: SignalRStatus.notConnected));
      });

      _hubConnection?.on('ReceiveMessage', (arguments) {
        _handleIncomingMessage(arguments);
      });

      await _hubConnection?.start();
      emit(state.copyWith(connectionState: SignalRStatus.connected));

      await _hubConnection?.invoke("JoinTopic", args: [lessonId, userId]);

      // Request initial board state
      Timer(const Duration(milliseconds: 500), () {
        _requestStateFromPeers();
      });
    } catch (e) {
      emit(state.copyWith(
        connectionState: SignalRStatus.notConnected,
        error: 'SignalR connection failed: $e',
      ));
    }
  }

  void _handleIncomingMessage(List<dynamic>? arguments) {
    try {
      final rawStr = arguments?.firstOrNull?.toString() ?? '{}';
      final json = jsonDecode(rawStr) as Map<String, dynamic>;

      // Check if it is a SignalMessage wrapper
      if (json.containsKey('event')) {
        final signalMsg = SignalMessage.fromJson(json);
        if (signalMsg.event == SocketEvents.whiteboardAction) {
          final lkMessageJson = jsonDecode(signalMsg.data.image) as Map<String, dynamic>;
          final msg = LkMessage.fromJson(lkMessageJson);
          _processWhiteboardMessage(msg);
        }
      } else if (json.containsKey('action')) {
        // Fallback for direct LkMessage
        final msg = LkMessage.fromJson(json);
        _processWhiteboardMessage(msg);
      }
    } catch (e) {
      loggerObject.e('Failed to parse incoming SignalR message: $e');
    }
  }

  void _processWhiteboardMessage(LkMessage msg) {
    switch (msg.action) {
      case ManagerActions.drawPoint:
        _handleIncomingLivePoint(msg);
        break;
      case ManagerActions.finalizeStroke:
        _handleIncomingFinalize(msg);
        break;
      case ManagerActions.undoStroke:
        _handleIncomingUndo(msg);
        break;
      case ManagerActions.requestState:
        _handleIncomingRequestState(msg);
        break;
      case ManagerActions.sendState:
        _handleIncomingSendState(msg);
        break;
      case ManagerActions.setWhiteboardBackground:
        _handleIncomingBackground(msg);
        break;
      case ManagerActions.clearBoard:
        _handleIncomingClearBoard(msg);
        break;
      case ManagerActions.grantWhiteboard:
        _handleGrantWhiteboard(msg);
        break;
      case ManagerActions.revokeWhiteboard:
        _handleRevokeWhiteboard(msg);
        break;
      default:
        break;
    }
  }

  Future<void> _sendWhiteboardMessage(LkMessage lkMsg) async {
    if (_hubConnection == null || state.connectionState != SignalRStatus.connected) return;

    final signalMsg = SignalMessage(
      event: SocketEvents.whiteboardAction,
      data: Data(
        quizId: '',
        groupId: '',
        name: 'whiteboard',
        image: jsonEncode(lkMsg.toJson()),
        tokens: [],
      ),
    );

    try {
      await _hubConnection?.invoke(
        'SendMessageToTopic',
        args: [
          jsonEncode(signalMsg.toJson()),
          lessonId,
          false,
          '',
        ],
      );
    } catch (e) {
      loggerObject.e('Failed to send SignalR whiteboard message: $e');
    }
  }

  void _handleIncomingLivePoint(LkMessage msg) {
    final strokeId = msg.strokeId;
    final ownerId = msg.ownerId;
    final color = msg.strokeColor;
    final x = msg.x;
    final y = msg.y;
    final t = msg.t;

    if (ownerId == userId) return;
    if (state.finalizedStrokes.containsKey(strokeId)) return;

    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes);
    final existingStroke = currentLive[strokeId];
    final newPoint = StrokePointModel(x: x, y: y, t: t);

    if (existingStroke != null) {
      final updatedPoints = List<StrokePointModel>.from(existingStroke.points)..add(newPoint);
      currentLive[strokeId] = StrokeModel(
        strokeId: strokeId,
        ownerId: ownerId,
        color: color,
        points: updatedPoints,
        style: existingStroke.style,
        createdAt: existingStroke.createdAt,
        status: existingStroke.status,
      );
    } else {
      currentLive[strokeId] = StrokeModel(
        strokeId: strokeId,
        ownerId: ownerId,
        color: color,
        points: [newPoint],
        style: msg.metadata['style'] ?? 'width:3.0',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        status: 'active',
      );
    }

    emit(state.copyWith(liveStrokes: currentLive));
  }

  Future<void> _handleIncomingFinalize(LkMessage msg) async {
    final strokeId = msg.strokeId;
    final ownerId = msg.ownerId;
    final color = msg.strokeColor;
    final pointsData = msg.metadata['points'] as List? ?? [];

    if (ownerId == userId) return;

    final points = pointsData.map((e) => StrokePointModel.fromJson(e as Map<String, dynamic>)).toList();
    final finalizedStroke = StrokeModel(
      strokeId: strokeId,
      ownerId: ownerId,
      color: color,
      points: points,
      style: msg.metadata['style'] ?? 'pen',
      createdAt: msg.metadata['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      status: 'active',
    );

    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes)..remove(strokeId);
    final currentFinalized = Map<String, StrokeModel>.from(state.finalizedStrokes)..[strokeId] = finalizedStroke;

    emit(state.copyWith(
      liveStrokes: currentLive,
      finalizedStrokes: currentFinalized,
    ));

    await _saveToHive();
  }

  Future<void> _handleIncomingUndo(LkMessage msg) async {
    final targetStrokeId = msg.strokeId;
    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes)..remove(targetStrokeId);
    final currentFinalized = Map<String, StrokeModel>.from(state.finalizedStrokes)..remove(targetStrokeId);

    emit(state.copyWith(
      liveStrokes: currentLive,
      finalizedStrokes: currentFinalized,
    ));

    await _saveToHive();
  }

  void _handleIncomingBackground(LkMessage msg) {
    final bgUrl = msg.metadata['backgroundUrl'] ?? '';
    final bgScale = (msg.metadata['backgroundScale'] as num?)?.toDouble() ?? 1.0;
    final bgX = (msg.metadata['backgroundX'] as num?)?.toDouble() ?? 0.0;
    final bgY = (msg.metadata['backgroundY'] as num?)?.toDouble() ?? 0.0;
    emit(state.copyWith(
      backgroundUrl: bgUrl,
      backgroundScale: bgScale,
      backgroundX: bgX,
      backgroundY: bgY,
    ));
  }

  void _handleIncomingClearBoard(LkMessage msg) {
    emit(state.copyWith(
      liveStrokes: {},
      finalizedStrokes: {},
      backgroundUrl: '',
      backgroundScale: 1.0,
      backgroundX: 0.0,
      backgroundY: 0.0,
    ));
    _saveToHive();
  }

  void _handleIncomingRequestState(LkMessage msg) {
    final requestorId = msg.ownerId;
    if (requestorId == userId) return;

    final strokesJsonList = state.finalizedStrokes.values.map((s) => s.toJson()).toList();
    final lkMsg = LkMessage(
      action: ManagerActions.sendState,
      metadata: {
        'strokes': strokesJsonList,
        'backgroundUrl': state.backgroundUrl,
        'backgroundScale': state.backgroundScale,
        'backgroundX': state.backgroundX,
        'backgroundY': state.backgroundY,
        'targetId': requestorId,
      },
    );
    _sendWhiteboardMessage(lkMsg);
  }

  Future<void> _handleIncomingSendState(LkMessage msg) async {
    final targetId = msg.metadata['targetId'] ?? '';
    if (targetId != userId) return;
    
    final bgUrl = msg.metadata['backgroundUrl'] ?? '';
    final bgScale = (msg.metadata['backgroundScale'] as num?)?.toDouble() ?? 1.0;
    final bgX = (msg.metadata['backgroundX'] as num?)?.toDouble() ?? 0.0;
    final bgY = (msg.metadata['backgroundY'] as num?)?.toDouble() ?? 0.0;
    if (state.finalizedStrokes.isNotEmpty) return;

    final list = msg.strokesData;
    final newFinalized = <String, StrokeModel>{};

    for (final item in list) {
      final stroke = StrokeModel.fromJson(Map<String, dynamic>.from(item));
      if (stroke.status == 'active') {
        newFinalized[stroke.strokeId] = stroke;
      }
    }

    emit(state.copyWith(
      finalizedStrokes: newFinalized,
      backgroundUrl: bgUrl,
      backgroundScale: bgScale,
      backgroundX: bgX,
      backgroundY: bgY,
    ));
    await _saveToHive();
  }

  void _requestStateFromPeers() {
    final lkMsg = LkMessage(
      action: ManagerActions.requestState,
      metadata: {
        'ownerId': userId,
      },
    );
    _sendWhiteboardMessage(lkMsg);
  }

  void addLocalPoint(String strokeId, String color, double normX, double normY, int timestampMs, {String style = 'width:3.0'}) {
    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes);
    final existingStroke = currentLive[strokeId];
    final newPoint = StrokePointModel(x: normX, y: normY, t: timestampMs);

    if (existingStroke != null) {
      final updatedPoints = List<StrokePointModel>.from(existingStroke.points)..add(newPoint);
      currentLive[strokeId] = StrokeModel(
        strokeId: strokeId,
        ownerId: userId,
        color: color,
        points: updatedPoints,
        style: existingStroke.style,
        createdAt: existingStroke.createdAt,
        status: existingStroke.status,
      );
    } else {
      currentLive[strokeId] = StrokeModel(
        strokeId: strokeId,
        ownerId: userId,
        color: color,
        points: [newPoint],
        style: style,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        status: 'active',
      );
    }
    emit(state.copyWith(liveStrokes: currentLive));

    final lkMsg = LkMessage(
      action: ManagerActions.drawPoint,
      metadata: {
        'strokeId': strokeId,
        'ownerId': userId,
        'color': color,
        'x': normX,
        'y': normY,
        't': timestampMs,
        'style': style,
      },
    );
    _sendWhiteboardMessage(lkMsg);
  }

  Future<void> finalizeLocalStroke(String strokeId) async {
    final stroke = state.liveStrokes[strokeId];
    if (stroke == null) return;

    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes)..remove(strokeId);
    final currentFinalized = Map<String, StrokeModel>.from(state.finalizedStrokes)..[strokeId] = stroke;
    emit(state.copyWith(liveStrokes: currentLive, finalizedStrokes: currentFinalized));

    final lkMsg = LkMessage(
      action: ManagerActions.finalizeStroke,
      metadata: {
        'strokeId': strokeId,
        'ownerId': userId,
        'color': stroke.color,
        'points': stroke.points.map((p) => p.toJson()).toList(),
        'style': stroke.style,
        'createdAt': stroke.createdAt,
      },
    );
    _sendWhiteboardMessage(lkMsg);

    await _saveToHive();
  }

  Future<void> undo() async {
    final ourActiveStrokes = state.finalizedStrokes.values
        .where((s) => s.ownerId == userId && s.status == 'active')
        .toList();

    if (ourActiveStrokes.isEmpty) return;

    ourActiveStrokes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final latestStroke = ourActiveStrokes.first;

    final lkMsg = LkMessage(
      action: ManagerActions.undoStroke,
      metadata: {
        'strokeId': latestStroke.strokeId,
      },
    );
    _sendWhiteboardMessage(lkMsg);

    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes)..remove(latestStroke.strokeId);
    final currentFinalized = Map<String, StrokeModel>.from(state.finalizedStrokes)..remove(latestStroke.strokeId);
    emit(state.copyWith(liveStrokes: currentLive, finalizedStrokes: currentFinalized));

    await _saveToHive();
  }

  Future<void> deleteStroke(String strokeId) async {
    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes)..remove(strokeId);
    final currentFinalized = Map<String, StrokeModel>.from(state.finalizedStrokes)..remove(strokeId);
    emit(state.copyWith(liveStrokes: currentLive, finalizedStrokes: currentFinalized));

    final lkMsg = LkMessage(
      action: ManagerActions.undoStroke,
      metadata: {
        'strokeId': strokeId,
      },
    );
    _sendWhiteboardMessage(lkMsg);

    await _saveToHive();
  }

  Future<void> clearAllBoard() async {
    emit(state.copyWith(
      liveStrokes: {},
      finalizedStrokes: {},
      backgroundUrl: '',
      backgroundScale: 1.0,
      backgroundX: 0.0,
      backgroundY: 0.0,
    ));

    final lkMsg = LkMessage(
      action: ManagerActions.clearBoard,
      metadata: {},
    );
    _sendWhiteboardMessage(lkMsg);

    await _saveToHive();
  }

  Future<void> uploadAndSetBackground(Uint8List fileBytes, String extension) async {
    emit(state.copyWith(isLoading: true));
    try {
      final uploadFileObj = UploadFile(
        fileBytes: fileBytes,
        nameField: 'File',
        type: extension,
      );
      final response = await APIService().uploadMultiPart(
        url: 'FileManager/Upload',
        files: [uploadFileObj],
      );

      if (response.statusCode.success) {
        final fileName = response.jsonBody['fileName'] ?? '';
        final fileUrl = fileName.toString().fixUrl;

        emit(state.copyWith(
          backgroundUrl: fileUrl,
          backgroundScale: 1.0,
          backgroundX: 0.0,
          backgroundY: 0.0,
        ));

        final lkMsg = LkMessage(
          action: ManagerActions.setWhiteboardBackground,
          metadata: {
            'backgroundUrl': fileUrl,
            'backgroundScale': 1.0,
            'backgroundX': 0.0,
            'backgroundY': 0.0,
          },
        );
        _sendWhiteboardMessage(lkMsg);
      } else {
        emit(state.copyWith(error: 'Failed to upload image: ${response.reasonPhrase}'));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to upload background: $e'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void updateBackgroundTransform(double scale, double x, double y) {
    emit(state.copyWith(
      backgroundScale: scale,
      backgroundX: x,
      backgroundY: y,
    ));

    final lkMsg = LkMessage(
      action: ManagerActions.setWhiteboardBackground,
      metadata: {
        'backgroundUrl': state.backgroundUrl,
        'backgroundScale': scale,
        'backgroundX': x,
        'backgroundY': y,
      },
    );
    _sendWhiteboardMessage(lkMsg);
  }

  void _handleGrantWhiteboard(LkMessage msg) {
    final studentId = msg.metadata['studentId'] ?? '';
    if (studentId == userId) {
      emit(state.copyWith(hasWritePermission: true));
    }
  }

  void _handleRevokeWhiteboard(LkMessage msg) {
    final studentId = msg.metadata['studentId'] ?? '';
    if (studentId == userId) {
      emit(state.copyWith(hasWritePermission: false));
    }
  }

  @override
  Future<void> close() {
    _hubConnection?.stop();
    return super.close();
  }
}
