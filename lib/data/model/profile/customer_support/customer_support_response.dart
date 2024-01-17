// To parse this JSON data, do
//
//     final customerSupportResponse = customerSupportResponseFromJson(jsonString);

import 'dart:convert';

CustomerSupportResponse customerSupportResponseFromJson(String str) => CustomerSupportResponse.fromJson(json.decode(str));

String customerSupportResponseToJson(CustomerSupportResponse data) => json.encode(data.toJson());

class CustomerSupportResponse {
  final AddCustomerSupport addCustomerSupport;

  CustomerSupportResponse({
    required this.addCustomerSupport,
  });

  factory CustomerSupportResponse.fromJson(Map<String, dynamic> json) => CustomerSupportResponse(
    addCustomerSupport: AddCustomerSupport.fromJson(json["addCustomerSupport"]),
  );

  Map<String, dynamic> toJson() => {
    "addCustomerSupport": addCustomerSupport.toJson(),
  };
}

class AddCustomerSupport {
  final String id;
  final String userId;
  final String subject;
  final String message;
  final DateTime createDateTime;

  AddCustomerSupport({
    required this.id,
    required this.userId,
    required this.subject,
    required this.message,
    required this.createDateTime,
  });

  factory AddCustomerSupport.fromJson(Map<String, dynamic> json) => AddCustomerSupport(
    id: json["id"],
    userId: json["userId"],
    subject: json["subject"],
    message: json["message"],
    createDateTime: DateTime.parse(json["createDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "subject": subject,
    "message": message,
    "createDateTime": createDateTime.toIso8601String(),
  };
}
