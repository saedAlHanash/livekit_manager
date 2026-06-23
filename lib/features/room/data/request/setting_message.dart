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

  factory LkMessage.fromJson(Map<String, dynamic> json) {
    return LkMessage(
      id: (json['id'] ?? '').toString(),
      action: ManagerActions.values[json['action'] ?? 0],
      metadata: json['metadata'] ?? {},
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] ?? '') : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id.isNotEmpty) 'id': id,
    'metadata': metadata,
    'action': action.index,
    if (createdAt != null) 'created_at': createdAt?.toIso8601String(),
  };

  Uint8List get toBytes {
    final jsonString = jsonEncode(toJson());
    return Uint8List.fromList(utf8.encode(jsonString));
  }
}
