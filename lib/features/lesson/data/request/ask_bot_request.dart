class AskBotRequest {
  final String lessonId;
  final String prompt;

  AskBotRequest({
    required this.lessonId,
    required this.prompt,
  });

  Map<String, dynamic> toJson() => {
    "lessonId": lessonId,
    "prompt": prompt,
  };
}
