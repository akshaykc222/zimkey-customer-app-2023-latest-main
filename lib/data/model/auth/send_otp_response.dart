// To parse this JSON data, do
//
//     final sendOtpResponse = sendOtpResponseFromJson(jsonString);

import 'dart:convert';

SendOtpResponse sendOtpResponseFromJson(String str) => SendOtpResponse.fromJson(json.decode(str));

String sendOtpResponseToJson(SendOtpResponse data) => json.encode(data.toJson());

class SendOtpResponse {
  final SendOtp? sendOtp;

  SendOtpResponse({
    this.sendOtp,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) => SendOtpResponse(
    sendOtp: json["sendOtp"] == null ? null : SendOtp.fromJson(json["sendOtp"]),
  );

  Map<String, dynamic> toJson() => {
    "sendOtp": sendOtp?.toJson(),
  };
}

class SendOtp {
  final bool? status;
  final String? message;

  SendOtp({
    this.status,
    this.message,
  });

  factory SendOtp.fromJson(Map<String, dynamic> json) => SendOtp(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
