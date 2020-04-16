// To parse this JSON data, do
//
//     final getEmergencyDetailsResponse = getEmergencyDetailsResponseFromJson(jsonString);

import 'dart:convert';

GetEmergencyDetailsResponse getEmergencyDetailsResponseFromJson(String str) => GetEmergencyDetailsResponse.fromJson(json.decode(str));

String getEmergencyDetailsResponseToJson(GetEmergencyDetailsResponse data) => json.encode(data.toJson());

class GetEmergencyDetailsResponse {
  String name;
  String email;
  String phone;
  bool status;
  String message;

  GetEmergencyDetailsResponse({
    this.name,
    this.email,
    this.phone,
    this.status,
    this.message,
  });

  factory GetEmergencyDetailsResponse.fromJson(Map<String, dynamic> json) => GetEmergencyDetailsResponse(
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "phone": phone == null ? null : phone,
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
