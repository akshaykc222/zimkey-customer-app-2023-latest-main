// To parse this JSON data, do
//
//     final updateUserResponse = updateUserResponseFromJson(jsonString);

import 'dart:convert';

UpdateUserResponse updateUserResponseFromJson(String str) => UpdateUserResponse.fromJson(json.decode(str));

String updateUserResponseToJson(UpdateUserResponse data) => json.encode(data.toJson());

class UpdateUserResponse {
  final UpdateUser updateUser;

  UpdateUserResponse({
    required this.updateUser,
  });

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) => UpdateUserResponse(
    updateUser: UpdateUser.fromJson(json["updateUser"]),
  );

  Map<String, dynamic> toJson() => {
    "updateUser": updateUser.toJson(),
  };
}

class UpdateUser {
  final String name;
  final String email;
  final String phone;
  final String id;

  UpdateUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.id,
  });

  factory UpdateUser.fromJson(Map<String, dynamic> json) => UpdateUser(
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "id": id,
  };
}
