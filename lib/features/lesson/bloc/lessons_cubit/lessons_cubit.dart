import 'package:http/http.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/api_manager/api_url.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/util/pair_class.dart';
import 'package:livekit_manager/features/lesson/data/request/create_lesson_request.dart';
import 'package:livekit_manager/features/lesson/data/response/lesson_response.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/error/error_manager.dart';

part 'lessons_state.dart';

class LessonsCubit extends MCubit<LessonsInitial> {
  LessonsCubit() : super(LessonsInitial.initial());

  @override
  get mState => state;

  @override
  String get nameCache => 'lessons';

  @override
  String get filter => state.filter;

  //region getData

  void getDataFromCache() => getFromCache(
    fromJson: Lesson.fromJson,
    state: state,
    onSuccess: (data) {
      emit(state.copyWith(result: data));
    },
  );

  Future<void> getData({bool newData = false}) async {
    await getDataAbstract(
      fromJson: Lesson.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<List<Lesson>?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.post,
      url: 'PostUrl.lessons',
      body: state.filterRequest?.toJson() ?? {},
    );

    if (response.statusCode.success) {
      final json = response.jsonBody;
      return Pair(Lessons.fromJson(json).items, null);
    } else {
      return response.getPairError;
    }
  }

  //endregion

  //region CRUD
  Future<void> create() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.create));

    final response = await APIService().callApi(
      type: ApiType.post,
      url: 'PostUrl.createLesson',
      body: state.cRequest.toJson(),
    );

    await _updateState(response);
  }

  Future<void> update() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.update));

    final response = await APIService().callApi(
      type: ApiType.put,
      url: 'PutUrl.updateLesson',
      query: {'id': state.cRequest.id},
      body: state.cRequest.toJson(),
    );
    await _updateState(response);
  }

  Future<void> delete({required String id}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.delete, id: id));

    final response = await APIService().callApi(
      type: ApiType.delete,
      url: 'DeleteUrl.deleteLesson',
      query: {'id': id},
    );

    await _updateState(response, isDelete: true);
  }

  Future<void> _updateState(Response response, {bool isDelete = false}) async {
    if (response.statusCode.success) {
      final item = isDelete ? null : Lesson.fromJson(response.jsonBody);
      isDelete ? await deleteLessonFromCache(state.id.toString()) : await addOrUpdateLessonToCache(item!);
      emit(state.copyWith(statuses: CubitStatuses.done));
    } else {
      emit(state.copyWith(statuses: CubitStatuses.error, error: response.getPairError.second));
      showErrorFromApi(state);
    }
  }

  //endregion

  Future<void> addOrUpdateLessonToCache(Lesson item) async {
    final listJson = await addOrUpdateDate([item]);
    if (listJson == null) return;
    final list = listJson.map((e) => Lesson.fromJson(e)).toList();
    emit(state.copyWith(result: list));
  }

  Future<void> deleteLessonFromCache(String id) async {
    final listJson = await deleteDate([id]);
    if (listJson == null) return;
    final list = listJson.map((e) => Lesson.fromJson(e)).toList();
    emit(state.copyWith(result: list));
  }
}
