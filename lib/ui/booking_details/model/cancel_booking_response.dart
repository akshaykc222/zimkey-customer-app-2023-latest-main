// To parse this JSON data, do
//
//     final singleBookingDetailResponse = singleBookingDetailResponseFromJson(jsonString);

import 'dart:convert';

import 'single_booking_details_response.dart';

CancelBookingDetailResponse singleBookingDetailResponseFromJson(String str) => CancelBookingDetailResponse.fromJson(json.decode(str));

String singleBookingDetailResponseToJson(CancelBookingDetailResponse data) => json.encode(data.toJson());

class CancelBookingDetailResponse {
  final GetBookingServiceItem getBookingServiceItem;

  CancelBookingDetailResponse({
    required this.getBookingServiceItem,
  });

  factory CancelBookingDetailResponse.fromJson(Map<String, dynamic> json) => CancelBookingDetailResponse(
    getBookingServiceItem: GetBookingServiceItem.fromJson(json["cancelJobs"]),
  );

  Map<String, dynamic> toJson() => {
    "cancelJobs": getBookingServiceItem.toJson(),
  };
}

