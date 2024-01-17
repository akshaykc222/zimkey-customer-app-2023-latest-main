// To parse this JSON data, do
//
//     final singleBookingDetailResponse = singleBookingDetailResponseFromJson(jsonString);

import 'dart:convert';

import '../../../data/model/services/single_service_response.dart';

SingleBookingDetailResponse singleBookingDetailResponseFromJson(String str) =>
    SingleBookingDetailResponse.fromJson(json.decode(str));

String singleBookingDetailResponseToJson(SingleBookingDetailResponse data) =>
    json.encode(data.toJson());

class SingleBookingDetailResponse {
  final GetBookingServiceItem getBookingServiceItem;

  SingleBookingDetailResponse({
    required this.getBookingServiceItem,
  });

  factory SingleBookingDetailResponse.fromJson(Map<String, dynamic> json) =>
      SingleBookingDetailResponse(
        getBookingServiceItem:
            GetBookingServiceItem.fromJson(json["getBookingServiceItem"]),
      );

  Map<String, dynamic> toJson() => {
        "getBookingServiceItem": getBookingServiceItem.toJson(),
      };
}

class GetBookingServiceItem {
  final BookingService bookingService;
  final String id;
  final String bookingServiceItemStatus;
  final dynamic amountDue;
  final String bookingServiceItemType;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final bool canReschedule;
  final bool canRework;
  final bool canCancel;
  final bool canCallPartner;
  final bool isCancelled;
  final bool canBookAgain;
  final bool canRateBooking;
  final bool isRescheduleByPartnerPending;
  final bool isPaymentPending;
  final ChargedPrice chargedPrice;
  final CancelDetails? cancelDetails;
  final PendingRescheduleByPartner? pendingRescheduleByPartner;
  final String cancellationPolicyCustomer;
  final List<StatusTracker> statusTracker;
  final List<AdditionalWork> additionalWorks;
  final String workCode;
  final PropertyArea? propertyArea;
  final PropertyType? propertyType;
  final Room? room;
  final bool? isFurnished;
  GetBookingServiceItem(
      {required this.bookingService,
      required this.id,
      required this.bookingServiceItemStatus,
      required this.amountDue,
      required this.bookingServiceItemType,
      required this.startDateTime,
      required this.endDateTime,
      required this.canReschedule,
      required this.canRework,
      required this.canCancel,
      required this.isPaymentPending,
      required this.canCallPartner,
      required this.isRescheduleByPartnerPending,
      required this.isCancelled,
      required this.canBookAgain,
      required this.canRateBooking,
      required this.chargedPrice,
      required this.cancelDetails,
      required this.pendingRescheduleByPartner,
      required this.cancellationPolicyCustomer,
      required this.statusTracker,
      required this.additionalWorks,
      required this.workCode,
      this.propertyArea,
      this.propertyType,
      this.room,
      this.isFurnished});

  factory GetBookingServiceItem.fromJson(Map<String, dynamic> json) =>
      GetBookingServiceItem(
          bookingService: BookingService.fromJson(json["bookingService"]),
          id: json["id"],
          bookingServiceItemStatus: json["bookingServiceItemStatus"],
          amountDue: json["amountDue"],
          bookingServiceItemType: json["bookingServiceItemType"],
          startDateTime: DateTime.parse(json["startDateTime"]),
          endDateTime: DateTime.parse(json["endDateTime"]),
          canReschedule: json["canReschedule"],
          canRework: json["canRework"],
          isRescheduleByPartnerPending: json["isRescheduleByPartnerPending"],
          canCancel: json["canCancel"],
          isPaymentPending: json["isPaymentPending"],
          canCallPartner: json["canCallPartner"],
          isCancelled: json["isCancelled"],
          canBookAgain: json["canBookAgain"],
          canRateBooking: json["canRateBooking"],
          chargedPrice: ChargedPrice.fromJson(json["chargedPrice"]),
          cancelDetails: json["cancelDetails"] == null
              ? null
              : CancelDetails.fromJson(json["cancelDetails"]),
          pendingRescheduleByPartner: json["pendingRescheduleByPartner"] == null
              ? null
              : PendingRescheduleByPartner.fromJson(
                  json["pendingRescheduleByPartner"]),
          cancellationPolicyCustomer: json["cancellationPolicyCustomer"],
          statusTracker: List<StatusTracker>.from(
              json["statusTracker"].map((x) => StatusTracker.fromJson(x))),
          additionalWorks: List<AdditionalWork>.from(
              json["additionalWorks"].map((x) => AdditionalWork.fromJson(x))),
          workCode: json["workCode"],
          room: json['serviceRoom'] == null
              ? null
              : Room.fromJson(json['serviceRoom']),
          propertyArea: json['servicePropertyArea'] == null
              ? null
              : PropertyArea.fromJson(json['servicePropertyArea']),
          propertyType: json['servicePropertyType'] == null
              ? null
              : PropertyType.fromJson(json['servicePropertyType']),
          isFurnished: json['isFurnished']);

  Map<String, dynamic> toJson() => {
        "bookingService": bookingService.toJson(),
        "id": id,
        "bookingServiceItemStatus": bookingServiceItemStatus,
        "amountDue": amountDue,
        "bookingServiceItemType": bookingServiceItemType,
        "startDateTime": startDateTime.toIso8601String(),
        "endDateTime": endDateTime.toIso8601String(),
        "canReschedule": canReschedule,
        "canRework": canRework,
        "canCancel": canCancel,
        "isRescheduleByPartnerPending": isRescheduleByPartnerPending,
        "canCallPartner": canCallPartner,
        "isCancelled": isCancelled,
        "isPaymentPending": isPaymentPending,
        "canBookAgain": canBookAgain,
        "canRateBooking": canRateBooking,
        "chargedPrice": chargedPrice.toJson(),
        "cancelDetails": cancelDetails!.toJson(),
        "pendingRescheduleByPartner": pendingRescheduleByPartner!.toJson(),
        "cancellationPolicyCustomer": cancellationPolicyCustomer,
        "statusTracker":
            List<dynamic>.from(statusTracker.map((x) => x.toJson())),
        "additionalWorks":
            List<dynamic>.from(additionalWorks.map((x) => x.toJson())),
        "workCode": workCode,
      };
}

class BookingService {
  final Service service;
  final Booking booking;
  final String serviceBillingOptionId;
  final String otherRequirements;
  final City serviceBillingOption;
  final List<dynamic> serviceRequirements;

  BookingService({
    required this.service,
    required this.booking,
    required this.serviceBillingOptionId,
    required this.otherRequirements,
    required this.serviceBillingOption,
    required this.serviceRequirements,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) => BookingService(
        service: Service.fromJson(json["service"]),
        booking: Booking.fromJson(json["booking"]),
        serviceBillingOptionId: json["serviceBillingOptionId"],
        otherRequirements: json["otherRequirements"],
        serviceBillingOption: City.fromJson(json["serviceBillingOption"]),
        serviceRequirements:
            List<dynamic>.from(json["serviceRequirements"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "service": service.toJson(),
        "booking": booking.toJson(),
        "serviceBillingOptionId": serviceBillingOptionId,
        "otherRequirements": otherRequirements,
        "serviceBillingOption": serviceBillingOption.toJson(),
        "serviceRequirements":
            List<dynamic>.from(serviceRequirements.map((x) => x)),
      };
}

class Booking {
  final String userBookingNumber;
  final BookingAddress bookingAddress;
  final String bookingNote;

  Booking({
    required this.userBookingNumber,
    required this.bookingAddress,
    required this.bookingNote,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        userBookingNumber: json["userBookingNumber"],
        bookingAddress: BookingAddress.fromJson(json["bookingAddress"]),
        bookingNote: json["bookingNote"],
      );

  Map<String, dynamic> toJson() => {
        "userBookingNumber": userBookingNumber,
        "bookingAddress": bookingAddress.toJson(),
        "bookingNote": bookingNote,
      };
}

class BookingAddress {
  final String addressType;
  final String otherText;
  final String buildingName;
  final String locality;
  final String landmark;
  final Area area;
  final String postalCode;
  final dynamic alternatePhoneNumber;

  BookingAddress({
    required this.addressType,
    required this.otherText,
    required this.buildingName,
    required this.locality,
    required this.landmark,
    required this.area,
    required this.postalCode,
    required this.alternatePhoneNumber,
  });

  factory BookingAddress.fromJson(Map<String, dynamic> json) => BookingAddress(
        addressType: json["addressType"],
        otherText: json["otherText"],
        buildingName: json["buildingName"],
        locality: json["locality"],
        landmark: json["landmark"],
        area: Area.fromJson(json["area"]),
        postalCode: json["postalCode"],
        alternatePhoneNumber: json["alternatePhoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "addressType": addressType,
        "otherText": otherText,
        "buildingName": buildingName,
        "locality": locality,
        "landmark": landmark,
        "area": area.toJson(),
        "postalCode": postalCode,
        "alternatePhoneNumber": alternatePhoneNumber,
      };
}

class Area {
  final String name;
  final City city;

  Area({
    required this.name,
    required this.city,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        name: json["name"],
        city: City.fromJson(json["city"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "city": city.toJson(),
      };
}

class PendingRescheduleByPartner {
  final DateTime startDateTime;
  final DateTime endDateTime;

  PendingRescheduleByPartner({
    required this.startDateTime,
    required this.endDateTime,
  });

  factory PendingRescheduleByPartner.fromJson(Map<String, dynamic> json) =>
      PendingRescheduleByPartner(
        startDateTime: DateTime.parse(json["startDateTime"]),
        endDateTime: DateTime.parse(json["endDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "startDateTime": startDateTime.toIso8601String(),
        "endDateTime": endDateTime.toIso8601String(),
      };
}

class Service {
  final String id;
  final String name;
  final bool isFavorite;

  Service({
    required this.id,
    required this.name,
    required this.isFavorite,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        isFavorite: json["isFavorite"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isFavorite": isFavorite,
      };
}

class City {
  final String name;

  City({
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class ChargedPrice {
  final dynamic totalAmount;
  final dynamic subTotal;
  final dynamic totalDiscount;
  final dynamic totalGstAmount;
  final dynamic grandTotal;

  ChargedPrice({
    required this.totalAmount,
    required this.subTotal,
    required this.totalDiscount,
    required this.totalGstAmount,
    required this.grandTotal,
  });

  factory ChargedPrice.fromJson(Map<String, dynamic> json) => ChargedPrice(
        totalAmount: json["totalAmount"],
        subTotal: json["subTotal"],
        totalDiscount: json["totalDiscount"],
        totalGstAmount: json["totalGSTAmount"]?.toDouble(),
        grandTotal: json["grandTotal"],
      );

  Map<String, dynamic> toJson() => {
        "totalAmount": totalAmount,
        "subTotal": subTotal,
        "totalDiscount": totalDiscount,
        "totalGSTAmount": totalGstAmount,
        "grandTotal": grandTotal,
      };
}

class CancelDetails {
  final dynamic cancelAmount;
  final dynamic cancelTotalAmount;

  CancelDetails({
    required this.cancelAmount,
    required this.cancelTotalAmount,
  });

  factory CancelDetails.fromJson(Map<String, dynamic> json) => CancelDetails(
        cancelAmount: json["cancelAmount"],
        cancelTotalAmount: json["cancelTotalAmount"],
      );

  Map<String, dynamic> toJson() => {
        "cancelAmount": cancelAmount,
        "cancelTotalAmount": cancelTotalAmount,
      };
}

class StatusTracker {
  final String statusLabel;
  final bool statusValue;

  StatusTracker({
    required this.statusLabel,
    required this.statusValue,
  });

  factory StatusTracker.fromJson(Map<String, dynamic> json) => StatusTracker(
        statusLabel: json["status_label"],
        statusValue: json["status_value"],
      );

  Map<String, dynamic> toJson() => {
        "status_label": statusLabel,
        "status_value": statusValue,
      };
}

class AdditionalWork {
  final List<BookingAddon> bookingAddons;
  final int? additionalHoursUnits;
  final String bookingAdditionalWorkStatus;
  final bool isPaid;
  final Amount? additionalHoursAmount;
  final TotalAdditionalWorkAmount? totalAdditionalWorkAmount;

  AdditionalWork({
    required this.bookingAddons,
    this.additionalHoursUnits,
    required this.bookingAdditionalWorkStatus,
    required this.isPaid,
    this.additionalHoursAmount,
    this.totalAdditionalWorkAmount,
  });

  factory AdditionalWork.fromJson(Map<String, dynamic> json) => AdditionalWork(
        bookingAddons: json["bookingAddons"] == null
            ? []
            : List<BookingAddon>.from(
                json["bookingAddons"]!.map((x) => BookingAddon.fromJson(x))),
        additionalHoursUnits: json["additionalHoursUnits"] ?? 0,
        bookingAdditionalWorkStatus: json["bookingAdditionalWorkStatus"],
        isPaid: json["isPaid"],
        additionalHoursAmount: json["additionalHoursAmount"] == null
            ? null
            : Amount.fromJson(json["additionalHoursAmount"]),
        totalAdditionalWorkAmount: json["totalAdditionalWorkAmount"] == null
            ? null
            : TotalAdditionalWorkAmount.fromJson(
                json["totalAdditionalWorkAmount"]),
      );

  Map<String, dynamic> toJson() => {
        "bookingAddons":
            List<dynamic>.from(bookingAddons.map((x) => x.toJson())),
        "additionalHoursUnits": additionalHoursUnits,
        "bookingAdditionalWorkStatus": bookingAdditionalWorkStatus,
        "isPaid": isPaid,
        "additionalHoursAmount": additionalHoursAmount?.toJson(),
        "totalAdditionalWorkAmount": totalAdditionalWorkAmount?.toJson(),
      };
}

class Amount {
  final int? grandTotal;

  Amount({
    this.grandTotal,
  });

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
        grandTotal: json["grandTotal"],
      );

  Map<String, dynamic> toJson() => {
        "grandTotal": grandTotal,
      };
}

class TotalAdditionalWorkAmount {
  final int? grandTotal;

  TotalAdditionalWorkAmount({
    this.grandTotal,
  });

  factory TotalAdditionalWorkAmount.fromJson(Map<String, dynamic> json) =>
      TotalAdditionalWorkAmount(
        grandTotal: json["grandTotal"],
      );

  Map<String, dynamic> toJson() => {
        "grandTotal": grandTotal,
      };
}

class BookingAddon {
  final String name;
  final int units;
  final Amount amount;

  BookingAddon({
    required this.name,
    required this.units,
    required this.amount,
  });

  factory BookingAddon.fromJson(Map<String, dynamic> json) => BookingAddon(
        name: json["name"],
        units: json["units"],
        amount: Amount.fromJson(json["amount"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "units": units,
        "amount": amount.toJson(),
      };
}
