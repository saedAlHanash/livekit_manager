part of 'lesson_cubit.dart';

class LessonInitial extends AbstractState<Lesson> {
  const LessonInitial({
    required super.result,
    super.error,
    super.request,
    super.filterRequest,
    super.cubitCrud,
    super.createUpdateRequest,
    super.statuses,
    super.id,
  });

  factory LessonInitial.initial() {
    return LessonInitial(
      result: Lesson.fromJson({}),
    );
  }

  @override
  List<Object?> get props => [
    statuses,
    result,
    error,
    cubitCrud,
    id,
    request,
    filterRequest,
    createUpdateRequest,
  ];

  LessonInitial copyWith({
    CubitStatuses? statuses,
    CubitCrud? cubitCrud,
    Lesson? result,
    String? error,
    FilterRequest? filterRequest,
    dynamic request,
    dynamic cRequest,
    dynamic id,
  }) {
    return LessonInitial(
      statuses: statuses ?? this.statuses,
      cubitCrud: cubitCrud ?? this.cubitCrud,
      result: result ?? this.result,
      error: error ?? this.error,
      filterRequest: filterRequest ?? this.filterRequest,
      request: request ?? this.request,
      createUpdateRequest: cRequest ?? this.createUpdateRequest,
      id: id ?? this.id,
    );
  }
}
