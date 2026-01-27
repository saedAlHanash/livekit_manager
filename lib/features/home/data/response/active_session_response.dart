class ActiveSessionResponse {
  ActiveSessionResponse({
    required this.lessonId,
    required this.lessonTitle,
    required this.onlineLessonUrl,
    required this.onlineLessonToken,
  });

  final String lessonId;
  final String lessonTitle;
  final String onlineLessonUrl;
  final String onlineLessonToken;

  factory ActiveSessionResponse.fromJson(Map<String, dynamic> json) {
    return ActiveSessionResponse(
      lessonId: json["lessonId"] ?? "",
      lessonTitle: json["lessonTitle"] ?? "",
      onlineLessonUrl: json["onlineLessonUrl"] ?? "",
      onlineLessonToken: json["onlineLessonToken"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "lessonId": lessonId,
    "lessonTitle": lessonTitle,
    "onlineLessonUrl": onlineLessonUrl,
    "onlineLessonToken": onlineLessonToken,
  };
}
