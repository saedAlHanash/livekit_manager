import '../../../../core/extensions/extensions.dart';

class StaffRecords {
  StaffRecords({
    required this.items,
  });

  final List<StaffRecord> items;

  factory StaffRecords.fromJson(Map<String, dynamic> json) {
    return StaffRecords(
      items: json["items"] == null ? [] : List<StaffRecord>.from(json["items"]!.map((x) => StaffRecord.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "items": items.map((x) => x.toJson()).toList(),
  };
}

class StaffRecord {
  StaffRecord({
    required this.staffId,
    required this.termId,
    required this.sessionsCount,
    required this.id,
  });

  final String staffId;
  final String termId;
  final num sessionsCount;
  final String id;

  factory StaffRecord.fromJson(Map<String, dynamic> json) {
    return StaffRecord(
      staffId: json["staffId"] ?? "",
      termId: json["termId"] ?? "",
      sessionsCount: json["sessionsCount"] ?? 0,
      id: json["id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "staffId": staffId,
    "termId": termId,
    "sessionsCount": sessionsCount,
    "id": id,
  };
}

class StaffDetails {
  StaffDetails({
    required this.staffRecordId,
    required this.staffName,
    required this.staffGender,
    required this.school,
    required this.schoolLogo,
  });

  final String staffRecordId;
  final String staffName;
  final num staffGender;
  final String school;
  final String schoolLogo;

  factory StaffDetails.fromJson(Map<String, dynamic> json) {
    return StaffDetails(
      staffRecordId: json["staffRecordId"] ?? "",
      staffName: json["staffName"] ?? "",
      staffGender: json["staffGender"] ?? 0,
      school: json["school"] ?? "",
      schoolLogo: (json["schoolLogo"] ?? "").toString().fixImageAvatar,
    );
  }

  Map<String, dynamic> toJson() => {
    "staffRecordId": staffRecordId,
    "staffName": staffName,
    "staffGender": staffGender,
    "school": school,
    "schoolLogo": schoolLogo,
  };
}
