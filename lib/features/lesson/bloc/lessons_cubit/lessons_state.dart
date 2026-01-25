part of 'lessons_cubit.dart';

class LessonsInitial extends AbstractState<List<Lesson>> {
  const LessonsInitial({
    required super.result,
    super.error,
    super.request,
    super.filterRequest,
    super.cubitCrud,
    super.createUpdateRequest,
    super.statuses,
    super.id,
  });

  factory LessonsInitial.initial() {
    return LessonsInitial(
      result: [],
      createUpdateRequest: CreateLessonRequest.initial(),
    );
  }

  CreateLessonRequest get cRequest => createUpdateRequest;

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

  LessonsInitial copyWith({
    CubitStatuses? statuses,
    CubitCrud? cubitCrud,
    List<Lesson>? result,
    String? error,
    FilterRequest? filterRequest,
    dynamic request,
    dynamic cRequest,
    dynamic id,
  }) {
    return LessonsInitial(
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
