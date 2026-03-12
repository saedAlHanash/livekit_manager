class MessageRequest {
  MessageRequest({
    required this.roomName,
    required this.identities,
    required this.data,
  });

  final String roomName;
  final List<String> identities;
  final String data;

  factory MessageRequest.fromJson(Map<String, dynamic> json) {
    return MessageRequest(
      roomName: json["roomName"] ?? "",
      identities: json["identities"] == null ? [] : List<String>.from(json["identities"]!.map((x) => x)),
      data: json["data"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "roomName": roomName,
        "identities": identities.map((x) => x).toList(),
        "data": data,
      };
}
