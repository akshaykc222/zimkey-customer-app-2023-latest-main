// To parse this JSON data, do
//
//     final homeResponse = homeResponseFromJson(jsonString);

import 'dart:convert';

HomeResponse homeResponseFromJson(String str) => HomeResponse.fromJson(json.decode(str));

String homeResponseToJson(HomeResponse data) => json.encode(data.toJson());

class HomeResponse {
  final GetCombinedHome getCombinedHome;

  HomeResponse({
    required this.getCombinedHome,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
    getCombinedHome: GetCombinedHome.fromJson(json["getCombinedHome"]),
  );

  Map<String, dynamic> toJson() => {
    "getCombinedHome": getCombinedHome.toJson(),
  };
}

class GetCombinedHome {
  final List<GetArea>? getAreas;
  final List<GetServiceCategory>? getServiceCategories;
  final List<GetPopularService>? getPopularServices;
  final GetLoyaltyPointRates? getLoyaltyPointRates;
  final List<GetBanner>? getBanners;
  final List<GetHomeService>? getHomeServices;
  final GetHomeContent? getHomeContent;

  GetCombinedHome({
    this.getAreas,
    this.getServiceCategories,
    this.getPopularServices,
    this.getLoyaltyPointRates,
    this.getBanners,
    this.getHomeServices,
    this.getHomeContent

  });

  factory GetCombinedHome.fromJson(Map<String, dynamic> json) => GetCombinedHome(
    getAreas: json["getAreas"] == null ? [] : List<GetArea>.from(json["getAreas"]!.map((x) => GetArea.fromJson(x))),
    getServiceCategories: json["getServiceCategories"] == null ? [] : List<GetServiceCategory>.from(json["getServiceCategories"]!.map((x) => GetServiceCategory.fromJson(x))),
    getPopularServices: json["getPopularServices"] == null ? [] : List<GetPopularService>.from(json["getPopularServices"]!.map((x) => GetPopularService.fromJson(x))),
    getLoyaltyPointRates: json["getLoyaltyPointRates"] == null ? null : GetLoyaltyPointRates.fromJson(json["getLoyaltyPointRates"]),
    getBanners: json["getBanners"] == null ? [] : List<GetBanner>.from(json["getBanners"]!.map((x) => GetBanner.fromJson(x))),
    getHomeServices: json["getHomeServices"] == null ? [] : List<GetHomeService>.from(json["getHomeServices"]!.map((x) => GetHomeService.fromJson(x))),
    getHomeContent:json["getHomeContent"]== null ? null : GetHomeContent.fromJson(json["getHomeContent"]),

  );

  Map<String, dynamic> toJson() => {
    "getAreas": getAreas == null ? [] : List<dynamic>.from(getAreas!.map((x) => x.toJson())),
    "getServiceCategories": getServiceCategories == null ? [] : List<dynamic>.from(getServiceCategories!.map((x) => x.toJson())),
    "getPopularServices": getPopularServices == null ? [] : List<dynamic>.from(getPopularServices!.map((x) => x.toJson())),
    "getLoyaltyPointRates": getLoyaltyPointRates?.toJson(),
    "getBanners": getBanners == null ? [] : List<dynamic>.from(getBanners!.map((x) => x.toJson())),
    "getHomeServices": getHomeServices == null ? [] : List<dynamic>.from(getHomeServices!.map((x) => x.toJson())),
    "getHomeContent": getHomeContent?.toJson(),
  };
}

class GetArea {
  final String? id;
  final String? name;
  final String? code;
  final List<PinCode>? pinCodes;

  GetArea({
    this.id,
    this.name,
    this.code,
    this.pinCodes,
  });

  factory GetArea.fromJson(Map<String, dynamic> json) => GetArea(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    pinCodes: json["pinCodes"] == null ? [] : List<PinCode>.from(json["pinCodes"]!.map((x) => PinCode.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "pinCodes": pinCodes == null ? [] : List<dynamic>.from(pinCodes!.map((x) => x.toJson())),
  };
}

class PinCode {
  final String? id;
  final String? areaId;
  final String? pinCode;

  PinCode({
    this.id,
    this.areaId,
    this.pinCode,
  });

  factory PinCode.fromJson(Map<String, dynamic> json) => PinCode(
    id: json["id"],
    areaId: json["areaId"],
    pinCode: json["pinCode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "areaId": areaId,
    "pinCode": pinCode,
  };
}

class GetBanner {
  final String? id;
  final String? title;
  final String? description;
  final String? url;
  final String? mediaId;
  final GetBannerMedia? media;

  GetBanner({
    this.id,
    this.title,
    this.description,
    this.url,
    this.mediaId,
    this.media,
  });

  factory GetBanner.fromJson(Map<String, dynamic> json) => GetBanner(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    url: json["url"],
    mediaId: json["mediaId"],
    media: json["media"] == null ? null : GetBannerMedia.fromJson(json["media"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "url": url,
    "mediaId": mediaId,
    "media": media?.toJson(),
  };
}

class GetBannerMedia {
  final String? id;
  final String? url;

  GetBannerMedia({
    this.id,
    this.url,
  });

  factory GetBannerMedia.fromJson(Map<String, dynamic> json) => GetBannerMedia(
    id: json["id"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
  };
}

class GetHomeService {
  final String? id;
  final String? name;
  final List<dynamic>? medias;
  final ServiceIcon? icon;
  final List<dynamic>? inputs;
  final List<Requirement>? requirements;
  final List<GetHomeServiceBillingOption>? billingOptions;
  final String? code;
  final String? description;

  GetHomeService({
    this.id,
    this.name,
    this.medias,
    this.icon,
    this.inputs,
    this.requirements,
    this.billingOptions,
    this.code,
    this.description,
  });

  factory GetHomeService.fromJson(Map<String, dynamic> json) => GetHomeService(
    id: json["id"],
    name: json["name"],
    medias: json["medias"] == null ? [] : List<dynamic>.from(json["medias"]!.map((x) => x)),
    icon: json["icon"] == null ? null : ServiceIcon.fromJson(json["icon"]),
    inputs: json["inputs"] == null ? [] : List<dynamic>.from(json["inputs"]!.map((x) => x)),
    requirements: json["requirements"] == null ? [] : List<Requirement>.from(json["requirements"]!.map((x) => Requirement.fromJson(x))),
    billingOptions: json["billingOptions"] == null ? [] : List<GetHomeServiceBillingOption>.from(json["billingOptions"]!.map((x) => GetHomeServiceBillingOption.fromJson(x))),
    code: json["code"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "medias": medias == null ? [] : List<dynamic>.from(medias!.map((x) => x)),
    "icon": icon?.toJson(),
    "inputs": inputs == null ? [] : List<dynamic>.from(inputs!.map((x) => x)),
    "requirements": requirements == null ? [] : List<dynamic>.from(requirements!.map((x) => x.toJson())),
    "billingOptions": billingOptions == null ? [] : List<dynamic>.from(billingOptions!.map((x) => x.toJson())),
    "code": code,
    "description": description,
  };
}

class GetHomeServiceBillingOption {
  final String? id;
  final String? code;
  final String? name;
  // final BillingOptionDescription? description;
  final bool? recurring;
  final String? recurringPeriod;
  final bool? autoAssignPartner;
  final Price? unitPrice;
  final Unit? unit;
  final int? minUnit;
  final int? maxUnit;
  final List<ServiceAdditionalPayment>? serviceAdditionalPayments;
  final Price? additionalUnitPrice;

  GetHomeServiceBillingOption({
    this.id,
    this.code,
    this.name,
    // this.description,
    this.recurring,
    this.recurringPeriod,
    this.autoAssignPartner,
    this.unitPrice,
    this.unit,
    this.minUnit,
    this.maxUnit,
    this.serviceAdditionalPayments,
    this.additionalUnitPrice,
  });

  factory GetHomeServiceBillingOption.fromJson(Map<String, dynamic> json) => GetHomeServiceBillingOption(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    // description: billingOptionDescriptionValues.map[json["description"]]!,
    recurring: json["recurring"],
    recurringPeriod: json["recurringPeriod"],
    autoAssignPartner: json["autoAssignPartner"],
    unitPrice: json["unitPrice"] == null ? null : Price.fromJson(json["unitPrice"]),
    unit: unitValues.map[json["unit"]]!,
    minUnit: json["minUnit"],
    maxUnit: json["maxUnit"],
    serviceAdditionalPayments: json["serviceAdditionalPayments"] == null ? [] : List<ServiceAdditionalPayment>.from(json["serviceAdditionalPayments"]!.map((x) => ServiceAdditionalPayment.fromJson(x))),
    additionalUnitPrice: json["additionalUnitPrice"] == null ? null : Price.fromJson(json["additionalUnitPrice"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    // "description": billingOptionDescriptionValues.reverse[description],
    "recurring": recurring,
    "recurringPeriod": recurringPeriod,
    "autoAssignPartner": autoAssignPartner,
    "unitPrice": unitPrice?.toJson(),
    "unit": unitValues.reverse[unit],
    "minUnit": minUnit,
    "maxUnit": maxUnit,
    "serviceAdditionalPayments": serviceAdditionalPayments == null ? [] : List<dynamic>.from(serviceAdditionalPayments!.map((x) => x.toJson())),
    "additionalUnitPrice": additionalUnitPrice?.toJson(),
  };
}

class Price {
  final dynamic commission;
  final dynamic partnerPrice;
  final dynamic commissionTax;
  final dynamic partnerTax;
  final dynamic total;
  final dynamic totalTax;

  Price({
    this.commission,
    this.partnerPrice,
    this.commissionTax,
    this.partnerTax,
    this.total,
    this.totalTax,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    commission: json["commission"]?.toDouble(),
    partnerPrice: json["partnerPrice"],
    commissionTax: json["commissionTax"],
    partnerTax: json["partnerTax"],
    total: json["total"]?.toDouble(),
    totalTax: json["totalTax"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "commission": commission,
    "partnerPrice": partnerPrice,
    "commissionTax": commissionTax,
    "partnerTax": partnerTax,
    "total": total,
    "totalTax": totalTax,
  };
}

enum BillingOptionDescription { SINGLE_PAYMENT, DESCRIPTION_SINGLE_PAYMENT, AOSIFJOAS_F }

final billingOptionDescriptionValues = EnumValues({
  "aosifjoas f": BillingOptionDescription.AOSIFJOAS_F,
  "Single Payment": BillingOptionDescription.DESCRIPTION_SINGLE_PAYMENT,
  "Single payment": BillingOptionDescription.SINGLE_PAYMENT
});

class ServiceAdditionalPayment {
  final String? id;
  final Price? price;
  final Name? name;
  final ServiceAdditionalPaymentDescription? description;
  final bool? mandatory;
  final bool? refundable;
  final String? serviceBillingOptionId;

  ServiceAdditionalPayment({
    this.id,
    this.price,
    this.name,
    this.description,
    this.mandatory,
    this.refundable,
    this.serviceBillingOptionId,
  });

  factory ServiceAdditionalPayment.fromJson(Map<String, dynamic> json) => ServiceAdditionalPayment(
    id: json["id"],
    price: json["price"] == null ? null : Price.fromJson(json["price"]),
    name: nameValues.map[json["name"]]!,
    description: serviceAdditionalPaymentDescriptionValues.map[json["description"]]!,
    mandatory: json["mandatory"],
    refundable: json["refundable"],
    serviceBillingOptionId: json["serviceBillingOptionId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price?.toJson(),
    "name": nameValues.reverse[name],
    "description": serviceAdditionalPaymentDescriptionValues.reverse[description],
    "mandatory": mandatory,
    "refundable": refundable,
    "serviceBillingOptionId": serviceBillingOptionId,
  };
}

enum ServiceAdditionalPaymentDescription { REFUNDABLE_CHARGE_AS_SECURITY }

final serviceAdditionalPaymentDescriptionValues = EnumValues({
  "refundable charge as security": ServiceAdditionalPaymentDescription.REFUNDABLE_CHARGE_AS_SECURITY
});

enum Name { FIXED_DEPO }

final nameValues = EnumValues({
  "Fixed Depo": Name.FIXED_DEPO
});

enum Unit { HOUR, COUNT, LITER, DAY, MONTH, WEEK }

final unitValues = EnumValues({
  "COUNT": Unit.COUNT,
  "DAY": Unit.DAY,
  "HOUR": Unit.HOUR,
  "LITER": Unit.LITER,
  "MONTH": Unit.MONTH,
  "WEEK": Unit.WEEK
});

class ServiceIcon {
  final String? id;
  final String? url;
  final dynamic name;
  final dynamic thumbnail;

  ServiceIcon({
    this.id,
    this.url,
    this.name,
    this.thumbnail,
  });

  factory ServiceIcon.fromJson(Map<String, dynamic> json) => ServiceIcon(
    id: json["id"],
    url: json["url"],
    name: json["name"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "name": name,
    "thumbnail": thumbnail,
  };
}

class Requirement {
  final String? description;
  final String? id;
  final String? title;

  Requirement({
    this.description,
    this.id,
    this.title,
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
}

class GetLoyaltyPointRates {
  final int? pointValue;
  final double? maxPointEarnedPerBooking;
  final double? maxPointRedeemedPerBooking;
  final int? maxPointEarnedPerReferral;

  GetLoyaltyPointRates({
    this.pointValue,
    this.maxPointEarnedPerBooking,
    this.maxPointRedeemedPerBooking,
    this.maxPointEarnedPerReferral,
  });

  factory GetLoyaltyPointRates.fromJson(Map<String, dynamic> json) => GetLoyaltyPointRates(
    pointValue: json["pointValue"],
    maxPointEarnedPerBooking: json["maxPointEarnedPerBooking"]?.toDouble(),
    maxPointRedeemedPerBooking: json["maxPointRedeemedPerBooking"]?.toDouble(),
    maxPointEarnedPerReferral: json["maxPointEarnedPerReferral"],
  );

  Map<String, dynamic> toJson() => {
    "pointValue": pointValue,
    "maxPointEarnedPerBooking": maxPointEarnedPerBooking,
    "maxPointRedeemedPerBooking": maxPointRedeemedPerBooking,
    "maxPointEarnedPerReferral": maxPointEarnedPerReferral,
  };
}

class GetPopularService {
  final String? id;
  final String? name;
  final List<Media>? medias;
  final Thumbnail? thumbnail;


  GetPopularService({
    this.id,
    this.name,
    this.medias,
    this.thumbnail

  });

  factory GetPopularService.fromJson(Map<String, dynamic> json) => GetPopularService(
    id: json["id"],
    name: json["name"],
    medias: List<Media>.from(json["medias"].map((x) => Media.fromJson(x))),
    thumbnail: json["thumbnail"]==null?null: Thumbnail.fromJson(json["thumbnail"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "thumbnail": thumbnail?.toJson(),
    "medias":medias==null?[]: List<dynamic>.from(medias!.map((x) => x)),
  };
}



class GetServiceCategory {
  final String? id;
  final String? name;
  final String? code;
  final List<dynamic>? images;
  final List<Service>? services;

  GetServiceCategory({
    this.id,
    this.name,
    this.code,
    this.images,
    this.services,
  });

  factory GetServiceCategory.fromJson(Map<String, dynamic> json) => GetServiceCategory(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    images: json["images"] == null ? [] : List<dynamic>.from(json["images"]!.map((x) => x)),
    services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
  };
}

class Service {
  final String? id;
  final String? code;
  final ServiceIcon? icon;
  final List<Addon>? addons;
  final String? name;
  final String? description;
  final List<GetHomeServiceBillingOption>? billingOptions;
  final List<Requirement>? requirements;
  final List<Input>? inputs;
  final List<MediaElement>? medias;

  Service({
    this.id,
    this.code,
    this.icon,
    this.addons,
    this.name,
    this.description,
    this.billingOptions,
    this.requirements,
    this.inputs,
    this.medias,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    code: json["code"],
    icon: json["icon"] == null ? null : ServiceIcon.fromJson(json["icon"]),
    addons: json["addons"] == null ? [] : List<Addon>.from(json["addons"]!.map((x) => Addon.fromJson(x))),
    name: json["name"],
    description: json["description"],
    billingOptions: json["billingOptions"] == null ? [] : List<GetHomeServiceBillingOption>.from(json["billingOptions"]!.map((x) => GetHomeServiceBillingOption.fromJson(x))),
    requirements: json["requirements"] == null ? [] : List<Requirement>.from(json["requirements"]!.map((x) => Requirement.fromJson(x))),
    inputs: json["inputs"] == null ? [] : List<Input>.from(json["inputs"]!.map((x) => Input.fromJson(x))),
    medias: json["medias"] == null ? [] : List<MediaElement>.from(json["medias"]!.map((x) => MediaElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "icon": icon?.toJson(),
    "addons": addons == null ? [] : List<dynamic>.from(addons!.map((x) => x.toJson())),
    "name": name,
    "description": description,
    "billingOptions": billingOptions == null ? [] : List<dynamic>.from(billingOptions!.map((x) => x.toJson())),
    "requirements": requirements == null ? [] : List<dynamic>.from(requirements!.map((x) => x.toJson())),
    "inputs": inputs == null ? [] : List<dynamic>.from(inputs!.map((x) => x.toJson())),
    "medias": medias == null ? [] : List<dynamic>.from(medias!.map((x) => x.toJson())),
  };
}

class Addon {
  final String? id;
  final String? name;
  final String? description;
  final String? type;
  final Unit? unit;
  final Price? unitPrice;
  final int? minUnit;
  final int? maxUnit;
  final String? serviceId;

  Addon({
    this.id,
    this.name,
    this.description,
    this.type,
    this.unit,
    this.unitPrice,
    this.minUnit,
    this.maxUnit,
    this.serviceId,
  });

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    type: json["type"],
    unit: unitValues.map[json["unit"]]!,
    unitPrice: json["unitPrice"] == null ? null : Price.fromJson(json["unitPrice"]),
    minUnit: json["minUnit"],
    maxUnit: json["maxUnit"],
    serviceId: json["serviceId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "type": type,
    "unit": unitValues.reverse[unit],
    "unitPrice": unitPrice?.toJson(),
    "minUnit": minUnit,
    "maxUnit": maxUnit,
    "serviceId": serviceId,
  };
}

class Input {
  final String? id;
  final String? name;
  final String? description;
  final String? key;
  final String? type;

  Input({
    this.id,
    this.name,
    this.description,
    this.key,
    this.type,
  });

  factory Input.fromJson(Map<String, dynamic> json) => Input(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    key: json["key"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "key": key,
    "type": type,
  };
}

class MediaElement {
  final String? url;
  final dynamic thumbnail;

  MediaElement({
    this.url,
    this.thumbnail,
  });

  factory MediaElement.fromJson(Map<String, dynamic> json) => MediaElement(
    url: json["url"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "thumbnail": thumbnail,
  };
}

class Media {
  final String id;
  final String type;
  final String url;
  final bool enabled;
  final dynamic thumbnail;

  Media({required this.id,required this.type,required this.url,required this.enabled,required this.thumbnail});

  factory Media.fromJson(Map<String, dynamic> json)=> Media(
    id:json['id'],
    type: json['type'],
    url : json['url'],
    enabled : json['enabled'],
    thumbnail : json['thumbnail'],
  );

  Map<String, dynamic> toJson()=> {
    "id" : id,
    "type" : type,
    "url" : url,
    "enabled" : enabled,
    "thumbnail" : thumbnail,
  };
}

class Thumbnail {
  final String url;

  Thumbnail({required this.url,});

  factory Thumbnail.fromJson(Map<String, dynamic> json)=> Thumbnail(
    url : json['url'],
  );

  Map<String, dynamic> toJson()=> {
    "url" : url,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class GetHomeContent {
  final String id;
  final bool status;
  final String image;
  final String description;

  GetHomeContent({
    required this.id,
    required this.status,
    required this.image,
    required this.description,
  });

  factory GetHomeContent.fromJson(Map<String, dynamic> json) => GetHomeContent(
    id: json["id"],
    status: json["status"],
    image: json["image"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "image": image,
    "description": description,
  };
}
