import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/features/shared_whiteboard/data/models/stroke_model.dart';
import 'package:livekit_manager/features/shared_whiteboard/data/models/whiteboard_message.dart';
import 'package:livekit_manager/services/signal_r/bloc/signal_r_cubit/signal_r_cubit.dart';
import 'package:m_cubit/m_cubit.dart';

part 'shared_whiteboard_state.dart';

class SharedWhiteboardCubit extends MCubit<SharedWhiteboardState> {
  SharedWhiteboardCubit({
    required this.sessionId,
    required this.userId,
    required this.userName,
    required this.userType,
    required SignalRCubit signalRCubit,
  }) : _signalRCubit = signalRCubit,
       super(SharedWhiteboardState.initial()) {
    _init();
  }

  final String sessionId;
  final String userId;
  final String userName;
  final String userType;
  final SignalRCubit _signalRCubit;

  StreamSubscription? _signalSubscription;
  StreamSubscription? _statusSubscription;

  void _init() {
    emit(state.copyWith(userColor: _determineColor()));

    _loadCachedStrokes();

    _listeners();
  }

  void _listeners() {
    emit(state.copyWith(connectionState: _signalRCubit.state.connectionState));

    _statusSubscription = _signalRCubit.stream.listen((signalState) {
      emit(state.copyWith(connectionState: signalState.connectionState));
    });

    _signalSubscription = _signalRCubit.whiteboardStream.listen((bytes) {
      try {
        final msg = WhiteboardMessage.fromBytes(bytes);
        _processWhiteboardMessage(msg);
      } catch (e) {
        loggerObject.e('Failed to parse incoming SignalR whiteboard message: $e');
      }
    });
  }

  String _determineColor() {
    final colorVal = userId.colorFromId.toARGB32();
    return '#${(colorVal & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  Future<void> _loadCachedStrokes() async {
    final cachedData = await CachingService.getFromBucket(key: sessionId) ?? '[]';
    final List list = jsonDecode(cachedData);

    final finalizedStrokes = Map.fromEntries(
      list
          .map((item) => StrokeModel.fromJson(Map<String, dynamic>.from(item)))
          .where((stroke) => stroke.status == 'active')
          .map((stroke) => MapEntry(stroke.strokeId, stroke)),
    );

    emit(state.copyWith(finalizedStrokes: finalizedStrokes));
  }

  Future<void> _saveToHive() async {
    CachingService.addInBucket(
      key: sessionId,
      jsonEncode: jsonEncode(state.finalizedStrokes.values.map((s) => s.toJson()).toList()),
    );
  }

  void _processWhiteboardMessage(WhiteboardMessage msg) {
    switch (msg.action) {
      case WhiteboardAction.drawPoint:
        _handleIncomingLivePoint(msg);
        break;
      case WhiteboardAction.finalizeStroke:
        _handleIncomingFinalize(msg);
        break;
      case WhiteboardAction.undoStroke:
        _handleIncomingUndo(msg);
        break;
      case WhiteboardAction.setWhiteboardBackground:
        _handleIncomingBackground(msg);
        break;
      case WhiteboardAction.clearBoard:
        _handleIncomingClearBoard(msg);
        break;
      case WhiteboardAction.grantWhiteboard:
        _handleGrantWhiteboard(msg);
        break;
      case WhiteboardAction.revokeWhiteboard:
        _handleRevokeWhiteboard(msg);
        break;
    }
  }

  Future<void> _sendWhiteboardMessage(WhiteboardMessage lkMsg) async {
    if (state.connectionState != SignalRStatus.connected) return;

    final points = lkMsg.metadata['points'] as List? ?? [];
    final ptsList = points.map((e) => Map<String, dynamic>.from(e)).toList();
    if (ptsList.isEmpty && lkMsg.action == WhiteboardAction.drawPoint) {
      ptsList.add({
        'x': lkMsg.x,
        'y': lkMsg.y,
        't': lkMsg.t,
      });
    }

    final binaryBytes = serializeWhiteboardBinary(
      actionIndex: lkMsg.action.index,
      strokeId: lkMsg.strokeId,
      ownerId: lkMsg.ownerId,
      color: lkMsg.strokeColor,
      style: lkMsg.metadata['style'] ?? 'width:3.0',
      createdAt: lkMsg.metadata['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      points: ptsList,
      studentId: lkMsg.metadata['studentId'],
      backgroundUrl: lkMsg.metadata['backgroundUrl'],
      backgroundScale: (lkMsg.metadata['backgroundScale'] as num?)?.toDouble(),
      backgroundX: (lkMsg.metadata['backgroundX'] as num?)?.toDouble(),
      backgroundY: (lkMsg.metadata['backgroundY'] as num?)?.toDouble(),
    );

    try {
      await _signalRCubit.sendMessageToTopic(binaryBytes, messageType: MessageTypeEnum.bytes.index);
    } catch (e) {
      loggerObject.e('Failed to send SignalR whiteboard binary message: $e');
    }
  }

  void _handleIncomingLivePoint(WhiteboardMessage msg) {
    final strokeId = msg.strokeId;
    final ownerId = msg.ownerId;
    final color = msg.strokeColor;

    if (ownerId == userId || fastHash(userId).toString() == ownerId) return;
    if (state.finalizedStrokes.containsKey(strokeId)) return;

    final List<StrokePointModel> newPoints = [];
    if (msg.metadata['points'] != null) {
      final list = msg.metadata['points'] as List;
      newPoints.addAll(list.map((e) => StrokePointModel.fromJson(Map<String, dynamic>.from(e))));
    } else {
      newPoints.add(StrokePointModel(x: msg.x, y: msg.y, t: msg.t));
    }

    if (newPoints.isEmpty) return;

    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes);
    final existingStroke = currentLive[strokeId];

    if (existingStroke != null) {
      final updatedPoints = List<StrokePointModel>.from(existingStroke.points)..addAll(newPoints);
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
        points: newPoints,
        style: msg.metadata['style'] ?? 'width:3.0',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        status: 'active',
      );
    }

    emit(state.copyWith(liveStrokes: currentLive));
  }

  Future<void> _handleIncomingFinalize(WhiteboardMessage msg) async {
    final strokeId = msg.strokeId;
    final ownerId = msg.ownerId;
    final color = msg.strokeColor;

    if (ownerId == userId || fastHash(userId).toString() == ownerId) return;

    final existingStroke = state.liveStrokes[strokeId];
    final points = existingStroke?.points ?? [];

    final finalizedStroke = StrokeModel(
      strokeId: strokeId,
      ownerId: existingStroke?.ownerId ?? ownerId,
      color: existingStroke?.color ?? color,
      points: points,
      style: existingStroke?.style ?? msg.metadata['style'] ?? 'width:3.0',
      createdAt: existingStroke?.createdAt ?? msg.metadata['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      status: 'active',
    );

    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes)..remove(strokeId);
    final currentFinalized = Map<String, StrokeModel>.from(state.finalizedStrokes)..[strokeId] = finalizedStroke;

    emit(
      state.copyWith(
        liveStrokes: currentLive,
        finalizedStrokes: currentFinalized,
      ),
    );

    await _saveToHive();
  }

  Future<void> _handleIncomingUndo(WhiteboardMessage msg) async {
    final targetStrokeId = msg.strokeId;
    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes)..remove(targetStrokeId);
    final currentFinalized = Map<String, StrokeModel>.from(state.finalizedStrokes)..remove(targetStrokeId);

    emit(
      state.copyWith(
        liveStrokes: currentLive,
        finalizedStrokes: currentFinalized,
      ),
    );

    await _saveToHive();
  }

  void _handleIncomingBackground(WhiteboardMessage msg) {
    final bgUrl = msg.metadata['backgroundUrl'] ?? '';
    final bgScale = (msg.metadata['backgroundScale'] as num?)?.toDouble() ?? 1.0;
    final bgX = (msg.metadata['backgroundX'] as num?)?.toDouble() ?? 0.0;
    final bgY = (msg.metadata['backgroundY'] as num?)?.toDouble() ?? 0.0;
    emit(
      state.copyWith(
        backgroundUrl: bgUrl,
        backgroundScale: bgScale,
        backgroundX: bgX,
        backgroundY: bgY,
      ),
    );
  }

  void _handleIncomingClearBoard(WhiteboardMessage msg) {
    emit(
      state.copyWith(
        liveStrokes: {},
        finalizedStrokes: {},
        backgroundUrl: '',
        backgroundScale: 1.0,
        backgroundX: 0.0,
        backgroundY: 0.0,
      ),
    );
    _saveToHive();
  }



  void addLocalPoint(
    String strokeId,
    String color,
    double normX,
    double normY,
    int timestampMs, {
    String style = 'width:3.0',
  }) {
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

    final whiteboardMsg = WhiteboardMessage(
      action: WhiteboardAction.drawPoint,
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
    _sendWhiteboardMessage(whiteboardMsg);
  }

  void addPointLocally(
    String strokeId,
    String color,
    double normX,
    double normY,
    int timestampMs, {
    String style = 'width:3.0',
  }) {
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
  }

  void broadcastPointsBatch(
    String strokeId,
    String color,
    List<Map<String, dynamic>> points, {
    String style = 'width:3.0',
  }) {
    final whiteboardMsg = WhiteboardMessage(
      action: WhiteboardAction.drawPoint,
      metadata: {
        'strokeId': strokeId,
        'ownerId': userId,
        'color': color,
        'points': points,
        'style': style,
        if (points.isNotEmpty) ...{
          'x': (points.first['x'] as num).toDouble(),
          'y': (points.first['y'] as num).toDouble(),
          't': (points.first['t'] as num).toInt(),
        },
      },
    );
    _sendWhiteboardMessage(whiteboardMsg);
  }

  Future<void> finalizeLocalStroke(String strokeId) async {
    final stroke = state.liveStrokes[strokeId];
    if (stroke == null) return;

    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes)..remove(strokeId);
    final currentFinalized = Map<String, StrokeModel>.from(state.finalizedStrokes)..[strokeId] = stroke;
    emit(state.copyWith(liveStrokes: currentLive, finalizedStrokes: currentFinalized));

    final whiteboardMsg = WhiteboardMessage(
      action: WhiteboardAction.finalizeStroke,
      metadata: {
        'strokeId': strokeId,
        'ownerId': userId,
        'color': stroke.color,
        'points': const [],
        'style': stroke.style,
        'createdAt': stroke.createdAt,
      },
    );
    _sendWhiteboardMessage(whiteboardMsg);

    await _saveToHive();
  }

  Future<void> undo() async {
    final ourActiveStrokes = state.finalizedStrokes.values
        .where((s) => s.ownerId == userId && s.status == 'active')
        .toList();

    if (ourActiveStrokes.isEmpty) return;

    ourActiveStrokes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final latestStroke = ourActiveStrokes.first;

    final whiteboardMsg = WhiteboardMessage(
      action: WhiteboardAction.undoStroke,
      metadata: {
        'strokeId': latestStroke.strokeId,
      },
    );
    _sendWhiteboardMessage(whiteboardMsg);

    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes)..remove(latestStroke.strokeId);
    final currentFinalized = Map<String, StrokeModel>.from(state.finalizedStrokes)..remove(latestStroke.strokeId);
    emit(state.copyWith(liveStrokes: currentLive, finalizedStrokes: currentFinalized));

    await _saveToHive();
  }

  Future<void> deleteStroke(String strokeId) async {
    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes)..remove(strokeId);
    final currentFinalized = Map<String, StrokeModel>.from(state.finalizedStrokes)..remove(strokeId);
    emit(state.copyWith(liveStrokes: currentLive, finalizedStrokes: currentFinalized));

    final whiteboardMsg = WhiteboardMessage(
      action: WhiteboardAction.undoStroke,
      metadata: {
        'strokeId': strokeId,
      },
    );
    _sendWhiteboardMessage(whiteboardMsg);

    await _saveToHive();
  }

  Future<void> clearAllBoard() async {
    emit(
      state.copyWith(
        liveStrokes: {},
        finalizedStrokes: {},
        backgroundUrl: '',
        backgroundScale: 1.0,
        backgroundX: 0.0,
        backgroundY: 0.0,
      ),
    );

    final whiteboardMsg = WhiteboardMessage(
      action: WhiteboardAction.clearBoard,
      metadata: {},
    );
    _sendWhiteboardMessage(whiteboardMsg);

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

        emit(
          state.copyWith(
            backgroundUrl: fileUrl,
            backgroundScale: 1.0,
            backgroundX: 0.0,
            backgroundY: 0.0,
          ),
        );

        final whiteboardMsg = WhiteboardMessage(
          action: WhiteboardAction.setWhiteboardBackground,
          metadata: {
            'backgroundUrl': fileUrl,
            'backgroundScale': 1.0,
            'backgroundX': 0.0,
            'backgroundY': 0.0,
          },
        );
        _sendWhiteboardMessage(whiteboardMsg);
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
    emit(
      state.copyWith(
        backgroundScale: scale,
        backgroundX: x,
        backgroundY: y,
      ),
    );

    final whiteboardMsg = WhiteboardMessage(
      action: WhiteboardAction.setWhiteboardBackground,
      metadata: {
        'backgroundUrl': state.backgroundUrl,
        'backgroundScale': scale,
        'backgroundX': x,
        'backgroundY': y,
      },
    );
    _sendWhiteboardMessage(whiteboardMsg);
  }

  void _handleGrantWhiteboard(WhiteboardMessage msg) {
    final studentId = msg.metadata['studentId'] ?? '';
    if (studentId == userId) {
      emit(state.copyWith(hasWritePermission: true));
    }
  }

  void _handleRevokeWhiteboard(WhiteboardMessage msg) {
    final studentId = msg.metadata['studentId'] ?? '';
    if (studentId == userId) {
      emit(state.copyWith(hasWritePermission: false));
    }
  }

  @override
  Future<void> close() {
    _signalSubscription?.cancel();
    _statusSubscription?.cancel();
    return super.close();
  }

  @override
  get mState => state;
}
