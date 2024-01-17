// To parse this JSON data, do
//
//     final addAddressResponse = addAddressResponseFromJson(jsonString);

import 'dart:convert';

import 'address_list_response.dart';

UpdateAddressResponse updateAddressResponseFromJson(String str) => UpdateAddressResponse.fromJson(json.decode(str));

String updateAddressResponseToJson(UpdateAddressResponse data) => json.encode(data.toJson());

class UpdateAddressResponse {
  final GetCustomerAddresses updateCustomerAddress;

  UpdateAddressResponse({
    required this.updateCustomerAddress,
  });

  factory UpdateAddressResponse.fromJson(Map<String, dynamic> json) => UpdateAddressResponse(
    updateCustomerAddress: GetCustomerAddresses.fromJson(json["updateCustomerAddress"]),
  );

  Map<String, dynamic> toJson() => {
    "updateCustomerAddress": updateCustomerAddress.toJson(),
  };
}


