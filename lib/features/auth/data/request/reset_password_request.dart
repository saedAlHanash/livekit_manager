class ResetPasswordRequest {
  ResetPasswordRequest({
    this.password,
    this.passwordConfirmation,
  });

  String? password;
  String? passwordConfirmation;

  Map<String, dynamic> toJson() => {
        // "phone": AppProvider.getPhoneCached,

        "password": password,
        "password_confirmation": passwordConfirmation,
      };
}
