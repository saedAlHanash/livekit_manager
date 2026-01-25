class CreateLessonRequest {
  CreateLessonRequest({
    this.id,
    required this.title,
    this.sequence = 0,
    this.lessonStatus = 0,
    this.courseId,
    this.groupTermId,
    this.staffId,
  });

  final String? id;
  final String title;
  final int sequence;
  final int lessonStatus;
  final String? courseId;
  final String? groupTermId;
  final String? staffId;

  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    "title": title,
    "sequence": sequence,
    "lessonStatus": lessonStatus,
    "courseId": courseId,
    "groupTermId": groupTermId,
    "staffId": staffId,
  };

  factory CreateLessonRequest.initial() => CreateLessonRequest(title: '');

  CreateLessonRequest copyWith({
    String? id,
    String? title,
    int? sequence,
    int? lessonStatus,
    String? courseId,
    String? groupTermId,
    String? staffId,
  }) {
    return CreateLessonRequest(
      id: id ?? this.id,
      title: title ?? this.title,
      sequence: sequence ?? this.sequence,
      lessonStatus: lessonStatus ?? this.lessonStatus,
      courseId: courseId ?? this.courseId,
      groupTermId: groupTermId ?? this.groupTermId,
      staffId: staffId ?? this.staffId,
    );
  }
}
