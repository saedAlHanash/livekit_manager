import 'package:livekit_manager/core/app/app_provider.dart';
import 'package:m_cubit/abstraction.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/api_manager/api_url.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/pair_class.dart';
import '../../../../core/util/shared_preferences.dart';
import '../../data/response/staff_record_response.dart';

part 'staff_details_state.dart';

class StaffDetailsCubit extends MCubit<StaffDetailsInitial> {
  StaffDetailsCubit() : super(StaffDetailsInitial.initial()) {
    getDataFromCache();
  }

  @override
  String get nameCache => 'StaffDetails';

  @override
  get mState => state;

  @override
  String get filter => state.filter;

  void getDataFromCache() => getFromCache(
    fromJson: StaffDetails.fromJson,
    state: state,
    onSuccess: (data) {
      emit(state.copyWith(result: data));
    },
  );

  Future<void> getData({bool newData = false}) async {
    await getDataAbstract(
      fromJson: StaffDetails.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
      onSuccess: (data, emitState) {
        AppProvider.setStaffRecord(data);
        emit(state.copyWith(result: data, statuses: emitState));
      },
    );
  }

  Future<Pair<StaffDetails?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.staffDetails,
      query: {'id': AppSharedPreference.getMyId},
    );

    if (response.statusCode.success) {
      final model = StaffDetails.fromJson(response.jsonBody);
      return Pair(model, null);
    } else {
      return response.getPairError;
    }
  }

  void setStaffDetails(dynamic student) {
    if (student is! StaffDetails) return;

    emit(state.copyWith(result: student));
  }
}
