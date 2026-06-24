import 'dart:convert';

class StudentMetadata {
  final bool isWhiteboardAllowed;

  StudentMetadata({
    required this.isWhiteboardAllowed,
  });

  factory StudentMetadata.fromJson(Map<String, dynamic> json) {
    return StudentMetadata(
      isWhiteboardAllowed: json['isWhiteboardAllowed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'isWhiteboardAllowed': isWhiteboardAllowed,
  };

  String get toJsonString => jsonEncode(toJson());

  factory StudentMetadata.fromJsonString(String jsonStr) {
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonStr);
      return StudentMetadata.fromJson(decoded);
    } catch (_) {
      return StudentMetadata(isWhiteboardAllowed: false);
    }
  }
}
