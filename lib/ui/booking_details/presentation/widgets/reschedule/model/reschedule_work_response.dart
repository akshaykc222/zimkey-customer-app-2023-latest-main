// To parse this JSON data, do
//
//     final rescheduleWorkResponse = rescheduleWorkResponseFromJson(jsonString);

import 'dart:convert';

RescheduleWorkResponse rescheduleWorkResponseFromJson(String str) => RescheduleWorkResponse.fromJson(json.decode(str));

String rescheduleWorkResponseToJson(RescheduleWorkResponse data) => json.encode(data.toJson());

class RescheduleWorkResponse {
  final RescheduleJob rescheduleJob;

  RescheduleWorkResponse({
    required this.rescheduleJob,
  });

  factory RescheduleWorkResponse.fromJson(Map<String, dynamic> json) => RescheduleWorkResponse(
    rescheduleJob: RescheduleJob.fromJson(json["rescheduleJob"]),
  );

  Map<String, dynamic> toJson() => {
    "rescheduleJob": rescheduleJob.toJson(),
  };
}

class RescheduleJob {
  final String id;

  RescheduleJob({
    required this.id,
  });

  factory RescheduleJob.fromJson(Map<String, dynamic> json) => RescheduleJob(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}
