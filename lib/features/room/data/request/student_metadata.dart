import 'dart:convert';

class StudentMetadata {
  final String userId;
  final bool canDrawing;

  StudentMetadata({
    required this.userId,
    required this.canDrawing,
  });

  factory StudentMetadata.fromJson(Map<String, dynamic> json) {
    return StudentMetadata(
      userId: json['userId'] ?? '',
      canDrawing: json['canDrawing'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'canDrawing': canDrawing,
  };

  static String toMetadataString(String userId, bool canDrawing) {
    return jsonEncode([
      {
        'userId': userId,
        'canDrawing': canDrawing,
      }
    ]);
  }
}
