// To parse this JSON data, do
//
//     final addAddressResponse = addAddressResponseFromJson(jsonString);

import 'dart:convert';

import 'address_list_response.dart';

AddAddressResponse addAddressResponseFromJson(String str) => AddAddressResponse.fromJson(json.decode(str));

String addAddressResponseToJson(AddAddressResponse data) => json.encode(data.toJson());

class AddAddressResponse {
  final GetCustomerAddresses addCustomerAddress;

  AddAddressResponse({
    required this.addCustomerAddress,
  });

  factory AddAddressResponse.fromJson(Map<String, dynamic> json) => AddAddressResponse(
    addCustomerAddress: GetCustomerAddresses.fromJson(json["addCustomerAddress"]),
  );

  Map<String, dynamic> toJson() => {
    "addCustomerAddress": addCustomerAddress.toJson(),
  };
}


