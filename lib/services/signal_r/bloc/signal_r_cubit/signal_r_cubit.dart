import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:m_cubit/m_cubit.dart';
import 'package:signalr_core_new/signalr_core_new.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../signal_message.dart';

part 'signal_r_state.dart';

class SignalRCubit extends Cubit<SignalRInitial> {
  SignalRCubit() : super(SignalRInitial.initial());
  final List<String> joinedTopics = [];

  final _messageController = StreamController<SignalMessage>.broadcast();

  Stream<SignalMessage> get messageStream => _messageController.stream;

  Future<void> deConnect() async {
    await state.result?.stop();
    emit(state.copyWith(connectionState: SignalRStatus.notConnected));
  }

  Future<void> initialSignalR(String topicId, String userId) async {
    if (state.result?.state == HubConnectionState.connected) return;

    final hub = HubConnectionBuilder()
        .withUrl("https://signalr.coretech-mena.com/hub/$topicId")
        .withAutomaticReconnect()
        .build();

    emit(state.copyWith(result: hub, connectionState: SignalRStatus.reconnecting));

    await state.result?.start()?.then(
      (value) {
        emit(state.copyWith(connectionState: SignalRStatus.connected));
        listeners(topicId, userId);
        joinTopic(topicId, userId);
      },
    );
  }

  Future<void> joinTopic(String name, String userId, {bool forceJoinTopic = false}) async {
    if (joinedTopics.contains(name) && !forceJoinTopic) {
      loggerObject.e('joined before');
      return;
    }

    if (state.connectionState != SignalRStatus.connected) {
      await Future.delayed(
        const Duration(seconds: 5),
        () => joinTopic(name, userId),
      );
      return;
    }

    await leaveTopic(name);

    final args = [name, userId];
    await state.result?.invoke("JoinTopic", args: args);

    joinedTopics.add(name);
  }

  Future<void> leaveTopic(String name) async {
    await state.result?.invoke("LeaveTopic", args: [name]);
    joinedTopics.remove(name);
  }

  Future<void> sendMessageToTopic(dynamic message, {int messageType = 0}) async {
    if (state.connectionState != SignalRStatus.connected || state.result == null) return;
    await state.result?.invoke(
      'SendMessageToTopic',
      args: [
        message is SignalMessage ? jsonEncode(message.toJson()) : message,
        joinedTopics.first,
        false,
        messageType,
        '',
      ],
    );
  }

  void _receiveMessage(List<dynamic>? arguments) {
    print('__ $arguments');
    try {
      final lastArg = MessageTypeEnum.values[arguments?.last??0];
      if (lastArg == 1 || (lastArg is int && lastArg == 1)) {
        final firstArg = arguments?.first;
        Uint8List bytes;
        if (firstArg is Uint8List) {
          bytes = firstArg;
        } else if (firstArg is List) {
          bytes = Uint8List.fromList(List<int>.from(firstArg));
        } else {
          bytes = base64Decode(firstArg.toString());
        }
        _messageController.add(SignalMessage.fromBytes(bytes));
      } else {
        final x = jsonDecode(arguments?.firstOrNull.toString() ?? "{}") as Map<String, dynamic>;
        loggerObject.f(x);
        _messageController.add(SignalMessage.fromJson(x));
      }
      switch(lastArg){

        case MessageTypeEnum.string:
          // TODO: Handle this case.
          throw UnimplementedError();
        case MessageTypeEnum.bytes:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    } catch (e) {
      loggerObject.e('ReceiveMessage,error:$e');
    }
  }

  void listeners(String topicId, String userId) {
    state.result
      ?..on(
        'ReceiveMessage',
        (arguments) {
          _receiveMessage(arguments);
        },
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
            state.copyWith(connectionIds: (arguments ?? []).cast()),
          );
          loggerObject.d("UserLeft $arguments");
        },
      )
      ..onreconnected(
        (connectionId) {
          emit(state.copyWith(connectionState: SignalRStatus.connected, request: SignalMessage.fromJson({})));
          loggerObject.i('onReconnected: $connectionId');
          for (var topic in joinedTopics) {
            joinTopic(topic, userId, forceJoinTopic: true);
          }
        },
      )
      ..onreconnecting(
        (error) {
          emit(state.copyWith(connectionState: SignalRStatus.reconnecting));
          loggerObject.i('onReconnecting: $error');
        },
      )
      ..onclose(
        (error) {
          emit(state.copyWith(connectionState: SignalRStatus.notConnected));
          loggerObject.e('onClose: $error');
        },
      );
  }

  void flush() {
    emit(state.copyWith(request: SignalMessage.fromJson({})));
  }

  @override
  Future<void> close() {
    deConnect();
    _messageController.close();
    return super.close();
  }
}
