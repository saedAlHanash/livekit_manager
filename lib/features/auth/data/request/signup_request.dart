class SignupRequest {
  SignupRequest({
    this.email,
  });

  String? email;

  factory SignupRequest.fromJson(Map<String, dynamic> json) {
    return SignupRequest(
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'email': email};
}
