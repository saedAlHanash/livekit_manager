import 'package:http/http.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/api_manager/api_url.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/util/pair_class.dart';
import 'package:livekit_manager/features/user/data/request/create_user_request.dart';
import 'package:livekit_manager/features/user/data/response/user_response.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/error/error_manager.dart';

part 'users_state.dart';

class UsersCubit extends MCubit<UsersInitial> {
  UsersCubit() : super(UsersInitial.initial());

  @override
  String get nameCache => 'users';

  @override
  String get filter => state.filter;

  //region getData

  void getDataFromCache() => getFromCache(
        fromJson: User.fromJson,
        state: state,
        onSuccess: (data) {
          emit(state.copyWith(result: data));
        },
      );

  Future<void> getData({bool newData = false}) async {
    await getDataAbstract(
      fromJson: User.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<List<User>?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.post,
      url: PostUrl.users,
      body: state.filterRequest?.toJson() ?? {},
    );

    if (response.statusCode.success) {
      return Pair(Users.fromJson(response.jsonBody).items, null);
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
      url: PostUrl.createUser,
      body: state.cRequest.toJson(),
    );

    await _updateState(response);
  }

  Future<void> update() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.update));

    final response = await APIService().callApi(
      type: ApiType.put,
      url: PutUrl.updateUser,
      query: {'id': state.cRequest.id},
      body: state.cRequest.toJson(),
    );
    await _updateState(response);
  }

  Future<void> delete({required String id}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.delete, id: id));

    final response = await APIService().callApi(
      type: ApiType.delete,
      url: DeleteUrl.deleteUser,
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
      url: DeleteUrl.deleteUser,
      query: {'id': state.id.toString()},
    );

    if (response.statusCode.success) {
      await deleteUserFromCache(item.id);
    } else {
      showErrorFromApi(state);
      state.result.insert(index, item);
      emit(state.copyWith(statuses: CubitStatuses.error, result: state.result));
    }
  }

  Future<void> _updateState(Response response, {bool isDelete = false}) async {
    if (response.statusCode.success) {
      final item = User.fromJson(response.jsonBody);
      isDelete ? await deleteUserFromCache(state.id.toString()) : await addOrUpdateUserToCache(item);
      emit(state.copyWith(statuses: CubitStatuses.done));
    } else {
      emit(state.copyWith(statuses: CubitStatuses.error, error: response.getPairError.second));
      showErrorFromApi(state);
    }
  }

  //endregion

  Future<void> addOrUpdateUserToCache(User item) async {
    final listJson = await addOrUpdateDate([item]);
    if (listJson == null) return;
    final list = listJson.map((e) => User.fromJson(e)).toList();
    emit(state.copyWith(result: list));
  }

  Future<void> deleteUserFromCache(String id) async {
    final listJson = await deleteDate([id]);
    if (listJson == null) return;
    final list = listJson.map((e) => User.fromJson(e)).toList();
    emit(state.copyWith(result: list));
  }
}
