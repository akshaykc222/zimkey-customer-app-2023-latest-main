// To parse this JSON data, do
//
//     final pendingPaymentResponse = pendingPaymentResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PendingPaymentResponse pendingPaymentResponseFromJson(String str) => PendingPaymentResponse.fromJson(json.decode(str));

String pendingPaymentResponseToJson(PendingPaymentResponse data) => json.encode(data.toJson());

class PendingPaymentResponse {
  final CreatePendingPaymentOrder createPendingPaymentOrder;

  PendingPaymentResponse({
    required this.createPendingPaymentOrder,
  });

  factory PendingPaymentResponse.fromJson(Map<String, dynamic> json) => PendingPaymentResponse(
    createPendingPaymentOrder: CreatePendingPaymentOrder.fromJson(json["createPendingPaymentOrder"]),
  );

  Map<String, dynamic> toJson() => {
    "createPendingPaymentOrder": createPendingPaymentOrder.toJson(),
  };
}

class CreatePendingPaymentOrder {
  final String id;
  final String orderId;
  final dynamic paymentId;
  final int amount;
  final int amountPaid;
  final int amountDue;
  final String currency;
  final String status;
  final int attempts;
  final int invoiceNumber;
  final String bookingId;

  CreatePendingPaymentOrder({
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

  factory CreatePendingPaymentOrder.fromJson(Map<String, dynamic> json) => CreatePendingPaymentOrder(
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
