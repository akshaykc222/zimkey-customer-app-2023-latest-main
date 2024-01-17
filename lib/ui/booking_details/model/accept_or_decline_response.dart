

import 'dart:convert';


AcceptOrDeclineResponse singleBookingDetailResponseFromJson(String str) => AcceptOrDeclineResponse.fromJson(json.decode(str));

String singleBookingDetailResponseToJson(AcceptOrDeclineResponse data) => json.encode(data.toJson());

class AcceptOrDeclineResponse {
  final ApproveJob approveJob;

  AcceptOrDeclineResponse({
    required this.approveJob,
  });

  factory AcceptOrDeclineResponse.fromJson(Map<String, dynamic> json) => AcceptOrDeclineResponse(
    approveJob: ApproveJob.fromJson(json["approveJob"]),
  );

  Map<String, dynamic> toJson() => {
    "approveJob": approveJob.toJson(),
  };
}

class ApproveJob {
  final String id;
  final String bookingServiceItemStatus;
  final DateTime startDateTime;
  final DateTime endDateTime;

  ApproveJob({
  required this.id,
  required this.bookingServiceItemStatus,
  required this.startDateTime,
  required this.endDateTime,
  });

  factory ApproveJob.fromJson(Map<String, dynamic> json) => ApproveJob(
    id: json["id"],
    bookingServiceItemStatus: json["bookingServiceItemStatus"],
  startDateTime: DateTime.parse(json["startDateTime"]),
  endDateTime: DateTime.parse(json["endDateTime"]),
  );

  Map<String, dynamic> toJson() => {
  "id": id,
  "bookingServiceItemStatus": bookingServiceItemStatus,
  "startDateTime": startDateTime.toIso8601String(),
  "endDateTime": endDateTime.toIso8601String(),
  };
  }