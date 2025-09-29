import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';

import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../app/app_widget.dart';

enum ProfileCard { trips, shipments, pay, ern }

enum ApiType { get, post, put, patch, delete }

enum StartPage { login, home, confirmPassword, createPassword }

enum CriterionGroup {
  personal,
  financial,
  legal;

  String get getName {
    switch (this) {
      case CriterionGroup.personal:
        return S.of(ctx!).personal;
      case CriterionGroup.financial:
        return S.of(ctx!).financial;
      case CriterionGroup.legal:
        return S.of(ctx!).legal;
    }
  }
}

enum FontManager { regular, semeBold, bold }

enum OfferApplicationStatus {
  pending,
  accepted,
  rejected;

  Color get getColorStatus {
    switch (this) {
      case OfferApplicationStatus.pending:
        return Colors.grey;
      case OfferApplicationStatus.accepted:
        return Colors.green;
      case OfferApplicationStatus.rejected:
        return Colors.red;
    }
  }
}

enum ExamRunStatus {
  draft,
  scheduled,
  started,
  closed,
  archived;

  bool get isStarted => this == started;

  Color get getColor {
    switch (this) {
      case ExamRunStatus.draft:
        return Colors.grey;
      case ExamRunStatus.scheduled:
        return Colors.blue;

      case ExamRunStatus.archived:
        return Colors.orange;
      case ExamRunStatus.started:
        return Colors.green;
      case ExamRunStatus.closed:
        return Colors.black;
    }
  }

  IconData get getIcon {
    switch (this) {
      case ExamRunStatus.draft:
        return Icons.edit;
      case ExamRunStatus.scheduled:
        return Icons.event;

      case ExamRunStatus.archived:
        return Icons.hourglass_empty;
      case ExamRunStatus.started:
        return Icons.play_arrow;
      case ExamRunStatus.closed:
        return Icons.lock;
    }
  }

  Widget get getIconWidget => ImageMultiType(url: getIcon, color: getColor);

  Widget get getWidget => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [getIconWidget, 5.0.horizontalSpace, DrawableText(text: name)],
      );
}

enum ExamRunType {
  formative,
  summative;

  bool get isFormative => this == formative;

  bool get isSummative => this == summative;

  Color get getColor {
    switch (this) {
      case ExamRunType.formative:
        return Colors.blueAccent;
      case ExamRunType.summative:
        return Colors.deepPurple;
    }
  }

  IconData get getIcon {
    switch (this) {
      case ExamRunType.formative:
        return Icons.school;
      case ExamRunType.summative:
        return Icons.assignment_turned_in;
    }
  }

  Widget get getIconWidget => Icon(getIcon, color: getColor);

  Widget get getWidget => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [getIconWidget, 5.0.horizontalSpace, DrawableText(text: name)],
      );
}

enum StudentAnswerStatus {
  notAnswer,
  notSure,
  sure;

  bool get isNotAnswer => this == notAnswer;

  bool get isNotSure => this == notSure;

  bool get isSure => this == sure;

  String get name {
    switch (this) {
      case StudentAnswerStatus.notAnswer:
        return S().notAnswer;
      case StudentAnswerStatus.notSure:
        return S().notSure;
      case StudentAnswerStatus.sure:
        return S().sure;
    }
  }

  Color get color {
    switch (this) {
      case StudentAnswerStatus.notAnswer:
        return AppColorManager.lightGrayAb;
      case StudentAnswerStatus.notSure:
        return AppColorManager.ampere;
      case StudentAnswerStatus.sure:
        return AppColorManager.mainColor;
    }
  }

  Color get colorAlpha {
    switch (this) {
      case StudentAnswerStatus.notAnswer:
        return AppColorManager.lightGrayEd;
      case StudentAnswerStatus.notSure:
        return AppColorManager.ampere.withValues(alpha: 0.5);
      case StudentAnswerStatus.sure:
        return AppColorManager.mainColor.withValues(alpha: 0.5);
    }
  }
}

enum ConnectionStatus {
  initial,
  tryConnect,
  connected,
  disconnected;

  Color get getColor {
    switch (this) {
      case ConnectionStatus.initial:
        return AppColorManager.lightGray;
      case ConnectionStatus.tryConnect:
        return AppColorManager.ampere;
      case ConnectionStatus.connected:
        return AppColorManager.green;
      case ConnectionStatus.disconnected:
        return AppColorManager.red;
    }
  }

  bool get isInitial => this == initial;

  bool get isTryConnect => this == tryConnect;

  bool get isConnected => this == connected;

  bool get isDisconnected => this == disconnected;
}

enum CompressQuality {
  q20,
  q40,
  q60,
  q80,
  q100;

  int get getQuality {
    switch (this) {
      case CompressQuality.q20:
        return 20;
      case CompressQuality.q40:
        return 40;
      case CompressQuality.q60:
        return 60;
      case CompressQuality.q80:
        return 80;
      case CompressQuality.q100:
        return 100;
    }
  }
}

enum SignalRStatus {
  connected,
  reconnecting,
  notConnected;

  Color get getColor {
    switch (this) {
      case SignalRStatus.connected:
        return AppColorManager.green;
      case SignalRStatus.reconnecting:
        return AppColorManager.ampere;
      case SignalRStatus.notConnected:
        return AppColorManager.red;
    }
  }
}

enum IsReadType {
  none,
  mark,
  remark,
  absence;
}

enum PermissionType {
  none,
  read,
  add,
  update,
  delete,
}

enum RoleType {
  systemRole,
  programRole,
}

enum ClaimType {
  menu,
  module,
  operation,
  block,
  item,
  group,
}

enum StudentStatus {
  enrolled,
  withdrawn,
  graduated,
  dropout,
  transported,
}

enum Gender {
  male,
  female,
}

enum GroupTermGender {
  male,
  female,
  mixed,
}

enum EnrollmentMethod {
  direct,
  placementTest,
}

enum Coverage {
  school,
  group,
}

enum StaffNextYearStatus {
  confirmed,
  withdrawn,
  notDetermined,
}

enum StaffStatus {
  atWork,
  absent,
}

enum Semester {
  firstSemester,
  secondSemester,
  finalResult;

  String get name {
    return switch (this) {
      Semester.firstSemester => S().firstSemester,
      Semester.secondSemester => S().secondSemester,
      Semester.finalResult => S().finalResult,
    };
  }
}

enum selectType { show, select }

enum StudentRecordStatus {
  registered,
  unregistered;

  String get name {
    return switch (this) {
      StudentRecordStatus.registered => S().registered,
      StudentRecordStatus.unregistered => S().unregistered,
    };
  }

  Color get color {
    return switch (this) {
      StudentRecordStatus.registered => AppColorManager.green,
      StudentRecordStatus.unregistered => AppColorManager.red,
    };
  }

  dynamic get icon {
    return switch (this) {
      StudentRecordStatus.registered => Icons.check_circle_outline,
      StudentRecordStatus.unregistered => Icons.cancel_outlined,
    };
  }

  Widget get iconWidget => ImageMultiType(url: icon, color: color, height: 20.0.r, width: 20.0.r);
}

enum NextYearStatus {
  confirmed,
  withdrawn,
  notDetermined,
}

enum LovLabel {
  language,
  degreeType,
  programCourseType,
  mappingLevel,
  examViolation,
  justification,
  courseAssessmentSemester,
  disciplineType,
  finalResult,
  remarkType,
  rewardType,
  scheduleDay,
  scheduleSession,
  vacationType,
}

// enum UniversityRegistrationType  {
//  Direct,
//  GeneralCompetition,
//  FillingPlacesCompetition,
//  Transfer
//
// }
enum UniversityRegistrationType {
  direct,
  generalCompetition,
  fillingPlacesCompetition,
  transfer;

  String get name {
    return switch (this) {
      UniversityRegistrationType.direct => S().direct,
      UniversityRegistrationType.generalCompetition => S().generalCompetition,
      UniversityRegistrationType.fillingPlacesCompetition => S().fillingPlacesCompetition,
      UniversityRegistrationType.transfer => S().transfer,
    };
  }

  IconData get icon {
    return switch (this) {
      UniversityRegistrationType.direct => Icons.how_to_reg_outlined,
      UniversityRegistrationType.generalCompetition => Icons.emoji_events_outlined,
      UniversityRegistrationType.fillingPlacesCompetition => Icons.group_add_outlined,
      UniversityRegistrationType.transfer => Icons.transfer_within_a_station_outlined,
    };
  }

  Color get color {
    return switch (this) {
      UniversityRegistrationType.direct => AppColorManager.green,
      UniversityRegistrationType.generalCompetition => AppColorManager.ampere,
      UniversityRegistrationType.fillingPlacesCompetition => AppColorManager.blue,
      UniversityRegistrationType.transfer => AppColorManager.red,
    };
  }

  Widget get iconWidget {
    return ImageMultiType(
      url: icon,
      color: color,
      height: 20.0.r,
      width: 20.0.r,
    );
  }
}

enum QuestionBankManagerRole {
  courseQuestionBankManager,
}

enum SystemRoleEnum {
  staffManager,
  unitManager,
  questionManager,
}

enum ViolationSourceType {
  humanProctor,
  aiProctor,
}

enum QuestionType {
  multipleChoiceQuestionOneAnswer,
  multipleChoiceQuestionMultipleAnswers,
  trueFalse,
  essay,
}

enum ReviewRecommendation {
  accepted,
  acceptableButWithModifications,
  unacceptable,
}

enum ViolationDecision {
  underReview,
  dismissed,
  reported,
}

enum QuestionApprovalDecision {
  pending,
  refused,
  confirmed,
}

enum QuestionSubmissionStatus {
  pending,
  underReview,
  approved,
  disapproved,
  underSupervision,
}

enum ExamStatus {
  generated,
  notGenerated,
}

enum MonitorType {
  ai,
  online,
  physical,
}

enum PerformanceLogType {
  questionTime,
}

enum ApprovalStatus {
  approved,
  disapproved,
}

enum ExamMonitorStatus {
  pending,
  started,
  closed,
}

enum AdmissionType {
  image,
  video,
  voice,
  text,
}

enum Probability {
  veryUnlikely,
  unlikely,
  possible,
  likely,
  veryLikely,
}

enum MembershipType {
  non,
}

enum NotificationTarget {
  none,
}

enum Priority {
  low,
  medium,
  high,
}

enum LovGroup {
  setting,
}

enum RangeType {
  page,
  time,
  bookmark,
}

enum ResourceType {
  pdf,
  docx,
  html,
  txt,
  mp4,
  jpeg,
}

enum UnitTeamRole {
  unitAdmin,
}

enum TermManagement {
  institution,
  program,
}

enum TermType {
  institution,
  program,
}

enum SourceType {
  non,
}

enum AbsenceType {
  justified,
  unjustified;

  Color get color {
    return switch (this) {
      AbsenceType.justified => AppColorManager.mainColor,
      AbsenceType.unjustified => AppColorManager.secondColor,
    };
  }

  Color get getColor {
    return switch (this) {
      AbsenceType.justified => AppColorManager.mainColor,
      AbsenceType.unjustified => AppColorManager.secondColor,
    };
  }

  String get name {
    return switch (this) {
      AbsenceType.justified => S().justified,
      AbsenceType.unjustified => S().unjustified,
    };
  }

  bool get isJustified => this == justified;

  bool get isUnjustified => this == unjustified;
}

enum CourseTeamRole {
  courseAdmin,
  supervisor,
  reviewer,
  contributor,
  dataEntry,
}

enum UserType {
  student,
  staff,
  schoolmaster,
  ;

  static UserType getByNameOrIndex(String name) {
    final index = int.tryParse(name);

    if (index != null) {
      return UserType.values[index];
    }

    switch (name.toLowerCase()) {
      case 'student':
        return student;
      case 'staff':
        return staff;
      case 'schoolmaster':
        return schoolmaster;
    }
    return student;
  }

  bool get isStudent => this == UserType.student;

  bool get isStaff => this == UserType.staff;
}

enum Month {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december;

  String get name {
    return switch (this) {
      Month.january => S().january,
      Month.february => S().february,
      Month.march => S().march,
      Month.april => S().april,
      Month.may => S().may,
      Month.june => S().june,
      Month.july => S().july,
      Month.august => S().august,
      Month.september => S().september,
      Month.october => S().october,
      Month.november => S().november,
      Month.december => S().december,
    };
  }
}

enum SelectType { select, show }

enum LectureType {
  theoretical,
  practical;

  bool get isTheoretical => this == theoretical;

  bool get isPractical => this == practical;

  String get name {
    return switch (this) {
      LectureType.theoretical => S().theoretical,
      LectureType.practical => S().practical,
    };
  }

  IconData get icon {
    return switch (this) {
      LectureType.theoretical => Icons.menu_book_outlined,
      LectureType.practical => Icons.science_outlined,
    };
  }

  Color get color {
    return switch (this) {
      LectureType.theoretical => Colors.blue,
      LectureType.practical => Colors.green,
    };
  }

  Widget get iconWidget {
    return ImageMultiType(url: icon, color: color);
  }
}

enum LectureTypeDraft {
  non,
  both,
  theoretical,
  practical;

  bool get isTheoretical => this == theoretical;

  bool get isPractical => this == practical;

  bool get isNon => this == practical;

  bool get isBoth => this == both;
}

enum Currency {
  syp,
  usd;

  Widget get nameWidget => DrawableText(
        text: name,
        size: 12.0.sp,
        drawablePadding: 2.0.w,
        drawableStart: ImageMultiType(
          url: icon,
          height: 15.0.dg,
          width: 15.0.dg,
        ),
      );

  Widget get iconWidget => ImageMultiType(
        url: icon,
        height: 15.0.dg,
        width: 15.0.dg,
      );

  String get name {
    return switch (this) {
      Currency.syp => S().syp,
      Currency.usd => S().usd,
    };
  }

  dynamic get icon {
    return switch (this) {
      Currency.syp => Assets.iconsSpy,
      Currency.usd => Icons.attach_money,
    };
  }
}

enum StudentRequestStatus {
  submitted,
  inProgress,
  completed,
  rejected;

  String get name {
    return switch (this) {
      StudentRequestStatus.submitted => S().submitted,
      StudentRequestStatus.inProgress => S().inProgress,
      StudentRequestStatus.completed => S().completed,
      StudentRequestStatus.rejected => S().rejected,
    };
  }

  Color get color {
    return switch (this) {
      StudentRequestStatus.submitted => AppColorManager.mainColor,
      StudentRequestStatus.inProgress => AppColorManager.ampere,
      StudentRequestStatus.completed => AppColorManager.green,
      StudentRequestStatus.rejected => AppColorManager.red,
    };
  }

  IconData get icon {
    return switch (this) {
      StudentRequestStatus.submitted => Icons.file_upload_outlined,
      StudentRequestStatus.inProgress => Icons.hourglass_top_outlined,
      StudentRequestStatus.completed => Icons.check_circle_outline,
      StudentRequestStatus.rejected => Icons.cancel_outlined,
    };
  }

  Widget get iconWidget => ImageMultiType(
        url: icon,
        height: 20.0.r,
        width: 20.0.r,
        color: color,
      );
}

enum ExamOrganizedType {
  mid,
  finalExam;

  String get name {
    return switch (this) {
      ExamOrganizedType.mid => S().mid,
      ExamOrganizedType.finalExam => S().finalExam,
    };
  }

  IconData get icon {
    return switch (this) {
      ExamOrganizedType.mid => Icons.filter_1_outlined,
      ExamOrganizedType.finalExam => Icons.filter_2_outlined,
    };
  }

  Color get color {
    return switch (this) {
      ExamOrganizedType.mid => Colors.orange,
      ExamOrganizedType.finalExam => Colors.red,
    };
  }

  Widget get iconWidget => ImageMultiType(
        url: icon,
        color: color,
        height: 20.0.r,
        width: 20.0.r,
      );
}
