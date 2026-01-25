import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_cubit/abstraction.dart';
import 'package:signalr_core_new/signalr_core_new.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/app/app_provider.dart';
import '../../../../core/app/app_widget.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../record.dart';
import '../../signal_message.dart';

part 'signal_r_state.dart';

String _serverUrl(String id) => "https://signalr.coretech-mena.com/hub/$id";

class SignalRCubit extends Cubit<SignalRInitial> {
  SignalRCubit() : super(SignalRInitial.initial());
  final List<String> joinedTopics = [];

  Future<void> deConnect() async {
    await state.result?.stop();
    emit(state.copyWith(connectionState: .notConnected));
  }

  Future<void> initialSignalR(String id) async {
    if (state.result?.state == HubConnectionState.connected) return;

    final hub = HubConnectionBuilder().withUrl(_serverUrl(id)).withAutomaticReconnect().build();

    emit(state.copyWith(result: hub, connectionState: .reconnecting));

    await state.result?.start()?.then(
      (value) {
        emit(state.copyWith(connectionState: .connected));
        listeners();
      },
    );
  }

  Future<void> joinTopic(String name) async {
    if (joinedTopics.contains(name)) {
      loggerObject.e('joined before');
      return;
    }

    if (state.connectionState != .connected) {
      await Future.delayed(
        Duration(seconds: 5),
        () => joinTopic(name),
      );
      return;
    }

    await leaveTopic(name);

    await state.result?.invoke("JoinTopic", args: [name, AppProvider.getStaff.staffRecordId]);
    joinedTopics.add(name);
  }

  Future<void> leaveTopic(String name) async {
    await state.result?.invoke("LeaveTopic", args: [name]);
    joinedTopics.remove(name);
  }

  Future<void> sendMessage(SignalMessage message, String connectionId) async {
    await state.result?.invoke('SendMessageToConnection', args: [jsonEncode(message), connectionId]);
  }

  Future<void> sendMessageToTopic(SignalMessage message) async {
    await state.result?.invoke('SendMessageToTopic', args: [jsonEncode(message), 'user', false]);
  }

  void _receiveMessage(List<dynamic>? arguments) {
    loggerObject.f('ReceiveMessage: $arguments');

    try {
      var x = jsonDecode(arguments?.firstOrNull.toString() ?? "{}");

      try {} catch (e) {
        loggerObject.e(e);
      }
    } catch (e) {
      loggerObject.e('ReceiveMessage,error:$e');
    }
  }

  void listeners() {
    state.result
      ?..on(
        'ReceiveMessage',
        (arguments) => _receiveMessage(arguments),
      )
      ..on(
        'UserJoined',
        (arguments) {
          loggerObject.d("UserJoined $arguments");
        },
      )
      ..on(
        'UserLeft',
        (arguments) {
          emit(
            state.copyWith(connectionIds: (arguments ?? []).cast(), signalStudentStatus: SignalStudentStatus.remove),
          );
          loggerObject.d("UserLeft $arguments");
        },
      )
      ..onreconnected(
        (connectionId) {
          emit(state.copyWith(connectionState: .connected));
          loggerObject.i('onReconnected: $connectionId');
          for (var topic in joinedTopics) {
            joinTopic(topic);
          }
        },
      )
      ..onreconnecting(
        (error) {
          emit(state.copyWith(connectionState: .reconnecting));
          loggerObject.i('onReconnecting: $error');
        },
      )
      ..onclose(
        (error) {
          emit(state.copyWith(connectionState: .notConnected));

          loggerObject.e('onClose: $error');
        },
      );
  }

  @override
  Future<void> close() {
    deConnect();
    return super.close();
  }
}
