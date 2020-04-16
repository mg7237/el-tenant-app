// To parse this JSON data, do
//
//     final updateBankDetailsResponse = updateBankDetailsResponseFromJson(jsonString);

import 'dart:convert';

UpdateBankDetailsResponse updateBankDetailsResponseFromJson(String str) => UpdateBankDetailsResponse.fromJson(json.decode(str));

String updateBankDetailsResponseToJson(UpdateBankDetailsResponse data) => json.encode(data.toJson());

class UpdateBankDetailsResponse {
  bool status;
  String message;

  UpdateBankDetailsResponse({
    this.status,
    this.message,
  });

  factory UpdateBankDetailsResponse.fromJson(Map<String, dynamic> json) => UpdateBankDetailsResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
