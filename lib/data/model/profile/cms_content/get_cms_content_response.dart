// To parse this JSON data, do
//
//     final getCmsContentsResponse = getCmsContentsResponseFromJson(jsonString);

import 'dart:convert';

GetCmsContentsResponse getCmsContentsResponseFromJson(String str) => GetCmsContentsResponse.fromJson(json.decode(str));

String getCmsContentsResponseToJson(GetCmsContentsResponse data) => json.encode(data.toJson());

class GetCmsContentsResponse {
  final GetCmsContent getCmsContent;

  GetCmsContentsResponse({
    required this.getCmsContent,
  });

  factory GetCmsContentsResponse.fromJson(Map<String, dynamic> json) => GetCmsContentsResponse(
    getCmsContent: GetCmsContent.fromJson(json["getCmsContent"]),
  );

  Map<String, dynamic> toJson() => {
    "getCmsContent": getCmsContent.toJson(),
  };
}

class GetCmsContent {
  final String id;
  final String aboutUs;
  final String referPolicy;
  final String termsConditionsCustomer;
  final String privacyPolicy;
  final String safetyPolicy;
  final String cancellationPolicyCustomer;

  GetCmsContent({
    required this.id,
    required this.aboutUs,
    required this.referPolicy,
    required this.termsConditionsCustomer,
    required this.privacyPolicy,
    required this.safetyPolicy,
    required this.cancellationPolicyCustomer,
  });

  factory GetCmsContent.fromJson(Map<String, dynamic> json) => GetCmsContent(
    id: json["id"],
    aboutUs: json["aboutUs"],
    referPolicy: json["referPolicy"],
    termsConditionsCustomer: json["termsConditionsCustomer"],
    privacyPolicy: json["privacyPolicy"],
    safetyPolicy: json["safetyPolicy"],
    cancellationPolicyCustomer: json["cancellationPolicyCustomer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "aboutUs": aboutUs,
    "referPolicy": referPolicy,
    "termsConditionsCustomer": termsConditionsCustomer,
    "privacyPolicy": privacyPolicy,
    "safetyPolicy": safetyPolicy,
    "cancellationPolicyCustomer": cancellationPolicyCustomer,
  };
}
