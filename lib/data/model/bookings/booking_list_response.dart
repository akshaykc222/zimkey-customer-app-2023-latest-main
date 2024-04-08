// To parse this JSON data, do
//
//     final bookingListResponse = bookingListResponseFromJson(jsonString);

import 'dart:convert';

BookingListResponse bookingListResponseFromJson(String str) =>
    BookingListResponse.fromJson(json.decode(str));

String bookingListResponseToJson(BookingListResponse data) =>
    json.encode(data.toJson());

class BookingListResponse {
  final GetUserBookingServiceItems getUserBookingServiceItems;

  BookingListResponse({
    required this.getUserBookingServiceItems,
  });

  factory BookingListResponse.fromJson(Map<String, dynamic> json) =>
      BookingListResponse(
        getUserBookingServiceItems: GetUserBookingServiceItems.fromJson(
            json["getUserBookingServiceItems"]),
      );

  Map<String, dynamic> toJson() => {
        "getUserBookingServiceItems": getUserBookingServiceItems.toJson(),
      };
}

class GetUserBookingServiceItems {
  final List<Datum> data;
  final PageInfo pageInfo;

  GetUserBookingServiceItems({
    required this.data,
    required this.pageInfo,
  });

  factory GetUserBookingServiceItems.fromJson(Map<String, dynamic> json) =>
      GetUserBookingServiceItems(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        pageInfo: PageInfo.fromJson(json["pageInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pageInfo": pageInfo.toJson(),
      };
}

class Datum {
  final String id;
  final String bookingServiceItemStatus;
  final BookingService bookingService;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String bookingServiceItemType;

  Datum(
      {required this.id,
      required this.bookingServiceItemStatus,
      required this.bookingService,
      required this.startDateTime,
      required this.endDateTime,
      required this.bookingServiceItemType});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        bookingServiceItemStatus: json["bookingServiceItemStatus"],
        bookingService: BookingService.fromJson(json["bookingService"]),
        startDateTime: DateTime.parse(json["startDateTime"]),
        endDateTime: DateTime.parse(json["endDateTime"]),
        bookingServiceItemType: json['bookingServiceItemType'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bookingServiceItemStatus": bookingServiceItemStatus,
        "bookingService": bookingService.toJson(),
        "startDateTime": startDateTime.toIso8601String(),
        "endDateTime": endDateTime.toIso8601String(),
      };
}

class BookingService {
  final Service service;
  final String serviceBillingOptionId;
  final Booking booking;
  final String unit;

  BookingService({
    required this.service,
    required this.serviceBillingOptionId,
    required this.booking,
    required this.unit,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) => BookingService(
        service: Service.fromJson(json["service"]),
        serviceBillingOptionId: json["serviceBillingOptionId"],
        booking: Booking.fromJson(json["booking"]),
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "service": service.toJson(),
        "serviceBillingOptionId": serviceBillingOptionId,
        "booking": booking.toJson(),
        "unit": unit,
      };
}

class Booking {
  final String userBookingNumber;

  Booking({
    required this.userBookingNumber,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        userBookingNumber: json["userBookingNumber"],
      );

  Map<String, dynamic> toJson() => {
        "userBookingNumber": userBookingNumber,
      };
}

class Service {
  final String id;
  final String name;
  final Icon icon;

  Service({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id'],
        name: json["name"],
        icon: Icon.fromJson(json["icon"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "icon": icon.toJson(),
      };
}

class Icon {
  final String url;

  Icon({
    required this.url,
  });

  factory Icon.fromJson(Map<String, dynamic> json) => Icon(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}

class PageInfo {
  final bool hasNextPage;
  final int currentPage;
  final int currentCount;
  final dynamic nextPage;
  final int totalPage;
  final int totalCount;

  PageInfo({
    required this.hasNextPage,
    required this.currentPage,
    required this.currentCount,
    required this.nextPage,
    required this.totalPage,
    required this.totalCount,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        hasNextPage: json["hasNextPage"],
        currentPage: json["currentPage"],
        currentCount: json["currentCount"],
        nextPage: json["nextPage"] ?? 0,
        totalPage: json["totalPage"],
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "hasNextPage": hasNextPage,
        "currentPage": currentPage,
        "currentCount": currentCount,
        "nextPage": nextPage,
        "totalPage": totalPage,
        "totalCount": totalCount,
      };
}
