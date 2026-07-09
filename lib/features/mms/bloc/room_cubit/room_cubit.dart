import 'dart:async' as asy;
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/error/error_manager.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/util/exts.dart';
import 'package:m_cubit/abstraction.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/app/app_widget.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../generated/assets.dart';
import '../../../../services/sounds_service.dart';
import '../../../room/room_config.dart';
import '../../data/request/setting_message.dart';

part 'room_state.dart';

class MMSRoomCubit extends MCubit<MMSRoomInitial> {
  MMSRoomCubit() : super(MMSRoomInitial.initial());

  asy.Timer? _sortDebounceTimer;

  @override
  String get nameCache => 'roomNotes';

  @override
  String get filter => state.result.name ?? '';

  Future<void> getDataFromCache() async {
    final data = await getListCached(fromJson: SettingMessage.fromJson);
    emit(state.copyWith(requestPermissions: data, id: state.notifyIndex + 1));
  }

  Future<void> initial() async {
    await Permission.microphone.request();
    await state.result.prepareConnection(state.url, state.token);
    state.result.addListener(_sortParticipants);
    setListeners();
  }

  void setListeners() {
    state.listener
      // Room disconnection
      ..on<RoomDisconnectedEvent>((e) {
        emit(state.copyWith(id: state.notifyIndex + 1));
      })
      //re sort list users
      // 🔹🔹 أحداث عامة للمشاركين (Participant Events)
      // هذا الحدث عام، يُطلق عند حدوث أي تغيير يخص المشاركين (اتصال، نشر، إلغاء نشر...).
      ..on<ParticipantEvent>((e) {
        // loggerObject.d(e.toString());
        _sortParticipants();
      })
      // 🔹🔹 عندما ينشر المستخدم المحلي (أنت) مسار جديد مثل الميكروفون أو الكاميرا.
      ..on<LocalTrackPublishedEvent>((e) => _sortParticipants())
      // 🔹🔹 عندما يقوم المستخدم المحلي بإلغاء نشر أحد المسارات الخاصة به (مثلاً أوقف الكاميرا).
      ..on<LocalTrackUnpublishedEvent>((e) => _sortParticipants())
      //
      // 🔸 أحداث تتعلق بالـ Tracks (المسارات)
      //
      // 🔹 عندما ينشر أحد المشاركين (غيرك) مسارًا جديدًا (كاميرا، ميكروفون...).
      ..on<TrackPublishedEvent>((e) async {})
      // 🔹 عندما يقوم أحد المشاركين بإلغاء نشر أحد المسارات الخاصة به.
      ..on<TrackUnpublishedEvent>((e) => (e) {})
      // 🔹🔹 عندما يشترك تطبيقك في مسار جديد من مشارك آخر (أصبح بإمكانك رؤيته/سماعه).
      ..on<TrackSubscribedEvent>((e) => _sortParticipants())
      // 🔹 إذا فشل الاشتراك في مسار معين بسبب خطأ (صلاحيات، شبكة...).
      // ..on<TrackSubscriptionExceptionEvent>((e) => _sortParticipants())
      // 🔹🔹 عندما يتم إلغاء الاشتراك في مسار (بسبب مغادرة المشارك أو أمر يدوي).
      ..on<TrackUnsubscribedEvent>((e) => _sortParticipants())
      // 🔹 عندما يتم كتم (mute) أحد المسارات سواء كان محلي أو من مشارك آخر.
      ..on<TrackMutedEvent>((e) {})
      // 🔹 عندما يتم إلغاء الكتم (unmute) عن المسار.
      ..on<TrackUnmutedEvent>((e) async {
        // await SoundService.play(Assets.soundsNote);
      })
      // 🔹 عندما تتغير حالة تدفق البيانات لمسار معين (توقف مؤقت أو استئناف).
      // ..on<TrackStreamStateUpdatedEvent>((e) => _sortParticipants())
      // 🔹 عندما تتغير صلاحيات الاشتراك في المسار (هل يمكن الاشتراك به أم لا).
      ..on<TrackSubscriptionPermissionChangedEvent>((e) {})
      // 🔹 عندما يتم تحديث معالجة المسار (مثل فلتر الفيديو أو تحسين الجودة).
      // ..on<TrackProcessorUpdateEvent>((e) => _sortParticipants())
      //
      // 🔸 أحداث خاصة بالغرفة (Room Events)
      //
      // 🔹 عندما يتم الاتصال بالغرفة بنجاح.
      ..on<RoomConnectedEvent>((e) {})
      // 🔹 عندما تبدأ عملية إعادة الاتصال بعد انقطاع مفاجئ.
      ..on<RoomReconnectingEvent>((e) {
        emit(state.copyWith(statuses: CubitStatuses.loading));
      })
      // 🔹 عندما تبدأ محاولة إعادة الاتصال فعليًا (محاولة أولى أو لاحقة).
      ..on<RoomAttemptReconnectEvent>((e) {
        emit(state.copyWith(statuses: .loading, id: state.notifyIndex + 1));
        loggerObject.w("محاولة إعادة اتصال رقم ${e.attempt} من أصل ${e.maxAttemptsRetry}");
      })
      // 🔹 عندما تتم إعادة الاتصال بالغرفة بنجاح بعد انقطاع.
      ..on<RoomReconnectedEvent>((e) {
        getDataFromCache();
        emit(state.copyWith(statuses: CubitStatuses.done, id: state.notifyIndex + 1));
      })
      // 🔹 عندما يتم فصل الاتصال بالغرفة نهائيًا أو مغادرتها.
      ..on<RoomDisconnectedEvent>((e) {})
      // 🔹 عندما تتغير بيانات الغرفة (metadata) مثل الاسم أو الحالة.
      // ..on<RoomMetadataChangedEvent>((e) => _sortParticipants())
      // 🔹 عندما تتغير حالة التسجيل (Recording) للغرفة.
      // ..on<RoomRecordingStatusChanged>((e) => _sortParticipants())
      //
      // 🔸 أحداث خاصة بالمشاركين (Participants)
      //
      // 🔹 عندما تتغير الخصائص (Attributes) الخاصة بأحد المشاركين.
      // ..on<ParticipantAttributesChanged>((e) => _sortParticipants())
      // 🔹 عندما ينضم مشارك جديد إلى الغرفة.
      ..on<ParticipantConnectedEvent>((e) async {
        await SoundService.play(Assets.soundsAcceptRequest);
      })
      // 🔹 عندما يغادر أحد المشاركين الغرفة أو يفقد الاتصال.
      ..on<ParticipantDisconnectedEvent>((e) async {
        await SoundService.play(Assets.soundsDisconnectUser);
      })
      // 🔹 عندما يتم تحديث البيانات (metadata) الخاصة بأحد المشاركين.
      // ..on<ParticipantMetadataUpdatedEvent>((e) => _sortParticipants())
      // 🔹 عندما تتغير حالة المشارك (مثلاً من joining إلى active).
      // ..on<ParticipantStateUpdatedEvent>((e) => _sortParticipants())
      // 🔹 عندما تتغير جودة الاتصال لأحد المشاركين (ضعيفة، متوسطة، جيدة).
      // ..on<ParticipantConnectionQualityUpdatedEvent>((e) => _sortParticipants())
      // 🔹 عندما تتغير صلاحيات المشارك (مثل السماح بالنشر أو لا).
      ..on<ParticipantPermissionsUpdatedEvent>((e) {})
      // 🔹🔹 عندما يغيّر المشارك اسمه المعروض (display name).
      // ..on<ParticipantNameUpdatedEvent>((e) => _sortParticipants())
      // 🔹 عندما يتم استقبال بيانات (DataPacket) من أحد المشاركين (مثل رسالة أو إشارة تحكم).
      ..on<DataReceivedEvent>(
        (e) async {
          setHaveNewNote(true);
          try {
            final message = SettingMessage.fromJson(jsonDecode(utf8.decode(e.data)));
            if (!message.toUserType.isManager) return;

            SoundService.play(Assets.soundsNote);
            switch (message.action) {
              case MMSManagerActions.requestPermission:
              case MMSManagerActions.requestToDisconnect:
              case MMSManagerActions.message:
              case MMSManagerActions.changeScreen:
                await addOrUpdateToCache(message);
            }
          } catch (err) {
            loggerObject.e('Failed to decode: $err');
          }
        },
      );
  }

  void _sortParticipants() {
    // Cancel previous debounce timer
    _sortDebounceTimer?.cancel();

    // Debounce for 100ms to prevent excessive rebuilds
    _sortDebounceTimer = asy.Timer(const Duration(milliseconds: 300), () {
      List<Participant> screenTracks = [];

      for (var participant in state.result.remoteParticipants.values) {
        screenTracks.add(participant);
      }

      if (state.result.localParticipant != null) {
        screenTracks.add(state.result.localParticipant!);
      }

      screenTracks.sort(
        (a, b) {
          if (a.permissions.isSuspend != b.permissions.isSuspend) {
            return a.permissions.isSuspend ? 1 : -1;
          }
          return 0;
        },
      );

      final list = [...screenTracks];
      emit(state.copyWith(participant: list, id: state.notifyIndex + 1));
    });
  }

  Future<void> connect({
    bool enableCamera = false,
    bool enableMic = false,
    bool enableScreen = false,
  }) async {
    try {
      emit(state.copyWith(statuses: CubitStatuses.loading));

      bool realEnableCamera = enableCamera;
      bool realEnableMic = enableMic;

      // 1. Check hardware availability (works on all platforms, including Windows/Web)
      try {
        final devices = await Hardware.instance.enumerateDevices();
        final hasCamera = devices.any((d) => d.kind.toLowerCase().contains('video'));
        if (!hasCamera) {
          realEnableCamera = false;
        }
        final hasMic = devices.any((d) => d.kind.toLowerCase().contains('audio') && d.kind.toLowerCase().contains('input'));
        if (!hasMic) {
          realEnableMic = false;
        }
      } catch (e) {
        loggerObject.w('Error enumerating devices: $e');
      }

      // 2. Check platform permissions (only on mobile where permission_handler is supported)
      if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
        if (realEnableCamera) {
          try {
            var status = await Permission.camera.status;
            if (!status.isGranted) {
              status = await Permission.camera.request();
            }
            if (!status.isGranted) {
              realEnableCamera = false;
            }
          } catch (e) {
            loggerObject.w('Error checking camera permissions: $e');
          }
        }

        if (realEnableMic) {
          try {
            var status = await Permission.microphone.status;
            if (!status.isGranted) {
              status = await Permission.microphone.request();
            }
            if (!status.isGranted) {
              realEnableMic = false;
            }
          } catch (e) {
            loggerObject.w('Error checking microphone permissions: $e');
          }
        }
      }

      try {
        await state.result.connect(
          state.url,
          state.token,
          fastConnectOptions: FastConnectOptions(
            camera: TrackOption(enabled: realEnableCamera),
            microphone: TrackOption(enabled: realEnableMic),
            screen: TrackOption(enabled: enableScreen),
          ),
          connectOptions: RoomConfig.instance.connectionOption,
        );
      } catch (connectError) {
        loggerObject.e('Initial connect failed: $connectError. Retrying with fallback...');
        
        Future<Room> recreateRoomAndListener() async {
          try {
            state.result.removeListener(_sortParticipants);
            await state.listener.dispose();
            await state.result.dispose();
          } catch (_) {}
          
          final newRoom = Room(roomOptions: RoomConfig.instance.roomOptions);
          final newListener = newRoom.createListener();
          emit(state.copyWith(result: newRoom, listener: newListener));
          newRoom.addListener(_sortParticipants);
          setListeners();
          return newRoom;
        }

        if (realEnableCamera) {
          try {
            final fallbackRoom = await recreateRoomAndListener();
            await fallbackRoom.connect(
              state.url,
              state.token,
              fastConnectOptions: FastConnectOptions(
                camera: const TrackOption(enabled: false),
                microphone: TrackOption(enabled: realEnableMic),
                screen: TrackOption(enabled: enableScreen),
              ),
              connectOptions: RoomConfig.instance.connectionOption,
            );
            getDataFromCache();
            emit(state.copyWith(statuses: CubitStatuses.done));
            // startRecording();
            return;
          } catch (retryError) {
            loggerObject.e('Retry with camera disabled failed: $retryError');
          }
        }

        // Final fallback: both camera and microphone disabled
        final finalRoom = await recreateRoomAndListener();
        await finalRoom.connect(
          state.url,
          state.token,
          fastConnectOptions: FastConnectOptions(
            camera: const TrackOption(enabled: false),
            microphone: const TrackOption(enabled: false),
            screen: TrackOption(enabled: enableScreen),
          ),
          connectOptions: RoomConfig.instance.connectionOption,
        );
      }

      getDataFromCache();
      emit(state.copyWith(statuses: CubitStatuses.done));
      // startRecording();
    } catch (e) {
      emit(state.copyWith(statuses: CubitStatuses.error, error: e.toString()));
      showErrorFromApi(state);
    }
  }

  void disconnect() async {
    final result = await ctx!.showDisconnectDialog();
    try {
      if (result == true) await state.result.disconnect();
    } catch (e) {
      loggerObject.e(e);
    }
  }

  void setUrl(String url) => emit(state.copyWith(url: url));

  void setToken(String token) {
    emit(state.copyWith(token: token));
  }

  void selectParticipant(String participantTrackId) {
    emit(state.copyWith(selectedUserId: participantTrackId));
  }

  void raiseHand() {}

  Future<void> addOrUpdateToCache(SettingMessage item) async {
    final listJson = await addOrUpdateDate([item]);
    if (listJson == null) return;
    final list = listJson.map((e) => SettingMessage.fromJson(e)).toList();
    emit(state.copyWith(requestPermissions: list));
  }

  Future<void> deleteFromCache(String id) async {
    final listJson = await deleteDate([id]);
    if (listJson == null) return;
    loggerObject.w('id: $id, listJson: $listJson');
    final list = listJson.map((e) => SettingMessage.fromJson(e)).toList();
    emit(state.copyWith(requestPermissions: list));
  }

  void setHaveNewNote(bool b) {
    emit(state.copyWith(/*haveNewNote: b,*/ id: state.notifyIndex + 1));
  }

  @override
  Future<void> close() {
    (() async {
      _sortDebounceTimer?.cancel();
      state.result.removeListener(_sortParticipants);
      await state.listener.dispose();
      await state.result.dispose();
    })();
    return super.close();
  }

  @override
  get mState => state;
}
