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
      id: (json["id"] ?? "").toString(),
      name: json["name"] ?? "",
      image: json["profile_image_url"] ?? json["image"] ?? "",
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

  factory Users.fromJson(dynamic json) {
    List list = [];
    if (json is Map<String, dynamic>) {
      list = json["data"] ?? json["items"] ?? [];
    } else if (json is List) {
      list = json;
    }
    return Users(
      items: list.map((x) => User.fromJson(x as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "items": items.map((x) => x.toJson()).toList(),
  };
}
