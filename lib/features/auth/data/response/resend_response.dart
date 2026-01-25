class ResendResponse {
  ResendResponse({
    required this.success,
    required this.totalSeconds,
    required this.otp,
  });

  final bool success;
  final int totalSeconds;
  final String otp;

  factory ResendResponse.fromJson(Map<String, dynamic> json){
    return ResendResponse(
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
