// To parse this JSON data, do
//
//     final singleServiceResponse = singleServiceResponseFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

SingleServiceResponse singleServiceResponseFromJson(String str) =>
    SingleServiceResponse.fromJson(json.decode(str));

String singleServiceResponseToJson(SingleServiceResponse data) =>
    json.encode(data.toJson());

class SingleServiceResponse {
  final GetService getService;

  SingleServiceResponse({
    required this.getService,
  });

  factory SingleServiceResponse.fromJson(Map<String, dynamic> json) =>
      SingleServiceResponse(
        getService: GetService.fromJson(json["getService"]),
      );

  Map<String, dynamic> toJson() => {
        "getService": getService.toJson(),
      };
}

class GetService {
  final String id;
  final String name;
  final String code;
  final List<Media> medias;
  final List<Requirement> requirements;
  final List<BillingOption> billingOptions;
  final List<dynamic> inputs;
  final String description;
  final bool isFavorite;
  final List<PropertyType>? propertyType;
  final List<PropertyArea>? propertyArea;
  final List<Room>? room;
  final bool? isTeamService;
  final bool? isCleaningService;

  GetService(
      {required this.id,
      required this.name,
      required this.code,
      required this.medias,
      required this.requirements,
      required this.billingOptions,
      required this.inputs,
      required this.description,
      required this.isFavorite,
      required this.propertyType,
      required this.propertyArea,
      required this.room,
      this.isTeamService,
      this.isCleaningService});

  factory GetService.fromJson(Map<String, dynamic> json) => GetService(
      isCleaningService: json['isCleaningService'],
      id: json["id"],
      name: json["name"],
      code: json["code"],
      isTeamService: json['isTeamService'],
      medias: List<Media>.from(json["medias"].map((x) => Media.fromJson(x))),
      requirements: List<Requirement>.from(
          json["requirements"].map((x) => Requirement.fromJson(x))),
      billingOptions: List<BillingOption>.from(
          json["billingOptions"].map((x) => BillingOption.fromJson(x))),
      inputs: List<dynamic>.from(json["inputs"].map((x) => x)),
      description: json["description"],
      isFavorite: json["isFavorite"],
      propertyType: json['propertyTypes'] == null
          ? null
          : List<PropertyType>.from(
              json['propertyTypes'].map((e) => PropertyType.fromJson(e))),
      room: json['rooms'] == null
          ? null
          : List<Room>.from(json['rooms'].map((e) => Room.fromJson(e))),
      propertyArea: json['propertyAreas'] == null
          ? null
          : List<PropertyArea>.from(
              json['propertyAreas'].map((e) => PropertyArea.fromJson(e))));

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "medias": List<dynamic>.from(medias.map((x) => x)),
        "requirements": List<dynamic>.from(requirements.map((x) => x.toJson())),
        "billingOptions":
            List<dynamic>.from(billingOptions.map((x) => x.toJson())),
        "inputs": List<dynamic>.from(inputs.map((x) => x)),
        "description": description,
        "isFavorite": isFavorite
      };
}

class BillingOption {
  final String id;
  final String code;
  final String name;
  final String description;
  final bool recurring;
  final dynamic recurringPeriod;
  final bool autoAssignPartner;
  final UnitPrice unitPrice;
  final String unit;
  final int minUnit;
  final int maxUnit;
  final List<dynamic> serviceAdditionalPayments;

  BillingOption({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.recurring,
    required this.recurringPeriod,
    required this.autoAssignPartner,
    required this.unitPrice,
    required this.unit,
    required this.minUnit,
    required this.maxUnit,
    required this.serviceAdditionalPayments,
  });

  factory BillingOption.fromJson(Map<String, dynamic> json) => BillingOption(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        recurring: json["recurring"],
        recurringPeriod: json["recurringPeriod"],
        autoAssignPartner: json["autoAssignPartner"],
        unitPrice: UnitPrice.fromJson(json["unitPrice"]),
        unit: json["unit"],
        minUnit: json["minUnit"],
        maxUnit: json["maxUnit"],
        serviceAdditionalPayments:
            List<dynamic>.from(json["serviceAdditionalPayments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
        "recurring": recurring,
        "recurringPeriod": recurringPeriod,
        "autoAssignPartner": autoAssignPartner,
        "unitPrice": unitPrice.toJson(),
        "unit": unit,
        "minUnit": minUnit,
        "maxUnit": maxUnit,
        "serviceAdditionalPayments":
            List<dynamic>.from(serviceAdditionalPayments.map((x) => x)),
      };
}

class UnitPrice {
  final double commission;
  final double partnerPrice;
  final double unitPrice;
  final double commissionTax;
  final double partnerTax;
  final double total;
  final double totalTax;

  UnitPrice({
    required this.commission,
    required this.partnerPrice,
    required this.unitPrice,
    required this.commissionTax,
    required this.partnerTax,
    required this.total,
    required this.totalTax,
  });

  factory UnitPrice.fromJson(Map<String, dynamic> json) {
    print("commision");
    print(json["commission"]);
    return UnitPrice(
      commission: (json["commission"] ?? 0).toDouble(),
      partnerPrice: (json["partnerPrice"] ?? 0).toDouble(),
      unitPrice: (json["unitPrice"] ?? 0).toDouble(),
      commissionTax: (json["commissionTax"] ?? 0).toDouble(),
      partnerTax: (json["partnerTax"] ?? 0).toDouble(),
      total: json["total"]?.toDouble(),
      totalTax: json["totalTax"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "commission": commission,
        "partnerPrice": partnerPrice,
        "unitPrice": unitPrice,
        "commissionTax": commissionTax,
        "partnerTax": partnerTax,
        "total": total,
        "totalTax": totalTax,
      };
}

class Requirement extends Equatable {
  final dynamic description;
  final String id;
  final String title;

  const Requirement({
    required this.description,
    required this.id,
    required this.title,
  });

  factory Requirement.fromJson(Map<String, dynamic> json) => Requirement(
        description: json["description"],
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "id": id,
        "title": title,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class Media {
  final String id;
  final String type;
  final String url;
  final bool enabled;
  final dynamic thumbnail;

  Media(
      {required this.id,
      required this.type,
      required this.url,
      required this.enabled,
      required this.thumbnail});

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json['id'],
        type: json['type'],
        url: json['url'],
        enabled: json['enabled'],
        thumbnail: json['thumbnail'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "url": url,
        "enabled": enabled,
        "thumbnail": thumbnail,
      };
}

class Room extends Equatable {
  Room({
    required this.id,
    required this.title,
  });

  String? id;
  String title;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class PropertyArea extends Equatable {
  PropertyArea({required this.id, required this.title, required this.hours});

  String? id;
  String title;
  int hours;

  factory PropertyArea.fromJson(Map<String, dynamic> json) =>
      PropertyArea(id: json["id"], title: json["title"], hours: json['hours']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class PropertyType extends Equatable {
  PropertyType({
    required this.id,
    required this.title,
    required this.noRooms,
  });

  String? id;
  String title;
  bool? noRooms;

  factory PropertyType.fromJson(Map<String, dynamic> json) => PropertyType(
        id: json["id"],
        title: json["title"],
        noRooms: json["noRooms"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "noRooms": noRooms,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
