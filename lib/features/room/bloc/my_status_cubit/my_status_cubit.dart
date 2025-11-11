import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_cubit/abstraction.dart';
import 'package:lk_assistant/core/api_manager/api_url.dart';
import 'package:lk_assistant/core/error/error_manager.dart';
import 'package:lk_assistant/core/extensions/extensions.dart';
import 'package:lk_assistant/features/room/bloc/room_cubit/room_cubit.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/app/app_widget.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../data/response/my_status.dart';

part 'my_status_state.dart';

class MyStatusCubit extends MCubit<MyStatusInitial> {
  MyStatusCubit() : super(MyStatusInitial.initial());

  @override
  get mState => state;

  Future<void> fetchMyStatus(String identity) async {
    emit(state.copyWith(statuses: CubitStatuses.loading));
    final response = await APIService().callApi(
      url: PostUrl.getLatestState,
      type: ApiType.post,
      body: {
        "room": ctx?.read<RoomCubit>().state.result.name,
        "identity": identity,
      },
    );
    if (response.statusCode.success) {
      final data = MyStatus.fromJson(json.decode(response.body));
      emit(state.copyWith(statuses: CubitStatuses.done, result: data));
    } else {
      emit(
        state.copyWith(
          statuses: CubitStatuses.error,
          error: ErrorManager.getApiError(response),
        ),
      );
    }
  }
}
