import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/api_manager/api_url.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/util/pair_class.dart';
import 'package:livekit_manager/features/lesson/data/response/lesson_response.dart';
import 'package:m_cubit/m_cubit.dart';

part 'lesson_state.dart';

class LessonCubit extends MCubit<LessonInitial> {
  LessonCubit() : super(LessonInitial.initial());

  @override
  get mState => state;

  @override
  String get nameCache => 'lesson';

  @override
  String get filter => state.filter;

  Future<void> getData({required String id, bool newData = false}) async {
    await getDataAbstract(
      fromJson: Lesson.fromJson,

      state: state,
      getDataApi: () => _getData(id),
      newData: newData,
    );
  }

  Future<Pair<Lesson?, String?>> _getData(String id) async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: 'GetUrl.lesson',
      hostName: 'ims-be.coretech-mena.com',
      query: {'id': id},
    );

    if (response.statusCode.success) {
      return Pair(Lesson.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }

  void setLesson(dynamic lesson) {
    if (lesson is! Lesson) return;
    emit(state.copyWith(result: lesson));
  }
}
