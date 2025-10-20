import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/app/app_widget.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
import 'package:m_cubit/abstraction.dart';

import '../../data/request/change_track_request.dart';
import '../../data/request/update_participant_request.dart';

part 'user_control_state.dart';

class UserControlCubit extends MCubit<UserControlInitial> {
  UserControlCubit() : super(UserControlInitial.initial());

  Future<void> suspend(String userId) async {
    emit(
      state.copyWith(
        statuses: CubitStatuses.loading,
        updateRequest: UpdateParticipantRequest(
          identity: userId,
          permission: Permission(canPublish: false, canPublishData: false, canSubscribe: false),
        ),
      ),
    );
    _apiUpdateParticipant(userId);
  }

  Future<void> resume(String userId) async {
    emit(
      state.copyWith(
        statuses: CubitStatuses.loading,
        updateRequest: UpdateParticipantRequest(identity: userId, permission: Permission()),
      ),
    );
    _apiUpdateParticipant(userId);
  }

  Future<void> _apiUpdateParticipant(String userId) async {
    final result = await APIService().callApi(
      url: 'UpdateParticipant',
      type: ApiType.post,
      body: state.updateRequest.toJson(),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> muteUser(String userId) async {
    emit(
      state.copyWith(
        statuses: CubitStatuses.loading,
        updateRequest: UpdateParticipantRequest(
          identity: userId,
          permission: Permission(canPublish: false, canPublishData: false, canSubscribe: true),
        ),
      ),
    );
    _apiUpdateParticipant(userId);
  }

  Future<void> suspendUser() async {
    emit(state.copyWith(statuses: CubitStatuses.loading));
    final result = await APIService().callApi(
      url: 'MutePublishedTrack',
      type: ApiType.post,
      body: state.mRequest.toJson(),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> disconnect(String userId) async {
    emit(state.copyWith(statuses: CubitStatuses.loading));
    final result = await APIService().callApi(
      url: 'RemoveParticipant',
      type: ApiType.post,
      body: {"room": ctx!.read<RoomCubit>().state.result.name, "identity": userId},
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  void reActiveMiceButton() {}
}
