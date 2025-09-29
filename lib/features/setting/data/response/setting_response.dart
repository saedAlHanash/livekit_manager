class Setting {
  Setting({
    required this.id,
  });

  final String id;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
    };
  }

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      id: json["id"] ?? "",
    );
  }

}

class Settings {
  final List<Setting> items;

  const Settings({
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      items: json['items'] as List<Setting>,
    );
  }
}

