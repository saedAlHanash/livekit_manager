// import 'dart:typed_data';
//
// import '../../core/strings/enum_manager.dart';
//
// class SignalRecord {
//   SignalRecord({
//     required this.content,
//     required this.desktop,
//     required this.recipient,
//     required this.type,
//   });
//
//   final dynamic content;
//   dynamic desktop;
//   final String recipient;
//   ScreenShowType type;
//
//   dynamic get getStream => type == ScreenShowType.student ? content : desktop;
//
//   factory SignalRecord.fromJson(Map<String, dynamic> json) {
//     return SignalRecord(
//       content: (json["content"] is String)
//           ? json["content"] ?? ''
//           : Uint8List.fromList(((json["content"] ?? []) as List<dynamic>).cast<int>()),
//       desktop: (json["desktop"] is String)
//           ? json["desktop"] ?? ''
//           : Uint8List.fromList(((json["desktop"] ?? []) as List<dynamic>).cast<int>()),
//       recipient: json["recipient"] ?? "",
//       type: ScreenShowType.values[json["type"] ?? 0],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//         "content": content,
//         "desktop": desktop,
//         "recipient": recipient,
//         "type": type.index,
//       };
// }
//
// class SignalStudent {
//   SignalStudent({
//     required this.message,
//     required this.id,
//     required this.connectionId,
//   });
//
//   final SignalRecord message;
//   final String id;
//   final String connectionId;
//
//   bool isAdmitted(List<String> list) => list.contains(id);
//
//   factory SignalStudent.fromJson(Map<String, dynamic> json) {
//     {
//       return SignalStudent(
//         message: SignalRecord.fromJson(json["message"] ?? {}),
//         id: json["id"] ?? "",
//         connectionId: json["connectionId"] ?? "",
//       );
//     }
//   }
//
//   @override
//   String toString() {
//     return 'id:$id\n connectionId:$connectionId';
//   }
// }
