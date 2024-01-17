// To parse this JSON data, do
//
//     final addressListResponse = addressListResponseFromJson(jsonString);

import 'dart:convert';

AddressListResponse addressListResponseFromJson(String str) => AddressListResponse.fromJson(json.decode(str));

String addressListResponseToJson(AddressListResponse data) => json.encode(data.toJson());

class AddressListResponse {
  final GetCustomerAddresses getCustomerAddresses;

  AddressListResponse({
    required this.getCustomerAddresses,
  });

  factory AddressListResponse.fromJson(Map<String, dynamic> json) => AddressListResponse(
    getCustomerAddresses: GetCustomerAddresses.fromJson(json["getCustomerAddresses"]),
  );

  Map<String, dynamic> toJson() => {
    "getCustomerAddresses": getCustomerAddresses.toJson(),
  };
}

class GetCustomerAddresses {
  final List<CustomerAddress> customerAddresses;

  GetCustomerAddresses({
    required this.customerAddresses,
  });

  factory GetCustomerAddresses.fromJson(Map<String, dynamic> json) => GetCustomerAddresses(
    customerAddresses: List<CustomerAddress>.from(json["customerAddresses"].map((x) => CustomerAddress.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "customerAddresses": List<dynamic>.from(customerAddresses.map((x) => x.toJson())),
  };
}

class CustomerAddress {
  final String id;
  final String buildingName;
  final dynamic address;
  final String addressType;
  final dynamic buildingNumber;
  final String landmark;
  final String locality;
  final String postalCode;
  final String areaId;
  final bool isDefault;
  final dynamic otherText;
  final Area area;

  CustomerAddress({
    required this.id,
    required this.buildingName,
    this.address,
    required this.addressType,
    this.buildingNumber,
    required this.landmark,
    required this.locality,
    required this.postalCode,
    required this.areaId,
    required this.isDefault,
     this.otherText,
    required this.area,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) => CustomerAddress(
    id: json["id"],
    buildingName: json["buildingName"],
    address: json["address"],
    addressType: json["addressType"],
    buildingNumber: json["buildingNumber"],
    landmark: json["landmark"],
    locality: json["locality"],
    postalCode: json["postalCode"],
    areaId: json["areaId"],
    isDefault: json["isDefault"],
    otherText: json["otherText"],
    area: Area.fromJson(json["area"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "buildingName": buildingName,
    "address": address,
    "addressType": addressType,
    "buildingNumber": buildingNumber,
    "landmark": landmark,
    "locality": locality,
    "postalCode": postalCode,
    "areaId": areaId,
    "isDefault": isDefault,
    "otherText": otherText,
    "area": area.toJson(),
  };
}

class Area {
  final String name;

  Area({
    required this.name,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}

class PinCode {
  final String pinCode;

  PinCode({
    required this.pinCode,
  });

  factory PinCode.fromJson(Map<String, dynamic> json) => PinCode(
    pinCode: json["pinCode"],
  );

  Map<String, dynamic> toJson() => {
    "pinCode": pinCode,
  };
}
