class User {
  User({
    required this.id,
    required this.studentName,
    required this.studentImage,
    required this.studentRecordId,
  });

  final String id;
  final String studentName;
  final String studentImage;
  final String studentRecordId;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["studentRecordId"] ?? "",
      studentName: json["studentName"] ?? "",
      studentImage: json["studentImage"] ?? "",
      studentRecordId: json["studentRecordId"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "studentName": studentName,
    "studentImage": studentImage,
    "studentRecordId": studentRecordId,
  };
}

class Users {
  final List<User> items;

  const Users({
    required this.items,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      items: json["items"] == null ? [] : List<User>.from(json["items"]!.map((x) => User.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "items": items.map((x) => x.toJson()).toList(),
  };
}
