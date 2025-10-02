import 'package:lk_assistant/core/api_manager/api_service.dart';
import 'package:lk_assistant/core/api_manager/api_url.dart';
import 'package:lk_assistant/core/extensions/extensions.dart';
import 'package:lk_assistant/core/strings/enum_manager.dart';
import 'package:lk_assistant/core/util/pair_class.dart';
import 'package:lk_assistant/features/setting/data/response/setting_response.dart';
import 'package:m_cubit/abstraction.dart';

part 'setting_state.dart';

class SettingCubit extends MCubit<SettingInitial> {
  SettingCubit() : super(SettingInitial.initial());

  @override
  String get nameCache => 'setting';

  @override
  String get filter => state.filter;

  Future<void> getData({bool newData = false,  String? settingId}) async {
    emit(state.copyWith(request: settingId));

    await getDataAbstract(
      fromJson: Setting.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<Setting?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.setting,
      query: {'Id': state.request},
    );

    if (response.statusCode.success) {
      return Pair(Setting.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }

  void setSetting(dynamic setting) {
    if (setting is! Setting) return;

    emit(state.copyWith(result: setting));
  }
}
 