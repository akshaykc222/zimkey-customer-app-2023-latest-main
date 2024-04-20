// To parse this JSON data, do
//
//     final paymentUpdatedResponse = paymentUpdatedResponseFromJson(jsonString);

import 'dart:convert';

import '../../home/home_response.dart';

PaymentUpdatedResponse paymentUpdatedResponseFromJson(String str) => PaymentUpdatedResponse.fromJson(json.decode(str));

String paymentUpdatedResponseToJson(PaymentUpdatedResponse data) => json.encode(data.toJson());

class PaymentUpdatedResponse {
  final ConfirmPayment confirmPayment;

  PaymentUpdatedResponse({
    required this.confirmPayment,
  });

  factory PaymentUpdatedResponse.fromJson(Map<String, dynamic> json) => PaymentUpdatedResponse(
    confirmPayment: ConfirmPayment.fromJson(json["confirmPayment"]),
  );

  Map<String, dynamic> toJson() => {
    "confirmPayment": confirmPayment.toJson(),
  };
}

class ConfirmPayment {
  final bool paymentSuccess;
  final Booking booking;
  final dynamic zpointsEarned;
  final List<GetPopularService>? getPopularServices;

  ConfirmPayment({
    required this.paymentSuccess,
    required this.booking,
    required this.zpointsEarned,
    this.getPopularServices
  });

  factory ConfirmPayment.fromJson(Map<String, dynamic> json) => ConfirmPayment(
    paymentSuccess: json["paymentSuccess"],
    booking: Booking.fromJson(json["booking"]),
    zpointsEarned: json["zpointsEarned"],
    getPopularServices: json["popularServices"] == null ? [] : List<GetPopularService>.from(json["popularServices"]!.map((x) => GetPopularService.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "paymentSuccess": paymentSuccess,
    "booking": booking.toJson(),
    "zpointsEarned": zpointsEarned,
    "popularServices": getPopularServices == null ? [] : List<dynamic>.from(getPopularServices!.map((x) => x.toJson())),
  };
}

class Booking {
  final String id;
  final String userBookingNumber;
  final String bookingStatus;
  final BookingService bookingService;
  final BookingAddress bookingAddress;
  final BookingAmount bookingAmount;
  final List<BookingPayment> bookingPayments;
  final DateTime bookingDate;
  final dynamic pendingAmount;
  final String bookingNote;
  final User user;

  Booking({
    required this.id,
    required this.userBookingNumber,
    required this.bookingStatus,
    required this.bookingService,
    required this.bookingAddress,
    required this.bookingAmount,
    required this.bookingPayments,
    required this.bookingDate,
    required this.pendingAmount,
    required this.bookingNote,
    required this.user,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"],
    userBookingNumber: json["userBookingNumber"],
    bookingStatus: json["bookingStatus"],
    bookingService: BookingService.fromJson(json["bookingService"]),
    bookingAddress: BookingAddress.fromJson(json["bookingAddress"]),
    bookingAmount: BookingAmount.fromJson(json["bookingAmount"]),
    bookingPayments: List<BookingPayment>.from(json["bookingPayments"].map((x) => BookingPayment.fromJson(x))),
    bookingDate: DateTime.parse(json["bookingDate"]),
    pendingAmount: json["pendingAmount"],
    bookingNote: json["bookingNote"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userBookingNumber": userBookingNumber,
    "bookingStatus": bookingStatus,
    "bookingService": bookingService.toJson(),
    "bookingAddress": bookingAddress.toJson(),
    "bookingAmount": bookingAmount.toJson(),
    "bookingPayments": List<dynamic>.from(bookingPayments.map((x) => x.toJson())),
    "bookingDate": bookingDate.toIso8601String(),
    "pendingAmount": pendingAmount,
    "bookingNote": bookingNote,
    "user": user.toJson(),
  };
}

class BookingAddress {
  final String buildingName;
  final String postalCode;
  final String areaId;
  final String locality;
  final String addressType;
  final String landmark;
  final Area area;
  final dynamic otherText;
  final dynamic alternatePhoneNumber;

  BookingAddress({
    required this.buildingName,
    required this.postalCode,
    required this.areaId,
    required this.locality,
    required this.addressType,
    required this.landmark,
    required this.area,
    required this.otherText,
    required this.alternatePhoneNumber,
  });

  factory BookingAddress.fromJson(Map<String, dynamic> json) => BookingAddress(
    buildingName: json["buildingName"],
    postalCode: json["postalCode"],
    areaId: json["areaId"],
    locality: json["locality"],
    addressType: json["addressType"],
    landmark: json["landmark"],
    area: Area.fromJson(json["area"]),
    otherText: json["otherText"],
    alternatePhoneNumber: json["alternatePhoneNumber"],
  );

  Map<String, dynamic> toJson() => {
    "buildingName": buildingName,
    "postalCode": postalCode,
    "areaId": areaId,
    "locality": locality,
    "addressType": addressType,
    "landmark": landmark,
    "area": area.toJson(),
    "otherText": otherText,
    "alternatePhoneNumber": alternatePhoneNumber,
  };
}

class Area {
  final String name;
  final String code;
  final List<PinCode> pinCodes;
  final City city;

  Area({
    required this.name,
    required this.code,
    required this.pinCodes,
    required this.city,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    name: json["name"],
    code: json["code"],
    pinCodes: List<PinCode>.from(json["pinCodes"].map((x) => PinCode.fromJson(x))),
    city: City.fromJson(json["city"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "pinCodes": List<dynamic>.from(pinCodes.map((x) => x.toJson())),
    "city": city.toJson(),
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

class PinCode {
  final String pinCode;

  PinCode({
    required this.pinCode,
  });

  factory PinCode.fromJson(Map<String, dynamic> json) => PinCode(
    pinCode: json["pinCode"],
  );

  Map<String, dynamic> toJson() => {
    "pinCode": pinCode,
  };
}

class BookingAmount {
  final dynamic unitPrice;
  final int partnerRate;
  final int partnerDiscount;
  final int partnerAmount;
  final double subTotal;
  final dynamic totalDiscount;
  final double totalAmount;
  final double totalGstAmount;
  final int grandTotal;

  BookingAmount({
    required this.unitPrice,
    required this.partnerRate,
    required this.partnerDiscount,
    required this.partnerAmount,

    required this.subTotal,
    required this.totalDiscount,
    required this.totalAmount,
    required this.totalGstAmount,
    required this.grandTotal,
  });

  factory BookingAmount.fromJson(Map<String, dynamic> json) => BookingAmount(
    unitPrice: json["unitPrice"],
    partnerRate: json["partnerRate"],
    partnerDiscount: json["partnerDiscount"],
    partnerAmount: json["partnerAmount"],

    subTotal: json["subTotal"]?.toDouble(),
    totalDiscount: json["totalDiscount"],
    totalAmount: json["totalAmount"]?.toDouble(),
    totalGstAmount: json["totalGSTAmount"]?.toDouble(),
    grandTotal: json["grandTotal"],
  );

  Map<String, dynamic> toJson() => {
    "unitPrice": unitPrice,
    "partnerRate": partnerRate,
    "partnerDiscount": partnerDiscount,
    "partnerAmount": partnerAmount,

    "subTotal": subTotal,
    "totalDiscount": totalDiscount,
    "totalAmount": totalAmount,
    "totalGSTAmount": totalGstAmount,
    "grandTotal": grandTotal,
  };
}

class BookingPayment {
  final String id;
  final String orderId;
  final String paymentId;
  final int amount;
  final int amountPaid;
  final int amountDue;
  final String currency;
  final String status;
  final int attempts;
  final int invoiceNumber;
  final String bookingId;

  BookingPayment({
    required this.id,
    required this.orderId,
    required this.paymentId,
    required this.amount,
    required this.amountPaid,
    required this.amountDue,
    required this.currency,
    required this.status,
    required this.attempts,
    required this.invoiceNumber,
    required this.bookingId,
  });

  factory BookingPayment.fromJson(Map<String, dynamic> json) => BookingPayment(
    id: json["id"],
    orderId: json["orderId"],
    paymentId: json["paymentId"],
    amount: json["amount"],
    amountPaid: json["amountPaid"],
    amountDue: json["amountDue"],
    currency: json["currency"],
    status: json["status"],
    attempts: json["attempts"],
    invoiceNumber: json["invoiceNumber"],
    bookingId: json["bookingId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "paymentId": paymentId,
    "amount": amount,
    "amountPaid": amountPaid,
    "amountDue": amountDue,
    "currency": currency,
    "status": status,
    "attempts": attempts,
    "invoiceNumber": invoiceNumber,
    "bookingId": bookingId,
  };
}

class BookingService {
  final String unit;
  final Service service;
  final List<dynamic> serviceRequirements;
  final List<BookingServiceItem> bookingServiceItems;

  BookingService({
    required this.unit,
    required this.service,
    required this.serviceRequirements,
    required this.bookingServiceItems,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) => BookingService(
    unit: json["unit"],
    service: Service.fromJson(json["service"]),
    serviceRequirements: List<dynamic>.from(json["serviceRequirements"].map((x) => x)),
    bookingServiceItems: List<BookingServiceItem>.from(json["bookingServiceItems"].map((x) => BookingServiceItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "unit": unit,
    "service": service.toJson(),
    "serviceRequirements": List<dynamic>.from(serviceRequirements.map((x) => x)),
    "bookingServiceItems": List<dynamic>.from(bookingServiceItems.map((x) => x.toJson())),
  };
}

class BookingServiceItem {
  final String? workCode;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String bookingServiceItemStatus;
  final String bookingServiceItemType;
  final String id;

  BookingServiceItem({
    this.workCode,
    required this.startDateTime,
    required this.endDateTime,
    required this.bookingServiceItemStatus,
    required this.bookingServiceItemType,
    required this.id,
  });

  factory BookingServiceItem.fromJson(Map<String, dynamic> json) => BookingServiceItem(
    startDateTime: DateTime.parse(json["startDateTime"]),
    workCode: json['workCode'],
    endDateTime: DateTime.parse(json["endDateTime"]),
    bookingServiceItemStatus: json["bookingServiceItemStatus"],
    bookingServiceItemType: json["bookingServiceItemType"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "startDateTime": startDateTime.toIso8601String(),
    "endDateTime": endDateTime.toIso8601String(),
    "bookingServiceItemStatus": bookingServiceItemStatus,
    "bookingServiceItemType": bookingServiceItemType,
    "id": id,
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

class User {
  final String email;
  final bool isActive;
  final dynamic os;
  final dynamic osVersion;

  User({
    required this.email,
    required this.isActive,
    required this.os,
    required this.osVersion,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json["email"],
    isActive: json["isActive"],
    os: json["os"],
    osVersion: json["os_version"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "isActive": isActive,
    "os": os,
    "os_version": osVersion,
  };
}
