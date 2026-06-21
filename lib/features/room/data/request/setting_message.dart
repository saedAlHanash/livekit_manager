import 'dart:convert';
import 'dart:typed_data';

import '../../../../core/strings/enum_manager.dart';

class LkMessage {
  LkMessage({
    this.id = '',
    required this.action,
    required this.metadata,
    this.createdAt,
  });

  String id;
  final ManagerActions action;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;

  String get name => metadata['name'] ?? '';

  String get message => metadata['message'] ?? '';

  String get image => metadata['image'] ?? '';

  String get userId => metadata['id'] ?? '';

  String get strokeId => metadata['strokeId'] ?? '';
  String get ownerId => metadata['ownerId'] ?? '';
  String get strokeColor => metadata['color'] ?? '';
  double get x => (metadata['x'] as num?)?.toDouble() ?? 0.0;
  double get y => (metadata['y'] as num?)?.toDouble() ?? 0.0;
  int get t => metadata['t'] ?? 0;
  List<dynamic> get strokesData => metadata['strokes'] as List? ?? [];

  factory LkMessage.fromJson(Map<String, dynamic> json) {
    return LkMessage(
      id: (json['id'] ?? '').toString(),
      action: ManagerActions.values[json['action'] ?? 0],
      metadata: json['metadata'] ?? {},
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] ?? '') : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'metadata': metadata,
    'action': action.index,
    'created_at': createdAt?.toIso8601String(),
  };

  Uint8List get toBytes {
    final jsonString = jsonEncode(toJson());
    return Uint8List.fromList(utf8.encode(jsonString));
  }
}
