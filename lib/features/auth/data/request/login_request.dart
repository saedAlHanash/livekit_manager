import 'package:m_cubit/m_cubit.dart';

class LoginRequest {
  String? email;
  String? password;
  String? code;

  LoginRequest({
    this.email,
    this.password,
    this.code,
  });

  LoginRequest copyWith({
    String? email,
    String? password,
  }) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceToken': '',

      if (!email.isBlank) 'email': email,
      if (!password.isBlank) 'password': password,
      if (!code.isBlank) 'otp': code,
    };
  }
}
