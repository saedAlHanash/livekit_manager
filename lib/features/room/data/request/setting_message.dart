import 'dart:convert';
import 'dart:typed_data';

import '../../../../core/strings/enum_manager.dart';

class LkMessage {
  LkMessage({
    this.id = '',
    required this.action,
    required this.metadata,
  });

  final String id;
  final ManagerActions action;
  final Map<String, dynamic> metadata;

  String get name => metadata['name'] ?? '';

  String get message => metadata['message'] ?? '';

  String get image => metadata['image'] ?? '';

  String get userId => metadata['id'] ?? '';

  factory LkMessage.fromJson(Map<String, dynamic> json) {
    return LkMessage(
      id: (json['id'] ?? '').toString(),
      action: ManagerActions.values[json['action'] ?? 0],
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id.isNotEmpty ? id : DateTime.now().millisecondsSinceEpoch.toString(),
    'metadata': metadata,
    'action': action.index,
  };

  Uint8List get toBytes {
    final jsonString = jsonEncode(toJson());
    return Uint8List.fromList(utf8.encode(jsonString));
  }
}
