// To parse this JSON data, do
//
//     final verifyOtpResponse = verifyOtpResponseFromJson(jsonString);

import 'dart:convert';

VerifyOtpResponse verifyOtpResponseFromJson(String str) =>
    VerifyOtpResponse.fromJson(json.decode(str));

String verifyOtpResponseToJson(VerifyOtpResponse data) =>
    json.encode(data.toJson());

class VerifyOtpResponse {
  final VerifyOtp verifyOtp;

  VerifyOtpResponse({
    required this.verifyOtp,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      VerifyOtpResponse(
        verifyOtp: VerifyOtp.fromJson(json["verifyOtp"]),
      );

  Map<String, dynamic> toJson() => {
        "verifyOtp": verifyOtp.toJson(),
      };
}

class VerifyOtp {
  final bool status;
  final String message;
  final Data data;

  VerifyOtp({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VerifyOtp.fromJson(Map<String, dynamic> json) => VerifyOtp(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  final bool isCustomerRegistered;
  final String token;
  final User user;

  Data({
    required this.isCustomerRegistered,
    required this.token,
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isCustomerRegistered: json["isCustomerRegistered"],
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "isCustomerRegistered": isCustomerRegistered,
        "token": token,
        "user": user.toJson(),
      };
}

class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final bool? disableAccount;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.disableAccount,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      disableAccount: json['disableAccount']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
      };
}
