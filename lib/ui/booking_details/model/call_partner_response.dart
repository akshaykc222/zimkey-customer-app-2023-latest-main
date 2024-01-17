



import 'dart:convert';


CallPartnerResponse singleBookingDetailResponseFromJson(String str) => CallPartnerResponse.fromJson(json.decode(str));

String singleBookingDetailResponseToJson(CallPartnerResponse data) => json.encode(data.toJson());

class CallPartnerResponse {
  final String? callPartnerCustomer;

  CallPartnerResponse({
     this.callPartnerCustomer,
  });

  factory CallPartnerResponse.fromJson(Map<String, dynamic> json) => CallPartnerResponse(
    callPartnerCustomer:json["callPartnerCustomer"],
  );

  Map<String, dynamic> toJson() => {
    "callPartnerCustomer": callPartnerCustomer,
  };
}

