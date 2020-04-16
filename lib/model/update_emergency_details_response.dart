// To parse this JSON data, do
//
//     final updateEmergencyDetailsResponse = updateEmergencyDetailsResponseFromJson(jsonString);

import 'dart:convert';

UpdateEmergencyDetailsResponse updateEmergencyDetailsResponseFromJson(String str) => UpdateEmergencyDetailsResponse.fromJson(json.decode(str));

String updateEmergencyDetailsResponseToJson(UpdateEmergencyDetailsResponse data) => json.encode(data.toJson());

class UpdateEmergencyDetailsResponse {
  bool status;
  String message;

  UpdateEmergencyDetailsResponse({
    this.status,
    this.message,
  });

  factory UpdateEmergencyDetailsResponse.fromJson(Map<String, dynamic> json) => UpdateEmergencyDetailsResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
