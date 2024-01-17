// To parse this JSON data, do
//
//     final appConfigResponse = appConfigResponseFromJson(jsonString);

import 'dart:convert';

AppConfigResponse appConfigResponseFromJson(String str) => AppConfigResponse.fromJson(json.decode(str));

String appConfigResponseToJson(AppConfigResponse data) => json.encode(data.toJson());

class AppConfigResponse {
  final GetAppConfig getAppConfig;

  AppConfigResponse({
    required this.getAppConfig,
  });

  factory AppConfigResponse.fromJson(Map<String, dynamic> json) => AppConfigResponse(
    getAppConfig: GetAppConfig.fromJson(json["getAppConfig"]),
  );

  Map<String, dynamic> toJson() => {
    "getAppConfig": getAppConfig.toJson(),
  };
}

class GetAppConfig {
  final String androidVersion;
  final String androidAppPath;
  final bool androidMMode;
  final String iosVersion;
  final String iosAppPath;
  final bool iosMMode;
  final String appModule;

  GetAppConfig({
    required this.androidVersion,
    required this.androidAppPath,
    required this.androidMMode,
    required this.iosVersion,
    required this.iosAppPath,
    required this.iosMMode,
    required this.appModule,
  });

  factory GetAppConfig.fromJson(Map<String, dynamic> json) => GetAppConfig(
    androidVersion: json["androidVersion"],
    androidAppPath: json["androidAppPath"],
    androidMMode: json["androidMMode"],
    iosVersion: json["iosVersion"],
    iosAppPath: json["iosAppPath"],
    iosMMode: json["iosMMode"],
    appModule: json["appModule"],
  );

  Map<String, dynamic> toJson() => {
    "androidVersion": androidVersion,
    "androidAppPath": androidAppPath,
    "androidMMode": androidMMode,
    "iosVersion": iosVersion,
    "iosAppPath": iosAppPath,
    "iosMMode": iosMMode,
    "appModule": appModule,
  };
}
