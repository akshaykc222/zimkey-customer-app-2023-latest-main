// To parse this JSON data, do
//
//     final registerUserResponse = registerUserResponseFromJson(jsonString);

import 'dart:convert';

import 'verify_otp_response.dart';

RegisterUserResponse registerUserResponseFromJson(String str) => RegisterUserResponse.fromJson(json.decode(str));

String registerUserResponseToJson(RegisterUserResponse data) => json.encode(data.toJson());

class RegisterUserResponse {
  final User registerUser;

  RegisterUserResponse({
    required this.registerUser,
  });

  factory RegisterUserResponse.fromJson(Map<String, dynamic> json) => RegisterUserResponse(
    registerUser: User.fromJson(json["registerUser"]),
  );

  Map<String, dynamic> toJson() => {
    "registerUser": registerUser.toJson(),
  };
}

class RegisterUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  RegisterUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) => RegisterUser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
  };
}
