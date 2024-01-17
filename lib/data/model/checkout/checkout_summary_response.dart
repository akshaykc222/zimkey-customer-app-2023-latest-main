// To parse this JSON data, do
//
//     final checkoutSummaryResponse = checkoutSummaryResponseFromJson(jsonString);

import 'dart:convert';

CheckoutSummaryResponse checkoutSummaryResponseFromJson(String str) => CheckoutSummaryResponse.fromJson(json.decode(str));

String checkoutSummaryResponseToJson(CheckoutSummaryResponse data) => json.encode(data.toJson());

class CheckoutSummaryResponse {
  final GetBookingSummary getBookingSummary;

  CheckoutSummaryResponse({
    required this.getBookingSummary,
  });

  factory CheckoutSummaryResponse.fromJson(Map<String, dynamic> json) => CheckoutSummaryResponse(
    getBookingSummary: GetBookingSummary.fromJson(json["getBookingSummary"]),
  );

  Map<String, dynamic> toJson() => {
    "getBookingSummary": getBookingSummary.toJson(),
  };
}

class GetBookingSummary {
  final double partnerRate;
  final double partnerDiscount;
  final double partnerAmount;
  final double partnerGstPercentage;
  final double partnerGstAmount;
  final double totalPartnerAmount;
  final double subTotal;
  final double totalDiscount;
  final double totalAmount;
  final double totalGstAmount;
  final double grandTotal;
  final double appliedZpoints;
  final int maxReedeemablePoints;
  final dynamic totalRefundable;
  final dynamic totalRefunded;
  final String cancellationPolicyCustomer;
  final String message;
  final String appliedCoupon;
  final List<Coupon> coupons;
  final bool isZpointsApplied;
  final bool couponEntered;
  final bool zpointsEntered;
  final bool redeemError;
  final bool isCouponApplied;
  final int zpointsBalance;

  GetBookingSummary({
    required this.partnerRate,
    required this.partnerDiscount,
    required this.partnerAmount,
    required this.partnerGstPercentage,
    required this.partnerGstAmount,
    required this.totalPartnerAmount,
    required this.subTotal,
    required this.totalDiscount,
    required this.totalAmount,
    required this.totalGstAmount,
    required this.grandTotal,
    required this.appliedZpoints,
    required this.totalRefundable,
    required this.totalRefunded,
    required this.cancellationPolicyCustomer,
    required this.coupons,
    required this.isZpointsApplied,
    required this.couponEntered,
    required this.zpointsEntered,
    required this.redeemError,
    required this.isCouponApplied,
    required this.message,
    required this.appliedCoupon,
    required this.zpointsBalance,
    required this.maxReedeemablePoints,
  });

  factory GetBookingSummary.fromJson(Map<String, dynamic> json) => GetBookingSummary(
    partnerRate: json["partnerRate"]?.toDouble(),
    partnerDiscount: json["partnerDiscount"]?.toDouble(),
    partnerAmount: json["partnerAmount"]?.toDouble(),
    partnerGstPercentage: json["partnerGSTPercentage"]?.toDouble(),
    partnerGstAmount: json["partnerGSTAmount"]?.toDouble(),
    totalPartnerAmount: json["totalPartnerAmount"]?.toDouble(),
    subTotal: json["subTotal"]?.toDouble(),
    totalDiscount: json["totalDiscount"]?.toDouble(),
    totalAmount: json["totalAmount"]?.toDouble(),
    totalGstAmount: json["totalGSTAmount"]?.toDouble(),
    grandTotal: json["grandTotal"]?.toDouble(),
    appliedZpoints: json["appliedZpoints"]?.toDouble(),
    totalRefundable: json["totalRefundable"]?.toDouble(),
    totalRefunded: json["totalRefunded"]?.toDouble(),
    cancellationPolicyCustomer: json["cancellationPolicyCustomer"],
    coupons: List<Coupon>.from(json["coupons"].map((x) => Coupon.fromJson(x))),
    isZpointsApplied: json["isZpointsApplied"],
    couponEntered: json["couponEntered"],
    zpointsEntered: json["zpointsEntered"],
    redeemError: json["redeemError"],
    message: json["message"],
    appliedCoupon: json["appliedCoupon"],
    zpointsBalance: json["zpointsBalance"],
    isCouponApplied: json["isCouponApplied"],
    maxReedeemablePoints: json["maxReedeemablePoints"],
  );

  Map<String, dynamic> toJson() => {
    "partnerRate": partnerRate,
    "partnerDiscount": partnerDiscount,
    "partnerAmount": partnerAmount,
    "partnerGSTPercentage": partnerGstPercentage,
    "partnerGSTAmount": partnerGstAmount,
    "totalPartnerAmount": totalPartnerAmount,
    "subTotal": subTotal,
    "totalDiscount": totalDiscount,
    "totalAmount": totalAmount,
    "totalGSTAmount": totalGstAmount,
    "grandTotal": grandTotal,
    "appliedZpoints": appliedZpoints,
    "totalRefundable": totalRefundable,
    "totalRefunded": totalRefunded,
    "cancellationPolicyCustomer": cancellationPolicyCustomer,
    "coupons": List<dynamic>.from(coupons.map((x) => x.toJson())),
    "isZpointsApplied": isZpointsApplied,
    "couponEntered": couponEntered,
    "zpointsEntered": zpointsEntered,
    "redeemError": redeemError,
    "message": message,
    "appliedCoupon": appliedCoupon,
    "zpointsBalance": zpointsBalance,
    "isCouponApplied": isCouponApplied,
    "maxReedeemablePoints": maxReedeemablePoints,
  };
}
class Coupon {
  final String id;
  final String code;
  final String description;
  final String name;
  final String terms;
  final String minOrder;
  final bool canApply;
  final bool couponApplied;
  bool showTerms;

  Coupon({
    required this.id,
    required this.code,
    required this.description,
    required this.name,
    required this.terms,
    required this.minOrder,
    required this.canApply,
    required this.couponApplied,
    this.showTerms = false,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    id: json["id"],
    code: json["code"],
    description: json["description"],
    name: json["name"],
    terms: json["terms"],
    minOrder: json["minOrder"],
    canApply: json["canApply"],
    couponApplied: json["couponApplied"],
    showTerms: json["showTerms"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "description": description,
    "name": name,
    "terms": terms,
    "minOrder": minOrder,
    "canApply": canApply,
    "couponApplied": couponApplied,
    "showTerms": showTerms,
  };
}

