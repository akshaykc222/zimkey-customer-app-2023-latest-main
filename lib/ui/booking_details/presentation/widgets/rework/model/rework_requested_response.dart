// To parse this JSON data, do
//
//     final rescheduleWorkResponse = rescheduleWorkResponseFromJson(jsonString);

import 'dart:convert';

ReworkRequestedResponse reworkRequestedResponseFromJson(String str) => ReworkRequestedResponse.fromJson(json.decode(str));

String reworkRequestedResponseToJson(ReworkRequestedResponse data) => json.encode(data.toJson());

class ReworkRequestedResponse {
  final ReworkJob reworkJob;

  ReworkRequestedResponse({
    required this.reworkJob,
  });

  factory ReworkRequestedResponse.fromJson(Map<String, dynamic> json) => ReworkRequestedResponse(
    reworkJob: ReworkJob.fromJson(json["reworkJob"]),
  );

  Map<String, dynamic> toJson() => {
    "reworkJob": reworkJob.toJson(),
  };
}

class ReworkJob {
  final String bookingServiceItemStatus;

  ReworkJob({
    required this.bookingServiceItemStatus,
  });

  factory ReworkJob.fromJson(Map<String, dynamic> json) => ReworkJob(
    bookingServiceItemStatus: json["bookingServiceItemStatus"],
  );

  Map<String, dynamic> toJson() => {
    "bookingServiceItemStatus": bookingServiceItemStatus,
  };
}
