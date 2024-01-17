// To parse this JSON data, do
//
//     final faqResponse = faqResponseFromJson(jsonString);

import 'dart:convert';

FaqResponse faqResponseFromJson(String str) => FaqResponse.fromJson(json.decode(str));

String faqResponseToJson(FaqResponse data) => json.encode(data.toJson());

class FaqResponse {
  final List<GetFaq> getFaqs;

  FaqResponse({
    required this.getFaqs,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) => FaqResponse(
    getFaqs: List<GetFaq>.from(json["getFaqs"].map((x) => GetFaq.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "getFaqs": List<dynamic>.from(getFaqs.map((x) => x.toJson())),
  };
}

class GetFaq {
  final String id;
  final String question;
  final String category;
  final String answer;
  bool isExpanded;
  final int? sortOrder;

  GetFaq({
    required this.id,
    required this.question,
    required this.category,
    required this.answer,
    this.isExpanded = false,
    required this.sortOrder,
  });

  factory GetFaq.fromJson(Map<String, dynamic> json) => GetFaq(
    id: json["id"],
    question: json["question"],
    category: json["category"],
    answer: json["answer"],
    isExpanded: json["isExpanded"] ?? false,
    sortOrder: json["sortOrder"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "category": category,
    "answer": answer,
    "isExpanded": isExpanded,
    "sortOrder": sortOrder,
  };
}

enum AppType {
  CUSTOMER
}

final appTypeValues = EnumValues({
  "CUSTOMER": AppType.CUSTOMER
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
