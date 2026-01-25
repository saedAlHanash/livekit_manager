class Lessons {
  Lessons({
    required this.items,
  });

  final List<Lesson> items;

  factory Lessons.fromJson(Map<String, dynamic> json) {
    return Lessons(
      items: json["items"] == null ? [] : List<Lesson>.from(json["items"]!.map((x) => Lesson.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "items": items.map((x) => x.toJson()).toList(),
  };
}

class Lesson {
  Lesson({
    required this.id,
    required this.sequence,
    required this.title,
    required this.isPublished,
    required this.lessonStatus,
    required this.courseId,
    required this.courseName,
    required this.groupTermId,
    required this.groupTermName,
    required this.staffRecordId,
    required this.onlineLessonUrl,
    required this.onlineLessonManagerToken,
    required this.onlineLessonShareToken,
    required this.onlineLessonCode,
  });

  final String id;
  final int sequence;
  final String title;
  final bool isPublished;
  final int lessonStatus;
  final String courseId;
  final String courseName;
  final String groupTermId;
  final String groupTermName;
  final String staffRecordId;
  final String onlineLessonUrl;
  final String onlineLessonManagerToken;
  final String onlineLessonShareToken;
  final String onlineLessonCode;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json["id"] ?? "",
      sequence: json["sequence"] ?? 0,
      title: json["title"] ?? "",
      isPublished: json["isPublished"] ?? false,
      lessonStatus: json["lessonStatus"] ?? 0,
      courseId: json["courseId"] ?? "",
      courseName: json["courseName"] ?? "",
      groupTermId: json["groupTermId"] ?? "",
      groupTermName: json["groupTermName"] ?? "",
      staffRecordId: json["staffRecordId"] ?? "",
      onlineLessonUrl: json["onlineLessonUrl"] ?? "",
      onlineLessonManagerToken: json["onlineLessonManagerToken"] ?? "",
      onlineLessonShareToken: json["onlineLessonShareToken"] ?? "",
      onlineLessonCode: json["onlineLessonCode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "sequence": sequence,
    "title": title,
    "isPublished": isPublished,
    "lessonStatus": lessonStatus,
    "courseId": courseId,
    "courseName": courseName,
    "groupTermId": groupTermId,
    "groupTermName": groupTermName,
    "staffRecordId": staffRecordId,
    "onlineLessonUrl": onlineLessonUrl,
    "onlineLessonManagerToken": onlineLessonManagerToken,
    "onlineLessonShareToken": onlineLessonShareToken,
    "onlineLessonCode": onlineLessonCode,
  };
}
