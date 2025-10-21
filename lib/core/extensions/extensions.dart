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
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:m_cubit/abstraction.dart';
import 'package:m_cubit/util.dart';

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
  String get splitLongString {
    if (length <= 800) return this;
    return splitByLength(800).join('\n');
  }

  List<String> splitByLength(int chunkLength, {bool ignoreWhitespace = false}) {
    assert(chunkLength > 0, 'Chunk length must be positive');

    final chunks = <String>[];

    for (var i = 0; i < length; i += chunkLength) {
      final end = (i + chunkLength).clamp(0, length);
      var chunk = substring(i, end);

      if (ignoreWhitespace) {
        chunk = chunk.replaceAll(RegExp(r'\s+'), '');
      }
      chunks.add(chunk);
    }
    return chunks;
  }

  bool get canSendToSearch {
    if (isEmpty) false;

    return split(' ').last.length > 2;
  }

  String fixPhone() {
    if (startsWith('0')) return this;

    return '0$this';
  }

  String get formatPrice => num.tryParse(this)?.formatPrice ?? this;

  String get capitalizeFirst => isEmpty ? this : this[0].toUpperCase() + substring(1);

  bool get isZero => (num.tryParse(this) ?? 0) == 0;

  String? checkPhoneNumber(BuildContext context, String phone) {
    if (phone.startsWith('00964') && phone.length > 11) return phone;
    if (phone.length < 10) {
      NoteMessage.showSnakeBar(context: context, message: S.of(context).wrongPhone);
      return null;
    } else if (phone.startsWith("0") && phone.length < 11) {
      NoteMessage.showSnakeBar(context: context, message: S.of(context).wrongPhone);
      return null;
    }

    if (phone.length > 10 && phone.startsWith("0")) phone = phone.substring(1);

    phone = '00964$phone';

    return phone;
  }

  String get removeSpace => replaceAll(' ', '');

  String get removeDuplicates {
    List<String> words = split(' ');
    Set<String> uniqueWords = Set<String>.from(words);
    List<String> uniqueList = uniqueWords.toList();
    String output = uniqueList.join(' ');
    return output;
  }

  num get tryParseOrZero => num.tryParse(this) ?? 0;

  int get tryParseOrZeroInt => int.tryParse(this) ?? 0;

  num? get tryParseOrNull => num.tryParse(this);

  int? get tryParseOrNullInt => int.tryParse(this);

  String? get validateEmpty {
    if (isEmpty) {
      return S().is_required;
    } else {
      return null;
    }
  }

  String get decimalNumbersOnly {
    final matches = RegExp(r'\d+([.,]\d+)?').allMatches(this);
    return matches.map((m) => m.group(0)).join(' ');
  }

  String get toSnakeCase {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return replaceAllMapped(regex, (match) => '_${match.group(0)}').toLowerCase();
  }

  String get toSplitsSpaceCase {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return replaceAllMapped(regex, (match) => '_${match.group(0)}').toLowerCase().replaceAll('_', ' ');
  }

  String get toPascalCase {
    final words = split('_');
    return words.map((word) => word[0].toUpperCase() + word.substring(1)).join();
  }

  String get toCamelCase {
    final words = split('_');
    if (words.isEmpty) return '';
    final capitalized = words.map((word) => word[0].toUpperCase() + word.substring(1)).join();
    return capitalized[0].toLowerCase() + capitalized.substring(1);
  }

  Color get colorFromId {
    final hash = hashCode;
    final hue = (hash % 360).toDouble(); // 0 → 360
    const saturation = 0.6; // تشبع متوسط
    const lightness = 0.5; // سطوع متوسط

    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  Widget get copySymbol {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: this));
            ScaffoldMessenger.of(ctx!).showSnackBar(
              SnackBar(content: Text(S().textCopiedToClipboard)),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white12,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0).r,
            margin: EdgeInsets.symmetric(vertical: 3.0).r,
            child: DrawableText(
              text: this,
              maxLength: 4,
              drawablePadding: 5.0.w,
              drawableEnd: ImageMultiType(
                url: Icons.copy,
                height: 15.0.r,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color get gradeColor {
    final upperCaseGrade = toUpperCase();
    if (upperCaseGrade.contains('A')) {
      return Colors.green;
    } else if (upperCaseGrade.contains('B')) {
      return Colors.blue;
    } else if (upperCaseGrade.contains('C')) {
      return Colors.yellow;
    } else if (upperCaseGrade.contains('D')) {
      return Colors.orange;
    } else if (upperCaseGrade.contains('F')) {
      return Colors.red;
    } else {
      // Return a default color or throw an error for unknown grades
      return Colors.grey; // Or throw ArgumentError('Invalid grade: $this');
    }
  }

  String get firstCharacter {
    if (isEmpty) {
      return '';
    }
    return this[0];
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

  num get tryParseOrZero => num.tryParse(this ?? '0') ?? 0;

  int get tryParseOrZeroInt => int.tryParse(this ?? '0') ?? 0;

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
          color:
              this < 0 ? AppColorManager.redPrice.withValues(alpha: 0.5) : AppColorManager.green.withValues(alpha: 0.5),
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
        text: '${this < 0 ? '-' : ''}'
            '\$${abs().toStringAsFixed(3)}',
        fontWeight: FontWeight.bold,
        size: 18.0.sp,
        color:
            this < 0 ? AppColorManager.redPrice.withValues(alpha: 0.5) : AppColorManager.green.withValues(alpha: 0.5),
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
  bool get success => (this >= 200 && this <= 210);

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

  String get formatDate => DateFormat('yyyy/MM/dd', 'en').format(this);

  String get formatTime => DateFormat('h:mm a').format(this);

  String get formatTimeShow => '${hour == 0 ? '00' : hour}:${minute == 0 ? '00' : minute}';

  String get formatDateTime => '$formatDate $formatTime';

  String get formatDateName => DateFormat('dd/$monthName/yyyy').format(this);

  String get formatDateTime1 {
    return DateFormat('dd MMM yyyy  h:mm a').format(this);
  }

  String get formatDateToRequest => DateFormat('yyyy-MM-dd', 'en').format(this);

  DateTime addFromNow({int? year, int? month, int? day, int? hour, int? minute, int? second}) {
    return DateTime(
      this.year + (year ?? 0),
      this.month + (month ?? 0),
      this.day + (day ?? 0),
      this.hour + (hour ?? 0),
      this.minute + (minute ?? 0),
      this.second + (second ?? 0),
    );
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

extension ParticipantH on Participant {
  RemoteParticipant get remoteParticipant => this as RemoteParticipant;

  LocalParticipant get localParticipant => this as LocalParticipant;

  MediaType get type => videoTrackPublications.any((e) => e.isScreenShare) ? MediaType.screen : MediaType.media;

  RemoteTrackPublication<RemoteVideoTrack>? get remoteVideoPublication {
    return remoteParticipant.videoTrackPublications.where((e) => e.source == type.videoSourceType).firstOrNull;
  }

  RemoteTrackPublication<RemoteAudioTrack>? get remoteAudioPublication =>
      remoteParticipant.audioTrackPublications.where((e) => e.source == type.audioSourceType).firstOrNull;

  LocalTrackPublication<LocalVideoTrack>? get localVideoPublication {
    return localParticipant.videoTrackPublications.where((e) => e.source == type.videoSourceType).firstOrNull;
  }

  LocalTrackPublication<LocalAudioTrack>? get localAudioPublication =>
      localParticipant.audioTrackPublications.where((e) => e.source == type.audioSourceType).firstOrNull;

  //
  // LocalTrackPublication<LocalVideoTrack>? get videoPublication {
  //   return remoteParticipant.videoTrackPublications.where((e) => e.source == type.videoSourceType).firstOrNull;
  // }
  //
  // LocalTrackPublication<LocalAudioTrack>? get audioPublication =>
  //     remoteParticipant.audioTrackPublications.where((e) => e.source == type.audioSourceType).firstOrNull;

  VideoTrack? get activeVideoTrack =>
      (this is LocalParticipant) ? localVideoPublication?.track : remoteVideoPublication?.track;

  AudioTrack? get activeAudioTrack =>
      (this is LocalParticipant) ? localAudioPublication?.track : remoteAudioPublication?.track;

  bool get videoActive => activeVideoTrack != null && !activeVideoTrack!.muted;

  bool get audioActive => activeAudioTrack != null && !activeAudioTrack!.muted;

  LkUserType get userType => LkUserType.values[(attributes['lkUserType'] ?? 0).toString().tryParseOrZeroInt];

  String get displayName {
    if (identity.isNotEmpty) return identity;
    if (name.isNotEmpty) return name;
    return sid;
  }

  bool get isSuspend => permissions.isSuspend;
}

extension RemoteParticipantH on RemoteParticipant {
  LkUserType get userType => LkUserType.values[(attributes['lkUserType'] ?? 0).toString().tryParseOrZeroInt];

  RemoteAudioTrack? get activeAudioTrack => audioTrackPublications.firstWhereOrNull((e) => e.enabled)?.track;

  RemoteVideoTrack? get shareScreenTrack => videoTrackPublications.firstWhereOrNull((e) => e.isScreenShare)?.track;

  RemoteVideoTrack? get cameraTrack => videoTrackPublications.firstWhereOrNull((e) => !e.isScreenShare)?.track;
}

extension LocalParticipantH on LocalParticipant {
  LkUserType get userType => LkUserType.values[(attributes['lkUserType'] ?? 0).toString().tryParseOrZeroInt];

  LocalAudioTrack? get activeAudioTrack => audioTrackPublications.firstWhereOrNull((e) => !e.muted)?.track;

  LocalVideoTrack? get shareScreenTrack => videoTrackPublications.firstWhereOrNull((e) => e.isScreenShare)?.track;

  LocalVideoTrack? get cameraTrack => videoTrackPublications.firstWhereOrNull((e) => !e.isScreenShare)?.track;
}

extension ParticipantPermissionsH on ParticipantPermissions {
  bool get isSuspend => !canSubscribe && !canPublish;

  bool get isMuteAll => canSubscribe && !canPublish;

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
