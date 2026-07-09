import 'package:m_cubit/util.dart';

import '../../../../core/strings/enum_manager.dart';

class RoomMeta {
  RoomMeta({
    required this.type,
  });

  final RoomType type;

  factory RoomMeta.fromJson(Map<String, dynamic> json) {
    return RoomMeta(
      type: RoomType.values[(json["type"] ?? 0).toString().tryParseOrZeroInt],
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type.index,
  };
}
