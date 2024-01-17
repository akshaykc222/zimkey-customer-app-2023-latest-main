// To parse this JSON data, do
//
//     final getCitiesResponse = getCitiesResponseFromJson(jsonString);

import 'dart:convert';

import '../../../data/model/home/home_response.dart';


GetCitiesResponse getCitiesResponseFromJson(String str) => GetCitiesResponse.fromJson(json.decode(str));

String getCitiesResponseToJson(GetCitiesResponse data) => json.encode(data.toJson());

class GetCitiesResponse {
  final List<GetCity> getCities;

  GetCitiesResponse({
    required this.getCities,
  });

  factory GetCitiesResponse.fromJson(Map<String, dynamic> json) => GetCitiesResponse(
    getCities: List<GetCity>.from(json["getCities"].map((x) => GetCity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "getCities": List<dynamic>.from(getCities.map((x) => x.toJson())),
  };
}

class GetCity {
  final String id;
  final String name;
  final String code;
  final List<GetArea>? areas;
  final List<PinCode>? pinCodes;

  GetCity({
    required this.id,
    required this.name,
    required this.code,
    this.areas,
    this.pinCodes,
  });

  factory GetCity.fromJson(Map<String, dynamic> json) => GetCity(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    areas: json["areas"] == null ? [] : List<GetArea>.from(json["areas"]!.map((x) => GetArea.fromJson(x))),
    pinCodes: json["pinCodes"] == null ? [] : List<PinCode>.from(json["pinCodes"]!.map((x) => PinCode.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "areas": areas == null ? [] : List<dynamic>.from(areas!.map((x) => x.toJson())),
    "pinCodes": pinCodes == null ? [] : List<dynamic>.from(pinCodes!.map((x) => x.toJson())),
  };
}

class PinCode {
  final String id;
  final String pinCode;
  final String areaId;

  PinCode({
    required this.id,
    required this.pinCode,
    required this.areaId,
  });

  factory PinCode.fromJson(Map<String, dynamic> json) => PinCode(
    id: json["id"],
    pinCode: json["pinCode"],
    areaId: json["areaId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "pinCode": pinCode,
    "areaId": areaId,
  };
}
