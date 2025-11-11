import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:lk_assistant/core/api_manager/api_url.dart';
import 'package:lk_assistant/core/error/error_manager.dart';
import 'package:lk_assistant/core/extensions/extensions.dart';
import 'package:lk_assistant/core/util/exts.dart';
import 'package:lk_assistant/core/util/shared_preferences.dart';
import 'package:m_cubit/abstraction.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/app/app_widget.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../generated/assets.dart';
import '../../data/request/setting_message.dart';

part 'room_state.dart';

class RoomCubit extends MCubit<RoomInitial> {
  RoomCubit() : super(RoomInitial.initial());

  Future<void> initial() async {
    await Permission.microphone.request();
    await state.result.prepareConnection(state.url, state.token);
    state.result.addListener(_sortParticipants);
    setListeners();
  }

  void setListeners() {
    state.listener
      //end call
      ..on<RoomDisconnectedEvent>((e) {
        emit(state.copyWith(id: state.notifyIndex + 1));
      })
      //re sort list users

      // 🔹🔹 أحداث عامة للمشاركين (Participant Events)
      // هذا الحدث عام، يُطلق عند حدوث أي تغيير يخص المشاركين (اتصال، نشر، إلغاء نشر...).
      ..on<ParticipantEvent>((e) {
        loggerObject.d(e.toString());
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
      ..on<RoomReconnectingEvent>((e) {})

      // 🔹 عندما تبدأ محاولة إعادة الاتصال فعليًا (محاولة أولى أو لاحقة).
      // ..on<RoomAttemptReconnectEvent>((e) => _sortParticipants())

      // 🔹 عندما تتم إعادة الاتصال بالغرفة بنجاح بعد انقطاع.
      ..on<RoomReconnectedEvent>((e) {})

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
        // await SoundService.play(Assets.soundsAcceptRequest);
      })

      // 🔹 عندما يغادر أحد المشاركين الغرفة أو يفقد الاتصال.
      ..on<ParticipantDisconnectedEvent>((e) async {
        // await SoundService.play(Assets.soundsDisconnectUser);
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
          try {
            final message = SettingMessage.fromJson(jsonDecode(utf8.decode(e.data)));
            loggerObject.w(message.toJson());

            if (!message.toUserType.isSharer) return;

            // if (message.toIdentity.isNotEmpty && message.toIdentity != state.result.localParticipant?.identity) return;

            switch (message.action) {
              case ManagerActions.requestPermission:
              case ManagerActions.requestToDisconnect:
              case ManagerActions.changeScreen:
                selectParticipant(message.id);
                break;

              case ManagerActions.message:
                emit(state.copyWith(loadingPermissions: false));
                break;
            }
          } catch (err) {
            loggerObject.i('Failed to decode: $err');
          }
        },
      );
  }

  void _sortParticipants() {
    List<Participant> screenTracks = [];

    for (var participant in state.result.remoteParticipants.values) {
      if (participant.videoActive) {
        screenTracks.add(participant);
      }
    }

    if (state.result.localParticipant?.userType == LkUserType.sharer && state.result.localParticipant != null) {
      screenTracks.add(state.result.localParticipant!);
    }

    final list = [
      ...screenTracks, /*...userMediaTracks*/
    ];

    final selectedTruck = state.selectedParticipantId.isNotEmpty
        ? null
        : list.isEmpty
            ? null
            : list.first.identity;

    emit(state.copyWith(participant: list, selectedParticipantId: selectedTruck, id: state.notifyIndex + 1));
  }

  Future<void> connect() async {
    try {
      emit(state.copyWith(statuses: CubitStatuses.loading));
      await state.result.connect(
        state.url,
        state.token,
        fastConnectOptions: FastConnectOptions(),
      );
      state.result.connectionState;
      emit(state.copyWith(statuses: CubitStatuses.done));
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
    AppSharedPreference.cashToken(token);
    emit(
      state.copyWith(token: token),
    );
  }

  void selectParticipant(String participantId) {
    emit(state.copyWith(selectedParticipantId: participantId));
  }

  Future<void> raiseHand() async {
    await state.result.localParticipant?.publishData(
      utf8.encode(
        jsonEncode(
          SettingMessage(
            id: state.result.localParticipant?.identity ?? '',
            toUserType: LkUserType.manager,
            action: ManagerActions.requestPermission,
            metadata: {
              'name': state.result.localParticipant?.name,
              'id': state.result.localParticipant?.identity,
            },
          ),
        ),
      ),
    );
    emit(state.copyWith(loadingPermissions: true));
  }

  Future<void> sendMessage(String message) async {
    await state.result.localParticipant?.publishData(
      utf8.encode(
        jsonEncode(
          SettingMessage(
            toUserType: LkUserType.manager,
            action: ManagerActions.message,
            metadata: {
              'message': message,
              'name': state.result.localParticipant?.name,
              'id': state.result.localParticipant?.identity,
            },
          ),
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    (() async {
      state.result.removeListener(_sortParticipants);
      await state.listener.dispose();
      await state.result.dispose();
    })();
    return super.close();
  }
}
