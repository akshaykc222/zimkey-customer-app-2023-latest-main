// To parse this JSON data, do
//
//     final orderListResponse = orderListResponseFromJson(jsonString);

import 'dart:convert';

OrderListResponse orderListResponseFromJson(String str) => OrderListResponse.fromJson(json.decode(str));

String orderListResponseToJson(OrderListResponse data) => json.encode(data.toJson());

class OrderListResponse {
  OrderListResponse({
    required this.status,
    required this.message,
    required this.orderList,
    required this.statusList,
  });

  final String status;
  final String message;
  final List<OrderList> orderList;
  final Map<String, String> statusList;

  factory OrderListResponse.fromJson(Map<String, dynamic> json) => OrderListResponse(
    status: json["status"],
    message: json["message"],
    orderList: List<OrderList>.from(json["orderList"].map((x) => OrderList.fromJson(x))),
    statusList: Map.from(json["statusList"]).map((k, v) => MapEntry<String, String>(k, v)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "orderList": List<dynamic>.from(orderList.map((x) => x.toJson())),
    "statusList": Map.from(statusList).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}

class OrderList {
  OrderList({
    required this.id,
    required this.addressTitle,
    required this.addressAndCity,
    required this.atpNumber,
    required this.state,
    required this.zipCode,
    required this.mobileNumber,
    required this.lat,
    required this.lng,
    required this.categoryName,
    required this.providerName,
    required this.vendorName,
    required this.groupName,
    required this.createdAt,
    required this.orderExternalId,
    required this.customerOrderNote,
    required this.vendorOrderNote,
    required this.agentOrderNote,
    required this.totalCost,
    required this.eta,
    required this.providerlogo,
    required this.status,
  });

  final int id;
  final String addressTitle;
  final String addressAndCity;
  final String atpNumber;
  final String state;
  final String zipCode;
  final String mobileNumber;
  final String lat;
  final String lng;
  final String categoryName;
  final String providerName;
  final String vendorName;
  final String groupName;
  final DateTime createdAt;
  final int orderExternalId;
  final String customerOrderNote;
  final String vendorOrderNote;
  final String agentOrderNote;
  final String totalCost;
  final String eta;
  final String providerlogo;
  final String status;

  factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
    id: json["id"],
    addressTitle: json["addressTitle"],
    addressAndCity: json["addressAndCity"],
    atpNumber: json["atpNumber"],
    state: json["state"],
    zipCode: json["zipCode"],
    mobileNumber: json["mobileNumber"],
    lat: json["lat"],
    lng: json["lng"],
    categoryName: json["categoryName"],
    providerName: json["providerName"],
    vendorName: json["vendorName"],
    groupName: json["groupName"],
    createdAt: DateTime.parse(json["created_at"]),
    orderExternalId: json["orderExternalID"],
    customerOrderNote: json["customerOrderNote"],
    vendorOrderNote: json["vendorOrderNote"],
    agentOrderNote: json["agentOrderNote"],
    totalCost: json["totalCost"],
    eta: json["ETA"],
    providerlogo: json["providerlogo"],
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "addressTitle": addressTitle,
    "addressAndCity": addressAndCity,
    "atpNumber": atpNumber,
    "state": state,
    "zipCode": zipCode,
    "mobileNumber": mobileNumber,
    "lat": lat,
    "lng": lng,
    "categoryName": categoryName,
    "providerName": providerName,
    "vendorName": vendorName,
    "groupName": groupName,
    "created_at": createdAt.toIso8601String(),
    "orderExternalID": orderExternalId,
    "customerOrderNote": customerOrderNote,
    "vendorOrderNote": vendorOrderNote,
    "agentOrderNote": agentOrderNote,
    "totalCost": totalCost,
    "ETA": eta,
    "providerlogo": providerlogo,
    "Status": status,
  };
}
