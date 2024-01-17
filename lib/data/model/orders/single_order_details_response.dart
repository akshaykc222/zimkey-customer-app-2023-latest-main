// To parse this JSON data, do
//
//     final singleOrderResponse = singleOrderResponseFromJson(jsonString);

import 'dart:convert';

SingleOrderResponse singleOrderResponseFromJson(String str) => SingleOrderResponse.fromJson(json.decode(str));

String singleOrderResponseToJson(SingleOrderResponse data) => json.encode(data.toJson());

class SingleOrderResponse {
  SingleOrderResponse({
    required this.status,
    required this.message,
    required this.orderItemList,
    required this.orderDetails,
  });

  final String status;
  final String message;
  final List<OrderItemList> orderItemList;
  final OrderDetails orderDetails;

  factory SingleOrderResponse.fromJson(Map<String, dynamic> json) => SingleOrderResponse(
    status: json["status"],
    message: json["message"],
    orderItemList: List<OrderItemList>.from(json["orderItemList"].map((x) => OrderItemList.fromJson(x))),
    orderDetails: OrderDetails.fromJson(json["orderDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "orderItemList": List<dynamic>.from(orderItemList.map((x) => x.toJson())),
    "orderDetails": orderDetails.toJson(),
  };
}

class OrderDetails {
  OrderDetails({
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

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
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

class OrderItemList {
  OrderItemList({
    required this.id,
    required this.orderId,
    required this.productOrServiceId,
    required this.productOrServiceExternalId,
    required this.productOrServiceName,
    required this.productOrServiceImage,
    required this.productOrServiceQuantity,
    required this.productOrServiceCost,
  });

  final int id;
  final int orderId;
  final int productOrServiceId;
  final int productOrServiceExternalId;
  final String productOrServiceName;
  final String productOrServiceImage;
  final String productOrServiceQuantity;
  final String productOrServiceCost;

  factory OrderItemList.fromJson(Map<String, dynamic> json) => OrderItemList(
    id: json["id"],
    orderId: json["orderID"],
    productOrServiceId: json["product_or_service_ID"],
    productOrServiceExternalId: json["product_or_service_external_ID"],
    productOrServiceName: json["product_or_service_name"],
    productOrServiceImage: json["product_or_service_image"],
    productOrServiceQuantity: json["product_or_service_quantity"],
    productOrServiceCost: json["product_or_service_cost"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderID": orderId,
    "product_or_service_ID": productOrServiceId,
    "product_or_service_external_ID": productOrServiceExternalId,
    "product_or_service_name": productOrServiceName,
    "product_or_service_image": productOrServiceImage,
    "product_or_service_quantity": productOrServiceQuantity,
    "product_or_service_cost": productOrServiceCost,
  };
}
