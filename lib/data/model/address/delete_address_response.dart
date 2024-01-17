// To parse this JSON data, do
//
//     final addAddressResponse = addAddressResponseFromJson(jsonString);

import 'dart:convert';

import 'address_list_response.dart';

DeleteAddressResponse deleteAddressResponseFromJson(String str) => DeleteAddressResponse.fromJson(json.decode(str));

String deleteAddressResponseToJson(DeleteAddressResponse data) => json.encode(data.toJson());

class DeleteAddressResponse {
  final GetCustomerAddresses deleteCustomerAddress;

  DeleteAddressResponse({
    required this.deleteCustomerAddress,
  });

  factory DeleteAddressResponse.fromJson(Map<String, dynamic> json) => DeleteAddressResponse(
    deleteCustomerAddress: GetCustomerAddresses.fromJson(json["deleteCustomerAddress"]),
  );

  Map<String, dynamic> toJson() => {
    "deleteCustomerAddress": deleteCustomerAddress.toJson(),
  };
}


