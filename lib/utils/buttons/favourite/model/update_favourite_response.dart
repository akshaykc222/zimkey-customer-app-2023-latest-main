// To parse this JSON data, do
//
//     final updateFavouriteResponse = updateFavouriteResponseFromJson(jsonString);

import 'dart:convert';

UpdateFavouriteResponse updateFavouriteResponseFromJson(String str) => UpdateFavouriteResponse.fromJson(json.decode(str));

String updateFavouriteResponseToJson(UpdateFavouriteResponse data) => json.encode(data.toJson());

class UpdateFavouriteResponse {
  final bool updateFavoriteService;

  UpdateFavouriteResponse({
    required this.updateFavoriteService,
  });

  factory UpdateFavouriteResponse.fromJson(Map<String, dynamic> json) => UpdateFavouriteResponse(
    updateFavoriteService: json["updateFavoriteService"],
  );

  Map<String, dynamic> toJson() => {
    "updateFavoriteService": updateFavoriteService,
  };
}
