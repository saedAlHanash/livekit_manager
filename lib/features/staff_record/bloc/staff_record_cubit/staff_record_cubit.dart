import 'package:m_cubit/abstraction.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/api_manager/api_url.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/pair_class.dart';
import '../../data/response/staff_record_response.dart';

part 'staff_record_state.dart';

class StaffRecordCubit extends MCubit<StaffRecordInitial> {
  StaffRecordCubit() : super(StaffRecordInitial.initial());

  @override
  get mState => state;
  @override
  String get nameCache => 'staffRecord';

  @override
  String get filter => state.filter;

  Future<void> getData({bool newData = false, String? studentRecordId}) async {
    emit(state.copyWith(request: studentRecordId));

    await getDataAbstract(
      fromJson: StaffRecord.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<StaffRecord?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.staffRecord,
      hostName: 'ims-be.coretech-mena.com',
      query: {'Id': state.request},
    );

    if (response.statusCode.success) {
      return Pair(StaffRecord.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }

  void setStaffRecord(dynamic staffRecord) {
    if (staffRecord is! StaffRecord) return;

    emit(state.copyWith(result: staffRecord));
  }
}
