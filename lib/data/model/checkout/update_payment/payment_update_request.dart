// To parse this JSON data, do
//
//     final paymentConfirmGqlInput = paymentConfirmGqlInputFromJson(jsonString);

import 'dart:convert';

PaymentConfirmGqlInput paymentConfirmGqlInputFromJson(String str) => PaymentConfirmGqlInput.fromJson(json.decode(str));

String paymentConfirmGqlInputToJson(PaymentConfirmGqlInput data) => json.encode(data.toJson());

class PaymentConfirmGqlInput {
  final String bookingPaymentId;
  final String paymentId;
  final String signature;

  PaymentConfirmGqlInput({
    required this.bookingPaymentId,
    required this.paymentId,
    required this.signature,
  });

  factory PaymentConfirmGqlInput.fromJson(Map<String, dynamic> json) => PaymentConfirmGqlInput(
    bookingPaymentId: json["bookingPaymentId"],
    paymentId: json["paymentId"],
    signature: json["signature"],
  );

  Map<String, dynamic> toJson() => {
    "bookingPaymentId": bookingPaymentId,
    "paymentId": paymentId,
    "signature": signature,
  };
}
