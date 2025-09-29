import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/api_manager/api_url.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/util/pair_class.dart';
import 'package:livekit_manager/features/room/data/request/create_room_request.dart';
import 'package:livekit_manager/features/room/data/response/room_response.dart';
import 'package:http/http.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/error/error_manager.dart';

part 'rooms_state.dart';

class RoomsCubit extends MCubit<RoomsInitial> {
  RoomsCubit() : super(RoomsInitial.initial()) ;

  @override
  String get nameCache => 'rooms';

  @override
  String get filter => state.filter;

  //region getData

  void getDataFromCache() => getFromCache(
  fromJson: Room.fromJson, 
  state: state,   
  onSuccess: (data) {
          emit(state.copyWith(result: data));
        },);

  Future<void> getData({bool newData = false}) async {
    await getDataAbstract(
      fromJson: Room.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<List<Room>?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.post,
      url: PostUrl.rooms,
      body: state.filterRequest?.toJson() ?? {},
    );

    if (response.statusCode.success) {
      return Pair(Rooms.fromJson(response.jsonBody).items, null);
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
      url: PostUrl.createRoom,
      body: state.cRequest.toJson(),
    );

    await _updateState(response);
  }

  Future<void> update() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.update));

    final response = await APIService().callApi(
      type: ApiType.put,
      url: PutUrl.updateRoom,
      query: {'id': state.cRequest.id},
      body: state.cRequest.toJson(),
    );
    await _updateState(response);
  }

  Future<void> delete({required String id}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.delete, id: id));

    final response = await APIService().callApi(
      type: ApiType.delete,
      url: DeleteUrl.deleteRoom,
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
      url: DeleteUrl.deleteRoom,
      query: {'id': state.id.toString()},
    );

    if (response.statusCode.success) {
      await deleteRoomFromCache(item.id);
    } else {
      showErrorFromApi(state);
      state.result.insert(index, item);
      emit(state.copyWith(statuses: CubitStatuses.error, result: state.result));
    }
  }

  Future<void> _updateState(Response response, {bool isDelete = false}) async {
    if (response.statusCode.success) {
      final item = Room.fromJson(response.jsonBody);
      isDelete ? await deleteRoomFromCache(state.id.toString()) : await addOrUpdateRoomToCache(item);
      emit(state.copyWith(statuses: CubitStatuses.done));
    } else {
      emit(state.copyWith(statuses: CubitStatuses.error, error: response.getPairError.second));
      showErrorFromApi(state);
    }
  }

  //endregion

  Future<void> addOrUpdateRoomToCache(Room item) async {
    final listJson = await addOrUpdateDate([item]);
    if (listJson == null) return;
    final list = listJson.map((e) => Room.fromJson(e)).toList();
    emit(state.copyWith(result: list));
  }

  Future<void> deleteRoomFromCache(String id) async {
    final listJson = await deleteDate([id]);
    if (listJson == null) return;
    final list = listJson.map((e) => Room.fromJson(e)).toList();
    emit(state.copyWith(result: list));
  }
}

   