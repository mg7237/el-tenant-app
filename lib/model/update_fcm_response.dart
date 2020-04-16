// To parse this JSON data, do
//
//     final updateFcmResponse = updateFcmResponseFromJson(jsonString);

import 'dart:convert';

UpdateFcmResponse updateFcmResponseFromJson(String str) => UpdateFcmResponse.fromJson(json.decode(str));

String updateFcmResponseToJson(UpdateFcmResponse data) => json.encode(data.toJson());

class UpdateFcmResponse {
  bool status;
  String message;

  UpdateFcmResponse({
    this.status,
    this.message,
  });

  factory UpdateFcmResponse.fromJson(Map<String, dynamic> json) => UpdateFcmResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
