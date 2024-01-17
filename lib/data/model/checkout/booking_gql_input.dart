// To parse this JSON data, do
//
//     final bookingGqlInput = bookingGqlInputFromJson(jsonString);

import 'dart:convert';

BookingGqlInput bookingGqlInputFromJson(String str) =>
    BookingGqlInput.fromJson(json.decode(str));

String bookingGqlInputToJson(BookingGqlInput data) =>
    json.encode(data.toJson());

class BookingGqlInput {
  final String addressId;
  final String message;
  final Service service;
  final String couponCode;
  final String alternatePhoneNumber;
  final double redeemPoints;

  BookingGqlInput({
    required this.addressId,
    required this.message,
    required this.service,
    required this.couponCode,
    required this.alternatePhoneNumber,
    required this.redeemPoints,
  });

  factory BookingGqlInput.fromJson(Map<String, dynamic> json) =>
      BookingGqlInput(
        addressId: json["addressId"],
        message: json["message"],
        service: Service.fromJson(json["service"]),
        couponCode: json["couponCode"],
        alternatePhoneNumber: json["alternatePhoneNumber"],
        redeemPoints: json["redeemPoints"],
      );

  Map<String, dynamic> toJson() => {
        "addressId": addressId,
        "message": message,
        "service": service.toJson(),
        "couponCode": couponCode,
        "alternatePhoneNumber": alternatePhoneNumber,
        "redeemPoints": redeemPoints,
      };
}

class Service {
  final String serviceBillingOptionId;
  final String otherRequirements;
  final List<String> serviceRequirementIds;
  final int units;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String? servicePropertyTypeId;
  final String? serviceRoomId;
  final String? servicePropertyAreaId;
  final bool? isFurnished;

  Service({
    required this.serviceBillingOptionId,
    required this.units,
    required this.otherRequirements,
    required this.serviceRequirementIds,
    required this.startDateTime,
    required this.endDateTime,
    this.servicePropertyTypeId,
    this.serviceRoomId,
    this.servicePropertyAreaId,
    this.isFurnished,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        serviceBillingOptionId: json["serviceBillingOptionId"],
        otherRequirements: json["otherRequirements"],
        units: json["units"],
        serviceRequirementIds: json["serviceRequirementIds"],
        startDateTime: DateTime.parse(json["startDateTime"]),
        endDateTime: DateTime.parse(json["endDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "serviceBillingOptionId": serviceBillingOptionId,
        "units": units,
        "serviceRequirementIds": serviceRequirementIds,
        "otherRequirements": otherRequirements,
        "startDateTime": startDateTime.toIso8601String(),
        "endDateTime": endDateTime.toIso8601String(),
        "servicePropertyTypeId": servicePropertyTypeId,
        "serviceRoomId": serviceRoomId,
        "servicePropertyAreaId": servicePropertyAreaId,
        "isFurnished": isFurnished
      };
}
