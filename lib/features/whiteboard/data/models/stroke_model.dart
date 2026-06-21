class StrokePointModel {
  final double x;
  final double y;
  final int t;

  StrokePointModel({
    required this.x,
    required this.y,
    required this.t,
  });

  factory StrokePointModel.fromJson(Map<String, dynamic> json) {
    return StrokePointModel(
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
      t: json['t'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        't': t,
      };
}

class StrokeModel {
  final String strokeId;
  final String ownerId;
  final String color;
  final List<StrokePointModel> points;
  final String style;
  final int createdAt;
  final String status;

  StrokeModel({
    required this.strokeId,
    required this.ownerId,
    required this.color,
    required this.points,
    required this.style,
    required this.createdAt,
    required this.status,
  });

  factory StrokeModel.fromJson(Map<String, dynamic> json) {
    int parsedCreatedAt = 0;
    if (json['createdAt'] != null) {
      if (json['createdAt'] is int) {
        parsedCreatedAt = json['createdAt'] as int;
      }
    }
    return StrokeModel(
      strokeId: json['strokeId'] ?? '',
      ownerId: json['ownerId'] ?? '',
      color: json['color'] ?? '',
      points: (json['points'] as List? ?? [])
          .map((e) => StrokePointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      style: json['style'] ?? 'pen',
      createdAt: parsedCreatedAt,
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() => {
        'strokeId': strokeId,
        'ownerId': ownerId,
        'color': color,
        'points': points.map((e) => e.toJson()).toList(),
        'style': style,
        'createdAt': createdAt,
        'status': status,
      };
}
