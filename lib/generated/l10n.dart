// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Adaptive Grid`
  String get adaptiveGrid {
    return Intl.message(
      'Adaptive Grid',
      name: 'adaptiveGrid',
      desc: '',
      args: [],
    );
  }

  /// `Network error occurred`
  String get anErrorWithYourNetwork {
    return Intl.message(
      'Network error occurred',
      name: 'anErrorWithYourNetwork',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get and {
    return Intl.message('and', name: 'and', desc: '', args: []);
  }

  /// `Applause for the student`
  String get applauseForStudent {
    return Intl.message(
      'Applause for the student',
      name: 'applauseForStudent',
      desc: '',
      args: [],
    );
  }

  /// `april`
  String get april {
    return Intl.message('april', name: 'april', desc: '', args: []);
  }

  /// `Audiences`
  String get audiences {
    return Intl.message('Audiences', name: 'audiences', desc: '', args: []);
  }

  /// `august`
  String get august {
    return Intl.message('august', name: 'august', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Choral`
  String get choral {
    return Intl.message('Choral', name: 'choral', desc: '', args: []);
  }

  /// `Class members`
  String get classMembers {
    return Intl.message(
      'Class members',
      name: 'classMembers',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Connecting now, just a moment`
  String get connectingJustAMoment {
    return Intl.message(
      'Connecting now, just a moment',
      name: 'connectingJustAMoment',
      desc: '',
      args: [],
    );
  }

  /// `Connection timed out`
  String get connectionTimeOut {
    return Intl.message(
      'Connection timed out',
      name: 'connectionTimeOut',
      desc: '',
      args: [],
    );
  }

  /// `Course Registration Details`
  String get courseRegistrationDetails {
    return Intl.message(
      'Course Registration Details',
      name: 'courseRegistrationDetails',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get day {
    return Intl.message('day', name: 'day', desc: '', args: []);
  }

  /// `Deaf-blinding`
  String get deafblinding {
    return Intl.message(
      'Deaf-blinding',
      name: 'deafblinding',
      desc: '',
      args: [],
    );
  }

  /// `december`
  String get december {
    return Intl.message('december', name: 'december', desc: '', args: []);
  }

  /// `Disconnect`
  String get disconnect {
    return Intl.message('Disconnect', name: 'disconnect', desc: '', args: []);
  }

  /// `Disconnect and Ban`
  String get disconnectAndBan {
    return Intl.message(
      'Disconnect and Ban',
      name: 'disconnectAndBan',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `End`
  String get end {
    return Intl.message('End', name: 'end', desc: '', args: []);
  }

  /// `Enter Attendance`
  String get enterAttendance {
    return Intl.message(
      'Enter Attendance',
      name: 'enterAttendance',
      desc: '',
      args: [],
    );
  }

  /// `Enter Marks`
  String get enterMarks {
    return Intl.message('Enter Marks', name: 'enterMarks', desc: '', args: []);
  }

  /// `february`
  String get february {
    return Intl.message('february', name: 'february', desc: '', args: []);
  }

  /// `Grant permissions`
  String get grantPermissions {
    return Intl.message(
      'Grant permissions',
      name: 'grantPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Grant Whiteboard Permission`
  String get grantWhiteboard {
    return Intl.message(
      'Grant Whiteboard Permission',
      name: 'grantWhiteboard',
      desc: '',
      args: [],
    );
  }

  /// `hour`
  String get hour {
    return Intl.message('hour', name: 'hour', desc: '', args: []);
  }

  /// `Required`
  String get is_required {
    return Intl.message('Required', name: 'is_required', desc: '', args: []);
  }

  /// `january`
  String get january {
    return Intl.message('january', name: 'january', desc: '', args: []);
  }

  /// `july`
  String get july {
    return Intl.message('july', name: 'july', desc: '', args: []);
  }

  /// `june`
  String get june {
    return Intl.message('june', name: 'june', desc: '', args: []);
  }

  /// `Listener`
  String get listener {
    return Intl.message('Listener', name: 'listener', desc: '', args: []);
  }

  /// `march`
  String get march {
    return Intl.message('march', name: 'march', desc: '', args: []);
  }

  /// `may`
  String get may {
    return Intl.message('may', name: 'may', desc: '', args: []);
  }

  /// `Mic`
  String get mic {
    return Intl.message('Mic', name: 'mic', desc: '', args: []);
  }

  /// `minute`
  String get minute {
    return Intl.message('minute', name: 'minute', desc: '', args: []);
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `Mute`
  String get mute {
    return Intl.message('Mute', name: 'mute', desc: '', args: []);
  }

  /// `Mute all`
  String get muteAll {
    return Intl.message('Mute all', name: 'muteAll', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `No participants with active video`
  String get noActiveVideoParticipants {
    return Intl.message(
      'No participants with active video',
      name: 'noActiveVideoParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection`
  String get noInternet {
    return Intl.message(
      'Please check your internet connection',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `No participants with active video`
  String get noParticipantsWithActiveVideo {
    return Intl.message(
      'No participants with active video',
      name: 'noParticipantsWithActiveVideo',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `november`
  String get november {
    return Intl.message('november', name: 'november', desc: '', args: []);
  }

  /// `october`
  String get october {
    return Intl.message('october', name: 'october', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Oops!`
  String get oops {
    return Intl.message('Oops!', name: 'oops', desc: '', args: []);
  }

  /// `Please wait for content broadcast`
  String get pleaseWaitForContentBroadcast {
    return Intl.message(
      'Please wait for content broadcast',
      name: 'pleaseWaitForContentBroadcast',
      desc: '',
      args: [],
    );
  }

  /// `Reconnecting, please be patient`
  String get reconnectingPleaseWait {
    return Intl.message(
      'Reconnecting, please be patient',
      name: 'reconnectingPleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `requested permission`
  String get requestedPermission {
    return Intl.message(
      'requested permission',
      name: 'requestedPermission',
      desc: '',
      args: [],
    );
  }

  /// `requested to leave the session`
  String get requestedToLeaveTheSession {
    return Intl.message(
      'requested to leave the session',
      name: 'requestedToLeaveTheSession',
      desc: '',
      args: [],
    );
  }

  /// `Resume User`
  String get resumeUser {
    return Intl.message('Resume User', name: 'resumeUser', desc: '', args: []);
  }

  /// `Revoke permissions`
  String get revokePermissions {
    return Intl.message(
      'Revoke permissions',
      name: 'revokePermissions',
      desc: '',
      args: [],
    );
  }

  /// `Revoke Whiteboard Permission`
  String get revokeWhiteboard {
    return Intl.message(
      'Revoke Whiteboard Permission',
      name: 'revokeWhiteboard',
      desc: '',
      args: [],
    );
  }

  /// `Screen`
  String get screen {
    return Intl.message('Screen', name: 'screen', desc: '', args: []);
  }

  /// `Scrollable grid`
  String get scrollableGrid {
    return Intl.message(
      'Scrollable grid',
      name: 'scrollableGrid',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `seconds`
  String get second {
    return Intl.message('seconds', name: 'second', desc: '', args: []);
  }

  /// `See all`
  String get seeAll {
    return Intl.message('See all', name: 'seeAll', desc: '', args: []);
  }

  /// `See and hear`
  String get seeAndHear {
    return Intl.message('See and hear', name: 'seeAndHear', desc: '', args: []);
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `september`
  String get september {
    return Intl.message('september', name: 'september', desc: '', args: []);
  }

  /// `Server side error`
  String get serverSideError {
    return Intl.message(
      'Server side error',
      name: 'serverSideError',
      desc: '',
      args: [],
    );
  }

  /// `Session ended, thank you`
  String get sessionEndedThankYou {
    return Intl.message(
      'Session ended, thank you',
      name: 'sessionEndedThankYou',
      desc: '',
      args: [],
    );
  }

  /// `Shared content`
  String get sharedContent {
    return Intl.message(
      'Shared content',
      name: 'sharedContent',
      desc: '',
      args: [],
    );
  }

  /// `Show correction scale`
  String get showCorrectionScale {
    return Intl.message(
      'Show correction scale',
      name: 'showCorrectionScale',
      desc: '',
      args: [],
    );
  }

  /// `Show Full Participants`
  String get showParticipants {
    return Intl.message(
      'Show Full Participants',
      name: 'showParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Show Whiteboard`
  String get showWhiteboard {
    return Intl.message(
      'Show Whiteboard',
      name: 'showWhiteboard',
      desc: '',
      args: [],
    );
  }

  /// `Speaker`
  String get speaker {
    return Intl.message('Speaker', name: 'speaker', desc: '', args: []);
  }

  /// `Speaker Focus`
  String get speakerFocus {
    return Intl.message(
      'Speaker Focus',
      name: 'speakerFocus',
      desc: '',
      args: [],
    );
  }

  /// `Start Session`
  String get startSession {
    return Intl.message(
      'Start Session',
      name: 'startSession',
      desc: '',
      args: [],
    );
  }

  /// `Stop`
  String get stop {
    return Intl.message('Stop', name: 'stop', desc: '', args: []);
  }

  /// `Stop camera`
  String get stopCamera {
    return Intl.message('Stop camera', name: 'stopCamera', desc: '', args: []);
  }

  /// `Stop share screen`
  String get stopShareScreen {
    return Intl.message(
      'Stop share screen',
      name: 'stopShareScreen',
      desc: '',
      args: [],
    );
  }

  /// `Suspend User`
  String get suspendUser {
    return Intl.message(
      'Suspend User',
      name: 'suspendUser',
      desc: '',
      args: [],
    );
  }

  /// `Suspended`
  String get suspended {
    return Intl.message('Suspended', name: 'suspended', desc: '', args: []);
  }

  /// `Text copied to clipboard`
  String get textCopiedToClipboard {
    return Intl.message(
      'Text copied to clipboard',
      name: 'textCopiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message('Try Again', name: 'tryAgain', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Unmute all`
  String get unmuteAll {
    return Intl.message('Unmute all', name: 'unmuteAll', desc: '', args: []);
  }

  /// `User logged out`
  String get userLogout {
    return Intl.message(
      'User logged out',
      name: 'userLogout',
      desc: '',
      args: [],
    );
  }

  /// `View types`
  String get viewTypes {
    return Intl.message('View types', name: 'viewTypes', desc: '', args: []);
  }

  /// `Please wait for content broadcast`
  String get waitForContentBroadcast {
    return Intl.message(
      'Please wait for content broadcast',
      name: 'waitForContentBroadcast',
      desc: '',
      args: [],
    );
  }

  /// `Wants to join or get permission`
  String get wantsToJoinOrGetPermission {
    return Intl.message(
      'Wants to join or get permission',
      name: 'wantsToJoinOrGetPermission',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get wrongPhone {
    return Intl.message(
      'Invalid phone number',
      name: 'wrongPhone',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
