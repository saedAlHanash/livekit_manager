import 'package:lk_assistant/core/api_manager/api_service.dart';
import 'package:lk_assistant/core/api_manager/api_url.dart';
import 'package:lk_assistant/core/extensions/extensions.dart';
import 'package:lk_assistant/core/strings/enum_manager.dart';
import 'package:lk_assistant/core/util/pair_class.dart';
import 'package:lk_assistant/features/home/data/response/home_response.dart';
import 'package:m_cubit/abstraction.dart';

part 'home_state.dart';

class HomeCubit extends MCubit<HomeInitial> {
  HomeCubit() : super(HomeInitial.initial());

  @override
  String get nameCache => 'home';

  @override
  String get filter => state.filter;

  Future<void> getData({bool newData = false,  String? homeId}) async {
    emit(state.copyWith(request: homeId));

    await getDataAbstract(
      fromJson: Home.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<Home?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.home,
      query: {'Id': state.request},
    );

    if (response.statusCode.success) {
      return Pair(Home.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }

  void setHome(dynamic home) {
    if (home is! Home) return;

    emit(state.copyWith(result: home));
  }
}
 