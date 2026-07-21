import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_multi_type/image_multi_type.dart';
import 'package:intl/intl.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:m_cubit/abstraction.dart';
import 'package:m_cubit/util.dart';

import '../../features/room/bloc/room_cubit/room_cubit.dart';
import '../../features/room/data/request/room_meta.dart';
import '../../features/room/data/response/room_member.dart';
import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../api_manager/api_service.dart';
import '../api_manager/api_url.dart';
import '../app/app_widget.dart';
import '../error/error_manager.dart';
import '../util/pair_class.dart';
import '../util/snack_bar_message.dart';
import '../widgets/spinner_widget.dart';

extension SplitByLength on String {
  String get firstCharacter {
    if (isEmpty) {
      return '';
    }
    return this[0];
  }
Map<String, dynamic> get toJson {
  try {
    if (startsWith('[')) {
      final convertString = '{"items": $this}';
      final json = jsonDecode(convertString);
      return json;
    }
    return jsonDecode(this);
  } catch (e) {
    loggerObject.e('Convert from String to json:/$this/ $e');
    return jsonDecode('{}');
  }
}
}
extension StringHelper on String? {
  String get fixImageAvatar {
    if (isBlank || this == imagePath || this == Assets.imagesAvatar) {
      return Assets.imagesAvatar;
    }

    if (this!.startsWith('http')) return this!;
    final String link = "https://$baseUrl/documents/$this";
    return link;
  }

  String get fixUrl {
    if (isBlank) return '';
    if (this == imagePath) return '';
    if (this!.startsWith('http')) return this!;

    final String link = "https://$baseUrl/documents/$this";
    return link;
  }

  num get tryParseOrZero => num.tryParse(this ?? '0') ?? 0;

  bool? get tryParseBoolOrFalse => this == null ? null : (toString() == '1' || toString() == 'true');

  String? get validateEmpty {
    if (this == null) return null;
    if (this!.isEmpty) {
      return S().is_required;
    } else {
      return null;
    }
  }
}

final oCcy = NumberFormat(",###", "en_US");

extension MaxInt on num {
  int get max => 2147483647;

  String get formatPrice => oCcy.format(this);

  String get percentage => '$this%';

  Widget get formatPriceWidget => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      DrawableText(text: oCcy.format(this), size: 12.0.sp),
      DrawableText(text: ' SAR', fontWeight: FontWeight.bold, size: 9.0.sp),
    ],
  );

  Widget get counterWidget => Container(
    height: 40.0.r,
    width: 40.0.r,
    margin: EdgeInsetsDirectional.only(end: 10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColorManager.mainColorDark,
    ),
    alignment: Alignment.center,
    child: DrawableText(
      text: this == 0 ? '' : toInt().toString().padLeft(2, '0'),
      // color: AppColorManager.mainColor,
    ),
  );

  Widget get changePercentageUsd => Container(
    height: 24,
    padding: const EdgeInsets.symmetric(horizontal: 4),
    margin: const EdgeInsets.symmetric(horizontal: 4),
    alignment: Alignment.center,
    decoration: ShapeDecoration(
      color: this < 0 ? AppColorManager.redPrice.withValues(alpha: 0.5) : AppColorManager.green.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    child: DrawableText(
      text: '%${toStringAsFixed(3)}',
      textAlign: TextAlign.center,
      color: this < 0 ? AppColorManager.redPrice : AppColorManager.green,
      // fontWeight: FontWeight.bold,
    ),
  );

  Widget get changeAmountUsd => DrawableText(
    textAlign: TextAlign.center,
    text:
        '${this < 0 ? '-' : ''}'
        '\$${abs().toStringAsFixed(3)}',
    fontWeight: FontWeight.bold,
    size: 18.0.sp,
    color: this < 0 ? AppColorManager.redPrice.withValues(alpha: 0.5) : AppColorManager.green.withValues(alpha: 0.5),
  );
}

extension NeedUpdateEnumH on NeedUpdateEnum {
  bool get loading => this == NeedUpdateEnum.withLoading;

  bool get haveData => this == NeedUpdateEnum.no || this == NeedUpdateEnum.noLoading;

  CubitStatuses get getState {
    switch (this) {
      case NeedUpdateEnum.no:
        return CubitStatuses.done;
      case NeedUpdateEnum.withLoading:
        return CubitStatuses.loading;
      case NeedUpdateEnum.noLoading:
        return CubitStatuses.done;
    }
  }
}

extension HelperJson on Map<String, dynamic> {
  num getAsNum(String key) {
    if (this[key] == null) return -1;
    return num.tryParse((this[key]).toString()) ?? -1;
  }
}

extension ListEnumHelper on List<Enum> {
  List<SpinnerItem> getSpinnerItems({String? selectedId, Widget? icon}) {
    return List<SpinnerItem>.from(
      map(
        (e) => SpinnerItem(
          id: e.index.toString(),
          isSelected: e.index.toString() == selectedId,
          name: e.name,
          icon: icon,
          item: e,
        ),
      ),
    );
  }
}

extension ResponseHelper on http.Response {
  Map<String, dynamic> get jsonBody {
    try {
      if (body.startsWith('[')) {
        final convertString = '{"items": $body}';
        final json = jsonDecode(convertString);
        return json;
      }
      return jsonDecode(body);
    } catch (e) {
      loggerObject.e('jsonBody:/${request?.url.toString()}/ $e');
      return jsonDecode('{}');
    }
  }

  Map<String, dynamic> get jsonBodyPure {
    try {
      return jsonDecode(body);
    } catch (e) {
      return jsonDecode('{}');
    }
  }

  Map<String, dynamic> get jsonBodyData {
    try {
      if (body.startsWith('[')) {
        final convertString = '{"items": $body}';
        final json = jsonDecode(convertString);
        return json;
      }
      return jsonDecode(body);
    } catch (e) {
      loggerObject.e(e);
      return jsonDecode('{}');
    }
  }

  DateTime get serverTime {
    final dateString = (headers['date'] ?? '');

    // Define the format that matches the date string
    final format = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US');

    // Parse the string to DateTime
    final parsedDate = format.parseUtc(dateString);

    return DateTime.parse(parsedDate.toIso8601String().replaceAll(RegExp(r'[Zz]'), ''));
  }

  dynamic get getPairError {
    return Pair(null, ErrorManager.getApiError(this));
  }
}

extension CubitStatusesHelper on CubitStatuses {
  bool get loading => this == CubitStatuses.loading;

  bool get done => this == CubitStatuses.done;
}

extension FormatDuration on Duration {
  String get format =>
      '${inMinutes.remainder(60).toString().padLeft(2, '0')}:${(inSeconds.remainder(60)).toString().padLeft(2, '0')}';
}

extension ApiStatusCode on int {


  //
  // int get countDiv2 {
  //   final dr = this / 2; //double result
  //   final ir = this ~/ 2; //int result
  //   return (ir < dr) ? ir + 1 : ir;
  // }
  int get countDiv2 => (this ~/ 2 < this / 2) ? this ~/ 2 + 1 : this ~/ 2;
}

extension TextEditingControllerHelper on TextEditingController {
  void clear() {
    if (text.isNotEmpty) text = '';
  }
}

extension DateUtcHelper on DateTime {
  int get hashDate => (day * 61) + (month * 83) + (year * 23);

  DateTime get getUtc => DateTime.utc(year, month, day);

  DateTime get fixTimeToSameDate {
    final now = APIService().serverTime;

    return DateTime(now.year, now.month, now.day).copyWith(hour: hour, minute: minute, second: second);
  }

  bool inRangeTime(DateTime? start, DateTime? end) {
    final fixedSwapStartDateTime = (start ?? this);
    final fixedSwapEndDateTime = (end ?? this);
    final isAfter = this.isAfter(fixedSwapStartDateTime.toUtc());
    final isBefore = this.isBefore(fixedSwapEndDateTime.toUtc());

    return isAfter && isBefore;
  }

  bool isSameDate(DateTime? date) {
    if (date == null) return false;
    return year == date.year && month == date.month && day == date.day;
  }


  DateTime initialFromDateTime({required DateTime date, required TimeOfDay time}) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  FormatDateTime getFormat({DateTime? serverDate}) {
    final difference = this.difference(serverDate ?? DateTime.now());

    final months = difference.inDays.abs() ~/ 30;
    final days = difference.inDays.abs() % 360;
    final hours = difference.inHours.abs() % 24;
    final minutes = difference.inMinutes.abs() % 60;
    final seconds = difference.inSeconds.abs() % 60;
    return FormatDateTime(
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  String formatDurationHtml({DateTime? serverDate}) {
    final result = getFormat(serverDate: serverDate);
    final formattedDuration = StringBuffer();

    var c = 0;
    if (result.months > 0) {
      c++;
      formattedDuration.write('${S().and} <strong>${result.months}</strong> ${S().month} ');
    }
    if (result.days > 0 && c < 2) {
      c++;
      formattedDuration.write('${S().and} <strong>${result.days}</strong> ${S().day} ');
    }
    if (result.hours > 0 && c < 2) {
      c++;
      formattedDuration.write('${S().and} <strong>${result.hours}</strong> ${S().hour} ');
    }
    if (result.minutes > 0 && c < 2) {
      c++;
      formattedDuration.write('${S().and} <strong>${result.minutes}</strong> ${S().minute} ');
    }
    if (result.seconds > 0 && c < 2) {
      c++;
      formattedDuration.write('${S().and} <strong>${result.seconds}</strong> ${S().second} ');
    }

    // Replace and color the result string
    String htmlResult = formattedDuration.toString().trim().replaceFirst(S().and, '');

    // Custom color for the word "result"
    htmlResult = htmlResult.replaceAll(
      'result',
      '<span style="color: yourCustomColor;">result</span>',
    );

    return htmlResult;
  }

  String formatDuration({DateTime? serverDate}) {
    final result = getFormat(serverDate: serverDate);

    final formattedDuration = StringBuffer();

    var c = 0;
    if (result.months > 0) {
      c++;
      formattedDuration.write('${S().and} ${result.months} ${S().month}');
    }
    if (result.days > 0 && c < 2) {
      c++;
      formattedDuration.write('${S().and} ${result.days} ${S().day}  ');
    }
    if (result.hours > 0 && c < 2) {
      c++;
      formattedDuration.write('${S().and} ${result.hours} ${S().hour}  ');
    }
    if (result.minutes > 0 && c < 2) {
      c++;
      formattedDuration.write('${S().and} ${result.minutes} ${S().minute}  ');
    }
    if (result.seconds > 0 && c < 2) {
      c++;
      formattedDuration.write('${S().and} ${result.seconds} ${S().second} ');
    }

    return formattedDuration.toString().trim().replaceFirst(S().and, '');
  }

  String get timeLeft {
    if (isBefore(APIService().serverTime)) return '';
    final result = getFormat(serverDate: APIService().serverTime);

    final formattedDuration = StringBuffer();

    var c = 0;
    if (result.months > 0) {
      c++;
      formattedDuration.write('${S().and} ${result.months} ${S().month}');
    }
    if (result.days > 0 && c < 2) {
      c++;
      formattedDuration.write('${S().and} ${result.days} ${S().day}  ');
    }
    if (result.hours > 0 && c < 2) {
      c++;
      formattedDuration.write('${S().and} ${result.hours} ${S().hour}  ');
    }
    if (result.minutes > 0 && c < 2) {
      c++;
      formattedDuration.write('${S().and} ${result.minutes} ${S().minute}  ');
    }
    if (result.seconds > 0 && c < 2) {
      c++;
      formattedDuration.write('${S().and} ${result.seconds} ${S().second} ');
    }

    return formattedDuration.toString().trim().replaceFirst(S().and, '');
  }

  Month get monthEnum => Month.values[month - 1];

  String get monthName => monthEnum.name;

  DateTime get fixTimeZone => add(DateTime.now().timeZoneOffset);

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}

extension FirstItem<E> on Iterable<E> {
  E? get firstItem => isEmpty ? null : first;
}

extension GetDateTimesBetween on DateTime {
  List<DateTime> getDateTimesBetween({required DateTime end, required Duration period}) {
    var dateTimes = <DateTime>[];
    var current = add(period);
    while (current.isBefore(end)) {
      if (dateTimes.length > 24) {
        break;
      }
      dateTimes.add(current);
      current = current.add(period);
    }
    return dateTimes;
  }
}

extension DrawableTextH on DrawableText {
  static DrawableText header1(String text) {
    return DrawableText(
      text: text,
      color: AppColorManager.mainColor,
      fontWeight: FontWeight.bold,
      fontFamily: FontManager.bold.name,
      matchParent: true,
    );
  }
}

extension ReadOrNull on BuildContext {
  T? readOrNull<T>() {
    try {
      return read<T>();
    } on ProviderNotFoundException catch (_) {
      return null;
    }
  }

  void navigateWithUrlUpdate(
    String routeName, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? pathParameters,
  }) {
    // Push the new route onto the navigation stack
    pushNamed(routeName, queryParameters: queryParameters ?? {});

    // Manually update the URL
    final router = GoRouter.of(this);
    final newLocation = router.namedLocation(
      routeName,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
    );

    router.go(newLocation);
  }

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

extension GlobalKeyH on GlobalKey {
  Size? get getSize {
    final renderBox = currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    return size;
  }
}

class FormatDateTime {
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const FormatDateTime({
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  String get years => (months ~/ 12).toString();

  @override
  String toString() {
    return '$months\n'
        '$days\n'
        '$hours\n'
        '$minutes\n'
        '$seconds\n';
  }
}

//region live kit
extension ParticipantLocal on Participant {
  RemoteParticipant get remoteParticipant => this as RemoteParticipant;

  LocalParticipant get localParticipant => this as LocalParticipant;

  MediaType get mediaType => videoTrackPublications.any((e) => e.isScreenShare) ? MediaType.screen : MediaType.media;

  RemoteTrackPublication<RemoteVideoTrack>? get _remoteVideoPublication {
    return remoteParticipant.videoTrackPublications.where((e) => e.source == mediaType.videoSourceType).firstOrNull;
  }

  RemoteTrackPublication<RemoteAudioTrack>? get _remoteAudioPublication =>
      remoteParticipant.audioTrackPublications.where((e) => e.source == mediaType.audioSourceType).firstOrNull;

  LocalTrackPublication<LocalVideoTrack>? get _localVideoPublication {
    return localParticipant.videoTrackPublications.where((e) => e.source == mediaType.videoSourceType).firstOrNull;
  }

  LocalTrackPublication<LocalAudioTrack>? get _localAudioPublication =>
      localParticipant.audioTrackPublications.where((e) => e.source == mediaType.audioSourceType).firstOrNull;

  VideoTrack? get screenTrack =>
      videoTrackPublications.firstWhereOrNull((e) => e.isScreenShare && e.track?.muted == false)?.track as VideoTrack?;

  VideoTrack? get cameraTrack =>
      videoTrackPublications.firstWhereOrNull((e) => !e.isScreenShare && e.track?.muted == false)?.track as VideoTrack?;

  bool get haveActiveVideoTrack => videoTrackPublications.any((e) => e.track?.muted == false) || !isMuted;

  bool get haveActiveAudioTrack => audioTrackPublications.any((e) => e.track?.muted == false) || !isMuted;

  bool get isLocalUser => this is LocalParticipant;

  bool get isRemoteUser => !isLocalUser;
}

extension ParticipantH on Participant {
  String get image => attributes['imageUrl'].toString();

  VideoTrack? get activeVideoTrack => (!haveActiveVideoTrack)
      ? null
      : (isLocalUser)
      ? _localVideoPublication?.track
      : _remoteVideoPublication?.track;

  AudioTrack? get activeAudioTrack => (isLocalUser) ? _localAudioPublication?.track : _remoteAudioPublication?.track;

  bool get audioActive => activeAudioTrack != null && !activeAudioTrack!.muted;

  LkUserType get userType =>
      LkUserType.values[(attributes['lkUserType'] ?? attributes['type'] ?? 0).toString().tryParseOrZeroInt];

  String get displayName {
    if (name.isNotEmpty) return name;
    if (identity.isNotEmpty) return identity;
    return sid;
  }

  bool get isAudioEnabled => (this is lk.RemoteParticipant)
      ? (this as lk.RemoteParticipant).isAudioEnabled
      : (this as lk.LocalParticipant).isAudioEnabled;

  bool get isSuspend => permissions.isSuspend;

  bool get isChosen => haveActiveAudioTrack && isRemoteUser;

  List<TrackPublication> get videoPublicationList =>
      videoTrackPublications.where((e) => e.kind == TrackType.VIDEO && e.track != null).toList();

  List<TrackPublication> get audioPublicationList =>
      audioTrackPublications.where((e) => e.kind == TrackType.AUDIO && e.track != null).toList();

  VideoTrack? get primaryTrack {
    if (!haveActiveVideoTrack) return null;
    if (videoTrackPublications.length == 1) return videoTrackPublications.first.track as VideoTrack?;
    return screenTrack;
  }

  VideoTrack? get secondaryTrack {
    if (!haveActiveVideoTrack) return null;
    if (videoTrackPublications.length != 2) return null;
    return cameraTrack;
  }
}

extension RemoteParticipantH on RemoteParticipant {
  RemoteAudioTrack? get activeAudioTrack => audioTrackPublications.firstWhereOrNull((e) => e.enabled)?.track;

  RemoteVideoTrack? get shareScreenTrack => videoTrackPublications.firstWhereOrNull((e) => e.isScreenShare)?.track;

  RemoteVideoTrack? get cameraTrack => videoTrackPublications.firstWhereOrNull((e) => !e.isScreenShare)?.track;
}

extension LocalParticipantH on LocalParticipant {
  LocalAudioTrack? get activeAudioTrack => audioTrackPublications.firstWhereOrNull((e) => !e.muted)?.track;

  LocalVideoTrack? get shareScreenTrack => videoTrackPublications.firstWhereOrNull((e) => e.isScreenShare)?.track;

  LocalVideoTrack? get cameraTrack => videoTrackPublications.firstWhereOrNull((e) => !e.isScreenShare)?.track;
}

extension ParticipantPermissionsH on ParticipantPermissions {
  bool get isSuspend => !canSubscribe && !canPublish;

  bool get isSilence => !canPublish && canSubscribe;

  bool get isAll => canSubscribe && canPublish;

  String get printFun {
    return 'canSubscribe: $canSubscribe\n'
        'canPublish: $canPublish\n'
        'canPublishData: $canPublishData\n'
        'canUpdateMetadata: $canUpdateMetadata\n'
        'hidden: $hidden';
  }
}

extension ConnectionQualityH on ConnectionQuality {
  Widget get icon => ImageMultiType(
    url: this == ConnectionQuality.poor ? Icons.wifi_off_outlined : Icons.wifi,
    color: {
      ConnectionQuality.excellent: Colors.green,
      ConnectionQuality.good: Colors.orange,
      ConnectionQuality.poor: Colors.red,
    }[this],
    height: 16.0.dg,
  );
}

extension ConnectionStateH on lk.ConnectionState {
  bool get isDisconnected => this == lk.ConnectionState.disconnected;

  bool get isConnecting => this == lk.ConnectionState.connecting;

  bool get isReconnecting => this == lk.ConnectionState.reconnecting;

  bool get isConnected => this == lk.ConnectionState.connected;
}

extension RoomInitialH on RoomInitial {
  List<Participant> get otherParticipants => participants
      .where(
        (e) => (e.identity != (selectedParticipant?.identity ?? '')) && e.haveActiveVideoTrack && e.isRemoteUser,
      )
      .toList();

  List<Participant> get participantTracksWithoutMe => participants
      .where((e) => e.isRemoteUser)
      // .sorted(
      //   (a, b) => (b.permissions.canPublish ? 1 : 0) - (a.permissions.canPublish ? 1 : 0),
      // )
      // .sorted(
      //   (a, b) => ((!b.userType.isUser) ? 1 : 0) - ((!b.userType.isUser) ? 1 : 0),
      // )
      .toList();

  List<RoomMember> get allRoomMembers {
    final members = <RoomMember>[];
    final connectedIdentities = <String>{};
    for (final p in participantTracksWithoutMe) {
      connectedIdentities.add(p.identity);
      final user = expectedUsers.firstWhereOrNull((u) => u.id == p.identity);
      members.add(RoomMember(participant: p, user: user));
    }

    for (final u in expectedUsers) {
      if (!connectedIdentities.contains(u.id)) {
        members.add(RoomMember(user: u));
      }
    }

    return members;
  }

  List<Participant> get usersAndChosenParticipants => participants
      .where(
        (e) => e.haveActiveVideoTrack && e.haveActiveAudioTrack && e.isRemoteUser,
      )
      .toList();

  Participant? get selectedParticipant {
    return selectedParticipantId.isEmpty
        ? null
        : participants.firstWhereOrNull((e) => e.identity == selectedParticipantId);
  }

  lk.ConnectionState get connectionState => result.connectionState;

  bool get isConnect => result.connectionState == lk.ConnectionState.connected;

  bool get havePermission => result.localParticipant?.permissions.canPublish ?? false;

  Participant? getParticipantById(String id) => participants.firstWhereOrNull((e) => e.identity == id);

  List<Participant> get speakers => participants.where((e) => e.permissions.canPublish).toList();

  String get sharerId => participants.firstWhereOrNull((e) => e.userType.isSharer)?.identity ?? '';
}

extension RoomH on Room {
  RoomMeta get getMeta {
    try {
      return RoomMeta.fromJson(jsonDecode(metadata.isBlank ? '{}' : metadata!));
    } catch (e) {
      loggerObject.e(e);
      return RoomMeta.fromJson({});
    }
  }

  bool get isCoralMode => getMeta.type == .choral;
}

//endregion
