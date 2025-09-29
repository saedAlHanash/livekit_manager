import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/api_manager/api_url.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/util/pair_class.dart';
import 'package:livekit_manager/features/user/data/response/user_response.dart';
import 'package:m_cubit/abstraction.dart';

part 'user_state.dart';

class UserCubit extends MCubit<UserInitial> {
  UserCubit() : super(UserInitial.initial());

  @override
  String get nameCache => 'user';

  @override
  String get filter => state.filter;

  Future<void> getData({bool newData = false,  String? userId}) async {
    emit(state.copyWith(request: userId));

    await getDataAbstract(
      fromJson: User.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<User?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.user,
      query: {'Id': state.request},
    );

    if (response.statusCode.success) {
      return Pair(User.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }

  void setUser(dynamic user) {
    if (user is! User) return;

    emit(state.copyWith(result: user));
  }
}
 