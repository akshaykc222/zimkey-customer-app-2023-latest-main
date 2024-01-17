// To parse this JSON data, do
//
//     final bookingCreatedResponse = bookingCreatedResponseFromJson(jsonString);

import 'dart:convert';

BookingCreatedResponse bookingCreatedResponseFromJson(String str) => BookingCreatedResponse.fromJson(json.decode(str));

String bookingCreatedResponseToJson(BookingCreatedResponse data) => json.encode(data.toJson());

class BookingCreatedResponse {
  final CreateBooking createBooking;

  BookingCreatedResponse({
    required this.createBooking,
  });

  factory BookingCreatedResponse.fromJson(Map<String, dynamic> json) => BookingCreatedResponse(
    createBooking: CreateBooking.fromJson(json["createBooking"]),
  );

  Map<String, dynamic> toJson() => {
    "createBooking": createBooking.toJson(),
  };
}

class CreateBooking {
  final String id;
  final String userBookingNumber;
  final String bookingStatus;
  final DateTime bookingDate;
  final String userId;
  final String bookingNote;
  final dynamic appliedCoupons;
  final DateTime createDateTime;
  final BookingAmount bookingAmount;
  final List<BookingPayments> bookingPayments;
  final BookingService bookingService;

  CreateBooking({
    required this.id,
    required this.userBookingNumber,
    required this.bookingStatus,
    required this.bookingDate,
    required this.userId,
    required this.bookingNote,
    required this.bookingPayments,
    this.appliedCoupons,
    required this.createDateTime,
    required this.bookingAmount,
    required this.bookingService,
  });

  factory CreateBooking.fromJson(Map<String, dynamic> json) => CreateBooking(
    id: json["id"],
    userBookingNumber: json["userBookingNumber"],
    bookingStatus: json["bookingStatus"],
    bookingDate: DateTime.parse(json["bookingDate"]),
    userId: json["userId"],
    bookingNote: json["bookingNote"],
    appliedCoupons: json["appliedCoupons"],
    createDateTime: DateTime.parse(json["createDateTime"]),
    bookingAmount: BookingAmount.fromJson(json["bookingAmount"]),
    bookingService: BookingService.fromJson(json["bookingService"]),
    bookingPayments:List<BookingPayments>.from(json["bookingPayments"].map((x) => BookingPayments.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userBookingNumber": userBookingNumber,
    "bookingStatus": bookingStatus,
    "bookingDate": bookingDate.toIso8601String(),
    "userId": userId,
    "bookingNote": bookingNote,
    "appliedCoupons": appliedCoupons,
    "createDateTime": createDateTime.toIso8601String(),
    "bookingAmount": bookingAmount.toJson(),
    "bookingService": bookingService.toJson(),
    "bookingPayments": List<dynamic>.from(bookingPayments.map((x) => x.toJson())),

  };
}

class BookingAmount {
  final int grandTotal;

  BookingAmount({
    required this.grandTotal,
  });

  factory BookingAmount.fromJson(Map<String, dynamic> json) => BookingAmount(
    grandTotal: json["grandTotal"],
  );

  Map<String, dynamic> toJson() => {
    "grandTotal": grandTotal,
  };
}

class BookingService {
  final Service service;
  final List<BookingServiceItem> bookingServiceItems;

  BookingService({
    required this.service,
    required this.bookingServiceItems
  });

  factory BookingService.fromJson(Map<String, dynamic> json) => BookingService(
    service: Service.fromJson(json["service"]),
    bookingServiceItems: List<BookingServiceItem>.from(json["bookingServiceItems"].map((x) => BookingServiceItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "service": service.toJson(),
    "bookingServiceItems": List<dynamic>.from(bookingServiceItems.map((x) => x.toJson())),

  };
}

class BookingServiceItem {
  final String id;

  BookingServiceItem({

    required this.id,
  });

  factory BookingServiceItem.fromJson(Map<String, dynamic> json) => BookingServiceItem(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}
class BookingPayments {
  final String id;
  final String orderId;

  BookingPayments({
    required this.id,
    required this.orderId,
  });

  factory BookingPayments.fromJson(Map<String, dynamic> json) => BookingPayments(
    id: json["id"],
    orderId: json["orderId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
  };
}

class Service {
  final String name;

  Service({
    required this.name,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
