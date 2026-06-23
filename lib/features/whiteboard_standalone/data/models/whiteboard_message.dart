import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';import 'package:m_cubit/util.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/features/whiteboard_standalone/data/models/stroke_model.dart';
import 'package:livekit_manager/features/whiteboard_standalone/data/models/whiteboard_message.dart';
import 'package:livekit_manager/services/signal_r/signal_message.dart';
import 'package:livekit_manager/services/signal_r/bloc/signal_r_cubit/signal_r_cubit.dart';

class WhiteboardMessage {
  final WhiteboardAction action;
  final Map<String, dynamic> metadata;

  WhiteboardMessage({
    required this.action,
    required this.metadata,
  });

  String get strokeId => metadata['strokeId'] ?? '';

  String get ownerId => metadata['ownerId'] ?? '';

  String get strokeColor => metadata['color'] ?? '';

  double get x => (metadata['x'] as num?)?.toDouble() ?? 0.0;

  double get y => (metadata['y'] as num?)?.toDouble() ?? 0.0;

  int get t => (metadata['t'] as num?)?.toInt() ?? 0;

  List<dynamic> get strokesData => metadata['strokes'] as List? ?? [];

  factory WhiteboardMessage.fromJson(Map<String, dynamic> json) {
    return WhiteboardMessage(
      action: WhiteboardAction.values[json['action'] ?? 0],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  factory WhiteboardMessage.fromBytes(Uint8List rawBytes) {
    final json = _deserializeWhiteboardBinary(rawBytes);
    return WhiteboardMessage(
      action: WhiteboardAction.values[json['action'] ?? 0],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'action': action.index,
    'metadata': metadata,
  };

}
  Uint8List serializeWhiteboardBinary({
  required int actionIndex,
  required String strokeId,
  required String ownerId,
  required String color,
  required String style,
  required int createdAt,
  required List<Map<String, dynamic>> points,
  }) {
  final strokeIdBytes = utf8.encode(strokeId);
  final ownerIdBytes = utf8.encode(ownerId);
  final colorBytes = utf8.encode(color);
  final styleBytes = utf8.encode(style);

  final builder = BytesBuilder();
  builder.addByte(actionIndex);

  builder.addByte(strokeIdBytes.length);
  builder.add(strokeIdBytes);

  builder.addByte(ownerIdBytes.length);
  builder.add(ownerIdBytes);

  builder.addByte(colorBytes.length);
  builder.add(colorBytes);

  builder.addByte(styleBytes.length);
  builder.add(styleBytes);

  final tHeader = ByteData(10);
  final high = createdAt ~/ 0x100000000;
  final low = createdAt % 0x100000000;
  tHeader.setUint32(0, high);
  tHeader.setUint32(4, low);
  tHeader.setUint16(8, points.length);
  builder.add(tHeader.buffer.asUint8List());

  final ptsData = ByteData(points.length * 12);
  for (var i = 0; i < points.length; i++) {
  final pt = points[i];
  final double x = (pt['x'] as num).toDouble();
  final double y = (pt['y'] as num).toDouble();
  final int t = (pt['t'] as num).toInt();

  ptsData.setFloat32(i * 12, x);
  ptsData.setFloat32(i * 12 + 4, y);
  ptsData.setInt32(i * 12 + 8, t);
  }
  builder.add(ptsData.buffer.asUint8List());

  return builder.toBytes();
  }

  Map<String, dynamic> _deserializeWhiteboardBinary(Uint8List bytes) {
  var offset = 0;
  final actionIndex = bytes[offset++];

  final strokeIdLen = bytes[offset++];
  final strokeId = utf8.decode(bytes.sublist(offset, offset + strokeIdLen));
  offset += strokeIdLen;

  final ownerIdLen = bytes[offset++];
  final ownerId = utf8.decode(bytes.sublist(offset, offset + ownerIdLen));
  offset += ownerIdLen;

  final colorLen = bytes[offset++];
  final color = utf8.decode(bytes.sublist(offset, offset + colorLen));
  offset += colorLen;

  final styleLen = bytes[offset++];
  final style = utf8.decode(bytes.sublist(offset, offset + styleLen));
  offset += styleLen;

  final tHeader = ByteData.sublistView(bytes, offset, offset + 10);
  final high = tHeader.getUint32(0);
  final low = tHeader.getUint32(4);
  final createdAt = high * 0x100000000 + low;
  final pointsCount = tHeader.getUint16(8);
  offset += 10;

  final points = <Map<String, dynamic>>[];
  final ptsData = ByteData.sublistView(bytes, offset, offset + pointsCount * 12);
  for (var i = 0; i < pointsCount; i++) {
  final x = ptsData.getFloat32(i * 12);
  final y = ptsData.getFloat32(i * 12 + 4);
  final t = ptsData.getInt32(i * 12 + 8);
  points.add({'x': x, 'y': y, 't': t});
  }

  return {
  'action': actionIndex,
  'id': '',
  'metadata': {
  'strokeId': strokeId,
  'ownerId': ownerId,
  'color': color,
  'style': style,
  'createdAt': createdAt,
  'points': points,
  if (points.isNotEmpty) ...{
  'x': points.first['x'],
  'y': points.first['y'],
  't': points.first['t'],
  },
  },
  };
  }
