// To parse this JSON data, do
//
//     final searchServiceResponse = searchServiceResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SearchServiceResponse searchServiceResponseFromJson(String str) => SearchServiceResponse.fromJson(json.decode(str));

String searchServiceResponseToJson(SearchServiceResponse data) => json.encode(data.toJson());

class SearchServiceResponse {
  final List<SearchService> getServices;

  SearchServiceResponse({
    required this.getServices,
  });

  factory SearchServiceResponse.fromJson(Map<String, dynamic> json) => SearchServiceResponse(
    getServices: List<SearchService>.from(json["getServices"].map((x) => SearchService.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "getServices": List<dynamic>.from(getServices.map((x) => x.toJson())),
  };
}

class SearchService {
  final String id;
  final String name;
  final ServiceIcon icon;

  SearchService({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory SearchService.fromJson(Map<String, dynamic> json) => SearchService(
    id: json["id"],
    name: json["name"],
    icon: ServiceIcon.fromJson(json["icon"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon.toJson(),
  };
}

class ServiceIcon {
  final String url;

  ServiceIcon({
    required this.url,
  });

  factory ServiceIcon.fromJson(Map<String, dynamic> json) => ServiceIcon(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}
