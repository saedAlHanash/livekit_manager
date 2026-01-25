class AskBotResponse {
  final String answer;

  AskBotResponse({
    required this.answer,
  });

  factory AskBotResponse.fromJson(Map<String, dynamic> json) {
    return AskBotResponse(
      answer: json["answer"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "answer": answer,
  };
}
