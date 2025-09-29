class User {
  User({
    required this.id,
  });

  final String id;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? "",
    );
  }

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

