// To parse this JSON data, do
//
//     final userDetailsResponse = userDetailsResponseFromJson(jsonString);

import 'dart:convert';

import '../../../ui/service_categories/model/service_category_response.dart';

UserDetailsResponse userDetailsResponseFromJson(String str) => UserDetailsResponse.fromJson(json.decode(str));

String userDetailsResponseToJson(UserDetailsResponse data) => json.encode(data.toJson());

class UserDetailsResponse {
  final Me me;

  UserDetailsResponse({
    required this.me,
  });

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) => UserDetailsResponse(
    me: Me.fromJson(json["me"]),
  );

  Map<String, dynamic> toJson() => {
    "me": me.toJson(),
  };
}

class Me {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String zpointsDescription;
  final Analytics analytics;
  final CustomerDetails customerDetails;

  Me({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.zpointsDescription,
    required this.analytics,
    required this.customerDetails,
  });

  factory Me.fromJson(Map<String, dynamic> json) => Me(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    zpointsDescription: json["zpointsDescription"],
    analytics: Analytics.fromJson(json["analytics"]),
    customerDetails: CustomerDetails.fromJson(json["customerDetails"]),


  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "zpointsDescription": zpointsDescription,
    "analytics": analytics.toJson(),
    "customerDetails": customerDetails.toJson(),
  };
}

class Analytics {
  final String openBookings;
  final dynamic rewardPointBalance;
  final dynamic totalBookings;
  final String pendingPaymentsCounts;

  Analytics({
    required this.openBookings,
    required this.rewardPointBalance,
    required this.totalBookings,
    required this.pendingPaymentsCounts,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) => Analytics(
    openBookings: json["openBookings"],
    rewardPointBalance: json["rewardPointBalance"],
    totalBookings: json["totalBookings"],
    pendingPaymentsCounts: json["pendingPaymentsCounts"],
  );

  Map<String, dynamic> toJson() => {
    "openBookings": openBookings,
    "rewardPointBalance": rewardPointBalance,
    "totalBookings": totalBookings,
    "pendingPaymentsCounts": pendingPaymentsCounts,
  };
}
class CustomerDetails {
  final List<Service> favoriteServices;

  CustomerDetails({
    required this.favoriteServices,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) => CustomerDetails(
    favoriteServices: List<Service>.from(json["favoriteServices"].map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "favoriteServices": List<dynamic>.from(favoriteServices.map((x) => x.toJson())),
  };
}

// class FavoriteService {
//   final String id;
//   final String name;
//   final bool isFavorite;
//
//   FavoriteService({
//     required this.id,
//     required this.name,
//     required this.isFavorite,
//   });
//
//   factory FavoriteService.fromJson(Map<String, dynamic> json) => FavoriteService(
//     id: json["id"],
//     name: json["name"],
//     isFavorite: json["isFavorite"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "isFavorite": isFavorite,
//   };
// }
