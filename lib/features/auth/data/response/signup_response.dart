class SignupResponse {
  SignupResponse({
    required this.success,
    required this.totalSeconds,
    required this.otp,
  });

  final bool success;
  final num totalSeconds;
  final String otp;

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: json["success"] ?? false,
      totalSeconds: json["totalSeconds"] ?? 0,
      otp: json["otp"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "totalSeconds": totalSeconds,
        "otp": otp,
      };
}
