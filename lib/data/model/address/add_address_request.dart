// To parse this JSON data, do
//
//     final addAddressRequest = addAddressRequestFromJson(jsonString);

import 'dart:convert';

AddAddressRequest addAddressRequestFromJson(String str) => AddAddressRequest.fromJson(json.decode(str));

String addAddressRequestToJson(AddAddressRequest data) => json.encode(data.toJson());

class AddAddressRequest {
  final String buildingName;
  final String locality;
  final String landmark;
  final String areaId;
  final String postalCode;
  final String addressType;
  final String addressPhone;
  final bool isDefault;

  AddAddressRequest({
    required this.buildingName,
    required this.locality,
    required this.landmark,
    required this.areaId,
    required this.postalCode,
    required this.addressType,
    required this.addressPhone,
    required this.isDefault,
  });

  factory AddAddressRequest.fromJson(Map<String, dynamic> json) => AddAddressRequest(
    buildingName: json["buildingName"],
    locality: json["locality"],
    landmark: json["landmark"],
    areaId: json["areaId"],
    postalCode: json["postalCode"],
    addressType: json["addressType"],
    addressPhone: json["addressPhone"],
    isDefault: json["isDefault"],
  );

  Map<String, dynamic> toJson() => {
    "buildingName": buildingName,
    "locality": locality,
    "landmark": landmark,
    "areaId": areaId,
    "postalCode": postalCode,
    "addressType": addressType,
    "addressPhone": addressPhone,
    "isDefault": isDefault,
  };
}
