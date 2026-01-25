import 'package:livekit_manager/core/api_manager/api_url.dart';
import 'package:livekit_manager/core/app/app_provider.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/util/shared_preferences.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/pair_class.dart';
import '../../data/response/login_response.dart';

part 'logged_user_state.dart';

class LoggedUserCubit extends MCubit<LoggedUserInitial> {
  LoggedUserCubit() : super(LoggedUserInitial.initial());

  @override
  get mState => state;
  @override
  String get nameCache => 'loggedUser';

  @override
  String get filter => AppSharedPreference.getMyId.toString();

  Future<void> getData({bool newData = false}) async {
    if (AppProvider.isNotLogin) return;

    await getDataAbstract(
      fromJson: User.fromJson,
      state: state,
      getDataApi: _getDataApi,
      newData: newData,
    );
  }

  Future<Pair<User?, String?>> _getDataApi() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.loggedUser,
    );

    if (response.statusCode.success) {
      final user = User.fromJson(response.jsonBody);
      await AppProvider.setUser(user);
      return Pair(user, null);
    } else {
      return response.getPairError;
    }
  }

  void setLoggedUser(User? loggedUser) {
    if (loggedUser == null) return;
    emit(state.copyWith(result: loggedUser));
  }
}
