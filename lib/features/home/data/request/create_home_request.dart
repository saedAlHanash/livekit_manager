import '../response/home_response.dart';

class CreateHomeRequest {
  CreateHomeRequest({
    required this.id,
  });

  final String id;

  factory CreateHomeRequest.fromJson(Map<String, dynamic> json) {
    return CreateHomeRequest(
      id: json["id"] ?? "",
    );
  }

  factory CreateHomeRequest.fromHome(Home home) {
    return CreateHomeRequest(
      id: home.id.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

