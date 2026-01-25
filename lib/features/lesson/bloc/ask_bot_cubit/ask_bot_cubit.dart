import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/api_manager/api_url.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/util/pair_class.dart';
import 'package:livekit_manager/features/lesson/data/request/ask_bot_request.dart';
import 'package:livekit_manager/features/lesson/data/response/ask_bot_response.dart';
import 'package:m_cubit/m_cubit.dart';

part 'ask_bot_state.dart';

class AskBotCubit extends MCubit<AskBotInitial> {
  AskBotCubit() : super(AskBotInitial.initial());

  @override
  get mState => state;

  Future<void> askBot({required String lessonId, required String prompt}) async {
    await getDataAbstract(
      fromJson: AskBotResponse.fromJson,
      state: state,
      getDataApi: () => _askBot(lessonId, prompt),
      newData: true,
    );
  }

  Future<Pair<AskBotResponse?, String?>> _askBot(String lessonId, String prompt) async {
    final response = await APIService().callApi(
      type: ApiType.post,
      url: 'PostUrl.askBot',
      body: AskBotRequest(lessonId: lessonId, prompt: prompt).toJson(),
    );

    if (response.statusCode.success) {
      return Pair(AskBotResponse.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }
}
