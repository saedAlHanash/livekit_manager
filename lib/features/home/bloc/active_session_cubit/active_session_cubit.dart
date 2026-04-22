import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/api_manager/api_url.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/util/pair_class.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../data/response/active_session_response.dart';

part 'active_session_state.dart';

class ActiveSessionCubit extends MCubit<ActiveSessionInitial> {
  ActiveSessionCubit() : super(ActiveSessionInitial.initial());

  @override
  get mState => state;

  @override
  String get nameCache => 'active_session';

  @override
  String get filter => state.filter;

  Future<void> getData({required String staffId, bool newData = true}) async {
    await getDataAbstract(
      fromJson: ActiveSessionResponse.fromJson,
      state: state,
      getDataApi: () => _getData(staffId),
      newData: newData,
    );
  }

  Future<Pair<ActiveSessionResponse?, String?>> _getData(String staffId) async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: 'Lesson/GetTeacherActiveSessions',

      hostName: 'ims.moed.gov.sy',
      query: {'StaffRecordId': staffId},
    );

    if (response.statusCode.success) {
      return Pair(ActiveSessionResponse.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }
}
