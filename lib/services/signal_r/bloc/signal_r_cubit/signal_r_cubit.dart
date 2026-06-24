import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/util/shared_preferences.dart';
import 'package:m_cubit/m_cubit.dart';
import 'package:signalr_core_new/signalr_core_new.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../signal_message.dart';

part 'signal_r_state.dart';

class SignalRCubit extends Cubit<SignalRInitial> {
  SignalRCubit() : super(SignalRInitial.initial());
  final List<String> joinedTopics = [];

  final _messageController = StreamController<SignalMessage>.broadcast();
  final _whiteboardController = StreamController<Uint8List>.broadcast();

  Stream<SignalMessage> get messageStream => _messageController.stream;

  Stream<Uint8List> get whiteboardStream => _whiteboardController.stream;

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
    final topic = joinedTopics.firstOrNull;
    if (topic == null) {
      loggerObject.e('joinedTopics is empty, cannot sendMessageToTopic');
      return;
    }
    await state.result?.invoke(
      'SendMessageToTopic',
      args: [
        message is SignalMessage ? jsonEncode(message.toJson()) : message,
        topic,
        false,
        messageType,
        '',
      ],
    );
  }

  Future<void> sendMessage(SignalMessage message, String connectionId) async {
    await state.result?.invoke('SendMessageToConnection', args: [jsonEncode(message), connectionId]);
  }

  Future<void> sendMessageToSubset(SignalMessage message, List<String> receiverIds) async {
    await state.result?.invoke(
      'SendMessageToSubset',
      args: [
        jsonEncode(message),
        joinedTopics.first,
        receiverIds,
      ],
    );
  }

  void _receiveMessage(List<dynamic>? arguments) {
    try {
      final messageType = MessageTypeEnum.values[int.tryParse(arguments?.last.toString() ?? '0') ?? 0];
      final message = arguments?.firstOrNull;

      switch (messageType) {
        case MessageTypeEnum.string:
          var x = (message?.toString() ?? "{}").toJson;
          loggerObject.f(x);
          _messageController.add(SignalMessage.fromJson(x));
        case MessageTypeEnum.bytes:
          final bytes = getBytesFromObject(message);
          _whiteboardController.add(bytes);
          debugPrint('${(bytes.length / 1024).toStringAsFixed(2)} KB');
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

  Future<void> updateMetadata(String userId, String metadata) async {
    await state.result?.invoke(
      'UpdateMetadata',
      args: [
        userId,
        joinedTopics.firstOrNull ?? '',
        metadata,
      ],
    );
  }

  void flush() {
    emit(state.copyWith(request: SignalMessage.fromJson({})));
  }

  Uint8List getBytesFromObject(dynamic message) {
    if (message is Uint8List) {
      return message;
    } else if (message is List) {
      return Uint8List.fromList(List<int>.from(message));
    } else {
      try {
        return base64Decode(message.toString());
      } catch (_) {
        return Uint8List(0);
      }
    }
  }

  @override
  Future<void> close() {
    deConnect();
    _messageController.close();
    _whiteboardController.close();
    return super.close();
  }
}
