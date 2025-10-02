import 'package:lk_assistant/core/api_manager/api_service.dart';
import 'package:lk_assistant/core/api_manager/api_url.dart';
import 'package:lk_assistant/core/extensions/extensions.dart';
import 'package:lk_assistant/core/strings/enum_manager.dart';
import 'package:lk_assistant/core/util/pair_class.dart';
import 'package:lk_assistant/features/room/data/response/room_response.dart';
import 'package:m_cubit/abstraction.dart';

part 'room_state.dart';

class RoomCubit extends MCubit<RoomInitial> {
  RoomCubit() : super(RoomInitial.initial());

  @override
  String get nameCache => 'room';

  @override
  String get filter => state.filter;

  Future<void> getData({bool newData = false,  String? roomId}) async {
    emit(state.copyWith(request: roomId));

    await getDataAbstract(
      fromJson: Room.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<Room?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.room,
      query: {'Id': state.request},
    );

    if (response.statusCode.success) {
      return Pair(Room.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }

  void setRoom(dynamic room) {
    if (room is! Room) return;

    emit(state.copyWith(result: room));
  }
}
 