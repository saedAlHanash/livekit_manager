import 'package:livekit_manager/core/extensions/extensions.dart';

import '../../../../core/strings/enum_manager.dart';

class LoginResponse {
  LoginResponse({
    required this.user,
    required this.token,
    required this.userType,
  });

  final User user;
  final String token;
  final UserType userType;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json["user"] ?? {}),
      token: json["token"] ?? "",
      userType: UserType.getByNameOrIndex(json["userModelType"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
        "userModelType": userType.index,
      };
}

class User {
  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.phoneNumber,
    required this.phoneNumberCode,
    required this.isActive,
    required this.fullName,
    required this.roles,
    required this.id,
  });

  final String email;
  final String firstName;
  final String lastName;
  final String imageUrl;
  final String phoneNumber;
  final String phoneNumberCode;
  final bool isActive;
  final String fullName;
  final List<dynamic> roles;
  final String id;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json["email"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      phoneNumber: (json["phoneNumber"] ?? "").toString().fixImageAvatar,
      phoneNumberCode: json["phoneNumberCode"] ?? "",
      isActive: json["isActive"] ?? false,
      fullName: json["fullName"] ?? "",
      roles: json["roles"] == null ? [] : List<dynamic>.from(json["roles"]!.map((x) => x)),
      id: json["id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "imageUrl": imageUrl,
        "phoneNumber": phoneNumber,
        "phoneNumberCode": phoneNumberCode,
        "isActive": isActive,
        "fullName": fullName,
        "roles": roles.map((x) => x).toList(),
        "id": id,
      };
}
