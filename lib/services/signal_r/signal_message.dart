import 'dart:typed_data';
import 'package:livekit_manager/core/strings/enum_manager.dart';

class SignalMessage {
  SignalMessage({
    required this.event,
    required this.data,
    this.rawBytes,
  });

  final SocketEvents? event;
  final Data data;
  final Uint8List? rawBytes;

  factory SignalMessage.fromJson(Map<String, dynamic> json) {
    return SignalMessage(
      event: json["event"] == null ? null : SocketEvents.values[json["event"]],
      data: Data.fromJson(json["data"] ?? {}),
    );
  }

  factory SignalMessage.fromBytes(Uint8List bytes) {
    return SignalMessage(
      event: SocketEvents.whiteboardAction,
      data: Data(
        // quizId: '',
        groupId: '',
        name: 'whiteboard',
        image: '',
        tokens: [],
      ),
      rawBytes: bytes,
    );
  }

  Map<String, dynamic> toJson() => {
    "event": event?.index,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    // required this.quizId,
    required this.groupId,
    required this.tokens,
    required this.name,
    required this.image,
  });

  // final String quizId;
  final String groupId;
  final String name;
  final String image;
  final List<Token> tokens;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      // quizId: json["quizId"] ?? "",
      groupId: json["groupId"] ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      tokens: json["tokens"] == null ? [] : List<Token>.from(json["tokens"]!.map((x) => Token.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    // if (quizId.isNotEmpty) "quizId": quizId,
    if (groupId.isNotEmpty) "groupId": groupId,
    if (name.isNotEmpty) "name": name,
    if (image.isNotEmpty) "image": image,
    if (tokens.isNotEmpty) "tokens": tokens.map((x) => x.toJson()).toList(),
  };
}

class Token {
  Token({
    required this.studentRecordId,
    required this.token,
    required this.link,
    required this.isResponsible,
  });

  final String studentRecordId;
  final String token;
  final String link;
  final bool isResponsible;

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      studentRecordId: json["studentRecordId"] ?? "",
      token: json["token"] ?? "",
      link: json["link"] ?? json["url"] ?? "",
      isResponsible: json["isResponsible"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "studentRecordId": studentRecordId,
    "token": token,
    "link": link,
    "isResponsible": isResponsible,
  };
}
