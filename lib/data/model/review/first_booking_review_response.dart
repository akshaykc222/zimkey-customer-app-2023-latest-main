// To parse this JSON data, do
//
//     final firstBookingReviewResponse = firstBookingReviewResponseFromJson(jsonString);

import 'dart:convert';

FirstBookingReviewResponse firstBookingReviewResponseFromJson(String str) => FirstBookingReviewResponse.fromJson(json.decode(str));

String firstBookingReviewResponseToJson(FirstBookingReviewResponse data) => json.encode(data.toJson());

class FirstBookingReviewResponse {
  final AddReview addReview;

  FirstBookingReviewResponse({
    required this.addReview,
  });

  factory FirstBookingReviewResponse.fromJson(Map<String, dynamic> json) => FirstBookingReviewResponse(
    addReview: AddReview.fromJson(json["addReview"]),
  );

  Map<String, dynamic> toJson() => {
    "addReview": addReview.toJson(),
  };
}

class AddReview {
  final String id;
  final dynamic rating;
  final dynamic review;

  AddReview({
    required this.id,
    required this.rating,
    required this.review,
  });

  factory AddReview.fromJson(Map<String, dynamic> json) => AddReview(
    id: json["id"],
    rating: json["rating"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rating": rating,
    "review": review,
  };
}
