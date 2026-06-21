import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
import 'package:livekit_manager/features/room/data/request/setting_message.dart';
import 'package:livekit_manager/features/whiteboard/data/models/stroke_model.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';

class WhiteboardState {
  final Map<String, StrokeModel> finalizedStrokes;
  final Map<String, StrokeModel> liveStrokes;
  final String userColor;
  final bool isLoading;
  final String error;

  WhiteboardState({
    required this.finalizedStrokes,
    required this.liveStrokes,
    required this.userColor,
    this.isLoading = false,
    this.error = '',
  });

  factory WhiteboardState.initial() {
    return WhiteboardState(
      finalizedStrokes: {},
      liveStrokes: {},
      userColor: '#000000',
    );
  }

  WhiteboardState copyWith({
    Map<String, StrokeModel>? finalizedStrokes,
    Map<String, StrokeModel>? liveStrokes,
    String? userColor,
    bool? isLoading,
    String? error,
  }) {
    return WhiteboardState(
      finalizedStrokes: finalizedStrokes ?? this.finalizedStrokes,
      liveStrokes: liveStrokes ?? this.liveStrokes,
      userColor: userColor ?? this.userColor,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class WhiteboardCubit extends Cubit<WhiteboardState> {
  final String sessionId;
  final String userId;
  final RoomCubit _roomCubit;

  StreamSubscription? _lkSubscription;

  WhiteboardCubit({
    required this.sessionId,
    required this.userId,
    required RoomCubit roomCubit,
  })  : _roomCubit = roomCubit,
        super(WhiteboardState.initial()) {
    _init();
  }

  void _init() {
    final userColor = _determineColor();
    emit(state.copyWith(userColor: userColor));

    // Load cached drawing history from Hive box
    _loadCachedStrokes();

    _lkSubscription = _roomCubit.messageStream.listen((msg) {
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
        default:
          break;
      }
    });

    Timer(const Duration(milliseconds: 500), () {
      _requestStateFromPeers();
    });
  }

  String _determineColor() {
    final colorVal = userId.colorFromId.toARGB32();
    return '#${(colorVal & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  Future<void> _loadCachedStrokes() async {
    emit(state.copyWith(isLoading: true));
    try {
      final box = await Hive.openBox<String>('whiteboard_strokes');
      final cachedData = box.get(sessionId);
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
      await box.put(sessionId, jsonEncode(strokesJsonList));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to cache strokes: $e'));
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

  void _handleIncomingRequestState(LkMessage msg) {
    final requestorId = msg.ownerId;
    if (requestorId == userId) return;

    if (state.finalizedStrokes.isNotEmpty) {
      final strokesJsonList = state.finalizedStrokes.values.map((s) => s.toJson()).toList();
      final lkMsg = LkMessage(
        action: ManagerActions.sendState,
        metadata: {
          'strokes': strokesJsonList,
          'targetId': requestorId,
        },
      );
      _roomCubit.state.result.localParticipant?.publishData(
        lkMsg.toBytes,
        reliable: true,
      );
    }
  }

  Future<void> _handleIncomingSendState(LkMessage msg) async {
    final targetId = msg.metadata['targetId'] ?? '';
    if (targetId != userId) return;
    if (state.finalizedStrokes.isNotEmpty) return;

    final list = msg.strokesData;
    final newFinalized = <String, StrokeModel>{};

    for (final item in list) {
      final stroke = StrokeModel.fromJson(Map<String, dynamic>.from(item));
      if (stroke.status == 'active') {
        newFinalized[stroke.strokeId] = stroke;
      }
    }

    emit(state.copyWith(finalizedStrokes: newFinalized));
    await _saveToHive();
  }

  void _requestStateFromPeers() {
    final lkMsg = LkMessage(
      action: ManagerActions.requestState,
      metadata: {
        'ownerId': userId,
      },
    );
    _roomCubit.state.result.localParticipant?.publishData(
      lkMsg.toBytes,
      reliable: true,
    );
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
    _roomCubit.state.result.localParticipant?.publishData(
      lkMsg.toBytes,
      reliable: false,
    );
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
    _roomCubit.state.result.localParticipant?.publishData(
      lkMsg.toBytes,
      reliable: true,
    );

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
    _roomCubit.state.result.localParticipant?.publishData(
      lkMsg.toBytes,
      reliable: true,
    );

    final currentLive = Map<String, StrokeModel>.from(state.liveStrokes)..remove(latestStroke.strokeId);
    final currentFinalized = Map<String, StrokeModel>.from(state.finalizedStrokes)..remove(latestStroke.strokeId);
    emit(state.copyWith(liveStrokes: currentLive, finalizedStrokes: currentFinalized));

    await _saveToHive();
  }

  @override
  Future<void> close() {
    _lkSubscription?.cancel();
    return super.close();
  }
}
