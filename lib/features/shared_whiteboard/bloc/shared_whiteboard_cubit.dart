import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/features/shared_whiteboard/data/models/stroke_model.dart';
import 'package:livekit_manager/features/shared_whiteboard/data/models/whiteboard_message.dart';
import 'package:livekit_manager/services/images/compress_service.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
import 'package:m_cubit/m_cubit.dart';

part 'shared_whiteboard_state.dart';

class SharedWhiteboardCubit extends MCubit<SharedWhiteboardState> {
  SharedWhiteboardCubit({
    required this.sessionId,
    required this.userId,
    required this.userName,
    required this.userType,
    required RoomCubit roomCubit,
  }) : _roomCubit = roomCubit,
       super(SharedWhiteboardState.initial()) {
    _init();
  }

  final String sessionId;
  final String userId;
  final String userName;
  final String userType;
  final RoomCubit _roomCubit;

  StreamSubscription? _signalSubscription;
  StreamSubscription? _statusSubscription;

  void _init() {
    emit(state.copyWith(userColor: _determineColor()));

    _loadCachedData();

    _listeners();
  }

  void _listeners() {
    emit(state.copyWith(connectionState: _roomCubit.state.statuses == CubitStatuses.done ? SignalRStatus.connected : SignalRStatus.notConnected));

    _statusSubscription = _roomCubit.stream.listen((roomState) {
      emit(state.copyWith(connectionState: roomState.statuses == CubitStatuses.done ? SignalRStatus.connected : SignalRStatus.notConnected));
    });

    _signalSubscription = _roomCubit.whiteboardStream.listen((bytes) {
      try {
        final msg = WhiteboardMessage.fromBytes(bytes);
        _processWhiteboardMessage(msg);
      } catch (e) {
        loggerObject.e('Failed to parse incoming LiveKit whiteboard message: $e');
      }
    });
  }

  String _determineColor() {
    final colorVal = userId.colorFromId.toARGB32();
    return '#${(colorVal & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  Future<void> _loadCachedData() async {
    final cachedData = await CachingService.getFromBucket(key: sessionId);
    if (cachedData == null) return;

    try {
      final decoded = jsonDecode(cachedData);
      if (decoded is Map) {
        final List strokesList = decoded['strokes'] ?? [];
        final finalizedStrokes = Map.fromEntries(
          strokesList
              .map((item) => StrokeModel.fromJson(Map<String, dynamic>.from(item)))
              .where((stroke) => stroke.status == 'active')
              .map((stroke) => MapEntry(stroke.strokeId, stroke)),
        );

        final bg = decoded['background'] ?? {};
        emit(state.copyWith(
          finalizedStrokes: finalizedStrokes,
          backgroundUrl: bg['url'] ?? '',
          backgroundScale: (bg['scale'] as num?)?.toDouble() ?? 1.0,
          backgroundX: (bg['x'] as num?)?.toDouble() ?? 0.0,
          backgroundY: (bg['y'] as num?)?.toDouble() ?? 0.0,
        ));
      } else if (decoded is List) {
        final finalizedStrokes = Map.fromEntries(
          decoded
              .map((item) => StrokeModel.fromJson(Map<String, dynamic>.from(item)))
              .where((stroke) => stroke.status == 'active')
              .map((stroke) => MapEntry(stroke.strokeId, stroke)),
        );
        emit(state.copyWith(finalizedStrokes: finalizedStrokes));
      }
    } catch (e) {
      loggerObject.e('Error loading cached whiteboard data: $e');
    }
  }

  Future<void> _saveToCache() async {
    final data = {
      'strokes': state.finalizedStrokes.values.map((s) => s.toJson()).toList(),
      'background': {
        'url': state.backgroundUrl,
        'scale': state.backgroundScale,
        'x': state.backgroundX,
        'y': state.backgroundY,
      },
    };
    CachingService.addInBucket(
      key: sessionId,
      jsonEncode: jsonEncode(data),
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
      await _roomCubit.state.result.localParticipant?.publishData(binaryBytes, reliable: true, topic: 'whiteboard');
    } catch (e) {
      loggerObject.e('Failed to send LiveKit whiteboard binary message: $e');
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

    await _saveToCache();
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

    await _saveToCache();
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
    _saveToCache();
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
    _saveToCache();
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

    await _saveToCache();
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

    await _saveToCache();
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

    await _saveToCache();
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

    await _saveToCache();
  }

  Future<void> uploadAndSetBackground(Uint8List fileBytes, String extension) async {
    emit(state.copyWith(isLoading: true));
    try {
      final compressService = CompressService();
      if (!compressService.isAllowedImage(extension, fileBytes)) {
        emit(state.copyWith(error: 'Only image files are allowed'));
        return;
      }

      final compressedImage = await compressService.compressImage(
        fileBytes,
        originalExtension: extension,
      );

      final uploadFileObj = UploadFile(
        fileBytes: compressedImage.bytes,
        nameField: 'File',
        type: compressedImage.extension,
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
        await _saveToCache();
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
    _saveToCache();
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
//
// https://lk-m.codemagic.app/shared_whiteboard?lessonId=ed783d91-a4fd-4610-2092-08de58154480
// userId=91893eac-6b2c-4d1e-59ee-08ddcdb40330
// userName=teacher
// userType=teacher
// token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6ImNiMzc4ZjVjLWU4YmYtNGM1OC0wOGNmLTA4ZGRjZGIzZDViNSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6InJha2FuLmFsYXNzdGFAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwOS8wOS9pZGVudGl0eS9jbGFpbXMvYWN0b3IiOiJDbGllbnQiLCJTZXNzaW9uSWQiOiJjOGMwYWNlZS0xMzY3LTRmNDktOGE3Yy0yZWQ0YzlmNGFjZTUiLCJuYmYiOjE3ODI2NTM2NDAsImV4cCI6MTc4Mjg2OTY0MCwiaXNzIjoibG9jYWxob3N0IiwiYXVkIjoibG9jYWxob3N0In0.kDkWC8vpqmebC8semBqcwTzv57xHH_FhbQeF4nCgRaM
