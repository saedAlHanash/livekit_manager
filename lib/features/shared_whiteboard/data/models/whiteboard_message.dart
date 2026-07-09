import 'dart:convert';
import 'dart:typed_data';

import 'package:livekit_manager/core/strings/enum_manager.dart';

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
    if (rawBytes.isEmpty) {
      return WhiteboardMessage(
        action: WhiteboardAction.clearBoard,
        metadata: {},
      );
    }
    if (rawBytes[0] == 123) {
      try {
        final decoded = jsonDecode(utf8.decode(rawBytes));
        return WhiteboardMessage.fromJson(Map<String, dynamic>.from(decoded));
      } catch (_) {
        // Fallback to binary
      }
    }
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

int fastHash(String str) {
  var hash = 0x811c9dc5;
  final bytes = utf8.encode(str);
  for (final byte in bytes) {
    hash ^= byte;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  return hash;
}

Uint8List uuidToBytes(String uuidStr) {
  final val = int.tryParse(uuidStr);
  if (val != null) {
    final b = ByteData(4)..setInt32(0, val);
    return b.buffer.asUint8List();
  }
  final hashed = fastHash(uuidStr);
  final b = ByteData(4)..setInt32(0, hashed);
  return b.buffer.asUint8List();
}

String bytesToUuid(Uint8List bytes, int offset) {
  final val = ByteData.sublistView(bytes, offset, offset + 4).getInt32(0);
  return val.toString();
}

int colorToInt(String hexColor) {
  var clean = hexColor.replaceAll('#', '');
  if (clean.length == 6) {
    clean = 'FF$clean';
  }
  return int.tryParse(clean, radix: 16) ?? 0xFF000000;
}

String intToColor(int colorVal) {
  return '#${(colorVal & 0xFFFFFFFF).toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

double parseStyleWidth(String style) {
  final parts = style.split(':');
  if (parts.length == 2) {
    return double.tryParse(parts[1]) ?? 3.0;
  }
  return double.tryParse(style) ?? 3.0;
}

String formatStyleWidth(double width) {
  return 'width:$width';
}

Uint8List serializeWhiteboardBinary({
  required int actionIndex,
  required String strokeId,
  required String ownerId,
  required String color,
  required String style,
  required int createdAt,
  required List<Map<String, dynamic>> points,
  String? studentId,
  String? backgroundUrl,
  double? backgroundScale,
  double? backgroundX,
  double? backgroundY,
}) {
  final builder = BytesBuilder();
  builder.addByte(actionIndex);

  final action = WhiteboardAction.values[actionIndex];
  if (action == WhiteboardAction.drawPoint || action == WhiteboardAction.finalizeStroke) {
    builder.add(uuidToBytes(strokeId));
    builder.add(uuidToBytes(ownerId));

    final colorVal = colorToInt(color);
    final colorBytes = ByteData(4)..setUint32(0, colorVal);
    builder.add(colorBytes.buffer.asUint8List());

    final styleWidth = parseStyleWidth(style);
    final widthInt = (styleWidth * 10).clamp(0, 255).toInt();
    builder.addByte(widthInt);

    final tHeader = ByteData(10);
    final high = createdAt ~/ 0x100000000;
    final low = createdAt % 0x100000000;
    tHeader.setUint32(0, high);
    tHeader.setUint32(4, low);
    tHeader.setUint16(8, points.length);
    builder.add(tHeader.buffer.asUint8List());

    final ptsData = ByteData(points.length * 6);
    for (var i = 0; i < points.length; i++) {
      final pt = points[i];
      final double x = (pt['x'] as num).toDouble();
      final double y = (pt['y'] as num).toDouble();
      final int t = (pt['t'] as num).toInt();

      final int xInt = (x * 65535).clamp(0, 65535).toInt();
      final int yInt = (y * 65535).clamp(0, 65535).toInt();

      var tOffset = t - createdAt;
      if (tOffset < 0) tOffset = 0;
      if (tOffset > 65535) tOffset = 65535;

      ptsData.setUint16(i * 6, xInt);
      ptsData.setUint16(i * 6 + 2, yInt);
      ptsData.setUint16(i * 6 + 4, tOffset);
    }
    builder.add(ptsData.buffer.asUint8List());
  } else if (action == WhiteboardAction.undoStroke) {
    builder.add(uuidToBytes(strokeId));
  } else if (action == WhiteboardAction.clearBoard) {
    // No fields needed
  } else if (action == WhiteboardAction.grantWhiteboard || action == WhiteboardAction.revokeWhiteboard) {
    builder.add(uuidToBytes(studentId ?? ''));
  } else if (action == WhiteboardAction.setWhiteboardBackground) {
    final urlBytes = utf8.encode(backgroundUrl ?? '');
    builder.addByte(urlBytes.length);
    builder.add(urlBytes);

    final transformData = ByteData(12);
    transformData.setFloat32(0, backgroundScale ?? 1.0);
    transformData.setFloat32(4, backgroundX ?? 0.0);
    transformData.setFloat32(8, backgroundY ?? 0.0);
    builder.add(transformData.buffer.asUint8List());
  }

  return builder.toBytes();
}

Map<String, dynamic> _deserializeWhiteboardBinary(Uint8List bytes) {
  var offset = 0;
  final actionIndex = bytes[offset++];
  final action = WhiteboardAction.values[actionIndex];

  final metadata = <String, dynamic>{};

  if (action == WhiteboardAction.drawPoint || action == WhiteboardAction.finalizeStroke) {
    final strokeId = bytesToUuid(bytes, offset);
    offset += 4;

    final ownerId = bytesToUuid(bytes, offset);
    offset += 4;

    final colorBytes = ByteData.sublistView(bytes, offset, offset + 4);
    final colorVal = colorBytes.getUint32(0);
    final color = intToColor(colorVal);
    offset += 4;

    final widthInt = bytes[offset++];
    final style = formatStyleWidth(widthInt / 10.0);

    final tHeader = ByteData.sublistView(bytes, offset, offset + 10);
    final high = tHeader.getUint32(0);
    final low = tHeader.getUint32(4);
    final createdAt = high * 0x100000000 + low;
    final pointsCount = tHeader.getUint16(8);
    offset += 10;

    final points = <Map<String, dynamic>>[];
    final ptsData = ByteData.sublistView(bytes, offset, offset + pointsCount * 6);
    for (var i = 0; i < pointsCount; i++) {
      final xInt = ptsData.getUint16(i * 6);
      final yInt = ptsData.getUint16(i * 6 + 2);
      final tOffset = ptsData.getUint16(i * 6 + 4);

      final double x = xInt / 65535.0;
      final double y = yInt / 65535.0;
      final int t = createdAt + tOffset;

      points.add({'x': x, 'y': y, 't': t});
    }

    metadata['strokeId'] = strokeId;
    metadata['ownerId'] = ownerId;
    metadata['color'] = color;
    metadata['style'] = style;
    metadata['createdAt'] = createdAt;
    metadata['points'] = points;
    if (points.isNotEmpty) {
      metadata['x'] = points.first['x'];
      metadata['y'] = points.first['y'];
      metadata['t'] = points.first['t'];
    }
  } else if (action == WhiteboardAction.undoStroke) {
    metadata['strokeId'] = bytesToUuid(bytes, offset);
  } else if (action == WhiteboardAction.clearBoard) {
    // Nothing in metadata
  } else if (action == WhiteboardAction.grantWhiteboard || action == WhiteboardAction.revokeWhiteboard) {
    metadata['studentId'] = bytesToUuid(bytes, offset);
  } else if (action == WhiteboardAction.setWhiteboardBackground) {
    final urlLen = bytes[offset++];
    final bgUrl = utf8.decode(bytes.sublist(offset, offset + urlLen));
    offset += urlLen;

    final transformData = ByteData.sublistView(bytes, offset, offset + 12);
    final bgScale = transformData.getFloat32(0);
    final bgX = transformData.getFloat32(4);
    final bgY = transformData.getFloat32(8);

    metadata['backgroundUrl'] = bgUrl;
    metadata['backgroundScale'] = bgScale;
    metadata['backgroundX'] = bgX;
    metadata['backgroundY'] = bgY;
  }

  return {
    'action': actionIndex,
    'metadata': metadata,
  };
}
