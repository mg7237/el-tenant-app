// To parse this JSON data, do
//
//     final updateEmploymentDetailsResponse = updateEmploymentDetailsResponseFromJson(jsonString);

import 'dart:convert';

UpdateEmploymentDetailsResponse updateEmploymentDetailsResponseFromJson(String str) => UpdateEmploymentDetailsResponse.fromJson(json.decode(str));

String updateEmploymentDetailsResponseToJson(UpdateEmploymentDetailsResponse data) => json.encode(data.toJson());

class UpdateEmploymentDetailsResponse {
  bool status;
  String message;

  UpdateEmploymentDetailsResponse({
    this.status,
    this.message,
  });

  factory UpdateEmploymentDetailsResponse.fromJson(Map<String, dynamic> json) => UpdateEmploymentDetailsResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
