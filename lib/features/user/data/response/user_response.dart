class User {
  User({
    required this.id,
    required this.name,
    required this.image,
  });

  final String id;
  final String name;
  final String image;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
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
