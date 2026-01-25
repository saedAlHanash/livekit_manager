import '../../core/strings/enum_manager.dart';

class SignalMessage {
  SignalMessage({
    this.message = '',
    required this.type,
  });

  final String message;
  final SignalMessageType type;

  factory SignalMessage.fromJson(Map<String, dynamic> json) {
    return SignalMessage(
      message: json["message"] ?? "",
      type: SignalMessageType.values[json["type"] ?? 0],
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "type": type.index,
      };
}
