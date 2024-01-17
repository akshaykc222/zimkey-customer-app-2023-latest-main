// To parse this JSON data, do
//
//     final bookingSlotsResponse = bookingSlotsResponseFromJson(jsonString);

import 'dart:convert';

BookingSlotsResponse bookingSlotsResponseFromJson(String str) => BookingSlotsResponse.fromJson(json.decode(str));

String bookingSlotsResponseToJson(BookingSlotsResponse data) => json.encode(data.toJson());

class BookingSlotsResponse {
  final List<GetServiceBookingSlot> getServiceBookingSlots;

  BookingSlotsResponse({
    required this.getServiceBookingSlots,
  });

  factory BookingSlotsResponse.fromJson(Map<String, dynamic> json) => BookingSlotsResponse(
    getServiceBookingSlots: List<GetServiceBookingSlot>.from(json["getServiceBookingSlots"].map((x) => GetServiceBookingSlot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "getServiceBookingSlots": List<dynamic>.from(getServiceBookingSlots.map((x) => x.toJson())),
  };
}

class GetServiceBookingSlot {
  final DateTime start;
  final DateTime end;
  final bool available;

  GetServiceBookingSlot({
     required this.start,
    required this.end,
    required this.available,
  });

  factory GetServiceBookingSlot.fromJson(Map<String, dynamic> json) => GetServiceBookingSlot(
    start: DateTime.parse(json["start"]),
    end: DateTime.parse(json["end"]),
    available: json["available"],
  );

  Map<String, dynamic> toJson() => {
    "start": start.toIso8601String(),
    "end": end.toIso8601String(),
    "available": available,
  };
}
