import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/api_manager/api_url.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:m_cubit/abstraction.dart';

import '../../data/request/change_track_request.dart';
import '../../data/request/message_request.dart';
import '../../data/request/update_participant_request.dart';

part 'user_control_state.dart';

class UserControlCubit extends MCubit<UserControlInitial> {
  UserControlCubit() : super(UserControlInitial.initial());

  Future<void> suspend(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.suspend,
      type: ApiType.post,
      body: state.updateRequest.toJson()..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> resume(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.resume,
      type: ApiType.post,
      body: state.updateRequest.toJson()..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> suspendAll() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: ''));
    final result = await APIService().callApi(
      url: PostUrl.suspendAll,
      type: ApiType.post,
      body: state.updateRequest.toJson(),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> resumeAll() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: ''));
    final result = await APIService().callApi(
      url: PostUrl.resumeAll,
      type: ApiType.post,
      body: state.updateRequest.toJson(),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> allowScreenShare(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.allowScreenShare,
      type: ApiType.post,
      body: state.updateRequest.toJson()..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> stopScreenShare(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.stopScreenShare,
      type: ApiType.post,
      body: state.updateRequest.toJson()..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> allowCamera(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.allowCamera,
      type: ApiType.post,
      body: state.updateRequest.toJson()..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> stopCamera(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.stopCamera,
      type: ApiType.post,
      body: state.updateRequest.toJson()..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> allowToSpeak(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.allowAudio,
      type: ApiType.post,
      body: state.updateRequest.toJson()..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> mute(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.stopAudio,
      type: ApiType.post,
      body: state.updateRequest.toJson()..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> revoke(Participant participant, PermissionType type) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: 'Index/UpdateParticipant',
      type: ApiType.post,
      body: state.updateRequest.toJson()
        ..addAll(
          type.revokePermissions(participant),
        ),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> grant(Participant participant, PermissionType type) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: 'Index/UpdateParticipant',
      type: ApiType.post,
      body: state.updateRequest.toJson()
        ..addAll(
          type.grantPermissions(participant),
        ),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> kick(String participant, {bool block = false}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.kick,
      type: ApiType.post,
      body: state.updateRequest.toJson()
        ..addAll(
          {
            'identity': participant,
            if (block) 'isBlock': true,
          },
        ),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> sendMessage(MessageRequest request) async {
    await APIService().callApi(
      url: PostUrl.sendMessage,
      type: ApiType.post,
      body: request.toJson(),
    );
  }
}
