import 'package:http/http.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/api_manager/api_url.dart';
import '../../../../core/error/error_manager.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/pair_class.dart';
import '../../data/request/create_staff_record_request.dart';
import '../../data/response/staff_record_response.dart';

part 'staff_records_state.dart';

class StaffRecordsCubit extends MCubit<StaffRecordsInitial> {
  StaffRecordsCubit() : super(StaffRecordsInitial.initial());

  @override
  get mState => state;
  @override
  String get nameCache => 'staffRecords';

  @override
  String get filter => state.filter;

  //region getData

  void getDataFromCache() => getFromCache(
    fromJson: StaffRecord.fromJson,
    state: state,
    onSuccess: (data) {
      emit(state.copyWith(result: data));
    },
  );

  Future<void> getData({bool newData = false}) async {
    await getDataAbstract(
      fromJson: StaffRecord.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<List<StaffRecord>?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.post,
      url: PostUrl.staffRecords,
      body: state.filterRequest?.toJson() ?? {},
    );

    if (response.statusCode.success) {
      return Pair(StaffRecords.fromJson(response.jsonBody).items, null);
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
      url: PostUrl.createStaffRecord,
      body: state.cRequest.toJson(),
    );

    await _updateState(response);
  }

  Future<void> update() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.update));

    final response = await APIService().callApi(
      type: ApiType.put,
      url: PutUrl.updateStaffRecord,
      query: {'id': state.cRequest.id},
      body: state.cRequest.toJson(),
    );
    await _updateState(response);
  }

  Future<void> delete({required String id}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.delete, id: id));

    final response = await APIService().callApi(
      type: ApiType.delete,
      url: 'DeleteUrl.deleteStaffRecord',
      query: {'id': state.id.toString()},
    );

    await _updateState(response, isDelete: true);
  }

  Future<void> deleteNow({required String id}) async {
    final index = state.result.indexWhere((element) => element.id.toString() == id);
    final item = state.result.removeAt(index);

    emit(state.copyWith(cubitCrud: CubitCrud.delete, result: state.result, id: id));

    final response = await APIService().callApi(
      type: ApiType.delete,
      url: 'DeleteUrl.deleteStaffRecord',
      query: {'id': state.id.toString()},
    );

    if (response.statusCode.success) {
      await deleteStaffRecordFromCache(item.id);
    } else {
      showErrorFromApi(state);
      state.result.insert(index, item);
      emit(state.copyWith(statuses: CubitStatuses.error, result: state.result));
    }
  }

  Future<void> _updateState(Response response, {bool isDelete = false}) async {
    if (response.statusCode.success) {
      final item = StaffRecord.fromJson(response.jsonBody);
      isDelete ? await deleteStaffRecordFromCache(state.id.toString()) : await addOrUpdateStaffRecordToCache(item);
      emit(state.copyWith(statuses: CubitStatuses.done));
    } else {
      emit(state.copyWith(statuses: CubitStatuses.error, error: response.getPairError.second));
      showErrorFromApi(state);
    }
  }

  //endregion

  Future<void> addOrUpdateStaffRecordToCache(StaffRecord item) async {
    final listJson = await addOrUpdateDate([item]);
    if (listJson == null) return;
    final list = listJson.map((e) => StaffRecord.fromJson(e)).toList();
    emit(state.copyWith(result: list));
  }

  Future<void> deleteStaffRecordFromCache(String id) async {
    final listJson = await deleteDate([id]);
    if (listJson == null) return;
    final list = listJson.map((e) => StaffRecord.fromJson(e)).toList();
    emit(state.copyWith(result: list));
  }
}
