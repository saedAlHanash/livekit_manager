import '../response/user_response.dart';

class CreateUserRequest {
  CreateUserRequest({
    required this.id,
  });

  final String id;

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) {
    return CreateUserRequest(
      id: json["id"] ?? "",
    );
  }

  factory CreateUserRequest.fromUser(User user) {
    return CreateUserRequest(
      id: user.id.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

