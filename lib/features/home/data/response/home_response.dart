class Home {
  Home({
    required this.id,
  });

  final String id;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
    };
  }

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      id: json["id"] ?? "",
    );
  }

}

class Homes {
  final List<Home> items;

  const Homes({
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items,
    };
  }

  factory Homes.fromJson(Map<String, dynamic> json) {
    return Homes(
      items: json['items'] as List<Home>,
    );
  }
}

