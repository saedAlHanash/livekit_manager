class CreatePasswordRequest {
  String? rePassword;
  String? password;

  CreatePasswordRequest({
    this.rePassword,
    this.password,
  });

  CreatePasswordRequest copyWith({
    String? rePassword,
    String? password,
  }) {
    return CreatePasswordRequest(
      rePassword: rePassword ?? this.rePassword,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      // 'email': AppProvider.getCachedEmail,
    };
  }
}
