// To parse this JSON data, do
//
//     final serviceCategoryResponse = serviceCategoryResponseFromJson(jsonString);

import 'dart:convert';

ServiceCategoryResponse serviceCategoryResponseFromJson(String str) => ServiceCategoryResponse.fromJson(json.decode(str));

String serviceCategoryResponseToJson(ServiceCategoryResponse data) => json.encode(data.toJson());

class ServiceCategoryResponse {
  final List<GetServiceCategory> getServiceCategories;

  ServiceCategoryResponse({
    required this.getServiceCategories,
  });

  factory ServiceCategoryResponse.fromJson(Map<String, dynamic> json) => ServiceCategoryResponse(
    getServiceCategories: List<GetServiceCategory>.from(json["getServiceCategories"].map((x) => GetServiceCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "getServiceCategories": List<dynamic>.from(getServiceCategories.map((x) => x.toJson())),
  };
}

class GetServiceCategory {
  final String id;
  final String name;
  final List<Service> services;

  GetServiceCategory({
    required this.id,
    required this.name,
    required this.services,
  });

  factory GetServiceCategory.fromJson(Map<String, dynamic> json) => GetServiceCategory(
    id: json["id"],
    name: json["name"],
    services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
  };
}

class Service {
  final String id;
  final String name;
  final CategoryIcon icon;

  Service({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    name: json["name"],
    icon: CategoryIcon.fromJson(json["icon"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon.toJson(),
  };
}

class CategoryIcon {
  final String url;

  CategoryIcon({
    required this.url,
  });

  factory CategoryIcon.fromJson(Map<String, dynamic> json) => CategoryIcon(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}
