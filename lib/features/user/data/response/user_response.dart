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

  Map<String, dynamic> toJson() {
    return {
      'items': items,
    };
  }

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      items: json['items'] as List<User>,
    );
  }
}
