import '../response/setting_response.dart';

class CreateSettingRequest {
  CreateSettingRequest({
    required this.id,
  });

  final String id;

  factory CreateSettingRequest.fromJson(Map<String, dynamic> json) {
    return CreateSettingRequest(
      id: json["id"] ?? "",
    );
  }

  factory CreateSettingRequest.fromSetting(Setting setting) {
    return CreateSettingRequest(
      id: setting.id.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

