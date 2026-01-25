import '../response/staff_record_response.dart';

class CreateStaffRecordRequest {
  CreateStaffRecordRequest({
    required this.id,
  });

  final String id;

  factory CreateStaffRecordRequest.fromJson(Map<String, dynamic> json) {
    return CreateStaffRecordRequest(
      id: json["id"] ?? "",
    );
  }

  factory CreateStaffRecordRequest.fromStaffRecord(StaffRecord staffRecord) {
    return CreateStaffRecordRequest(
      id: staffRecord.id.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

