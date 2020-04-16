// To parse this JSON data, do
//
//     final getSupportPersonResponse = getSupportPersonResponseFromJson(jsonString);

import 'dart:convert';

GetSupportPersonResponse getSupportPersonResponseFromJson(String str) => GetSupportPersonResponse.fromJson(json.decode(str));

String getSupportPersonResponseToJson(GetSupportPersonResponse data) => json.encode(data.toJson());

class GetSupportPersonResponse {
  bool status;
  String name;
  String email;
  String phone;
  String profileImageUrl;
  String message;

  GetSupportPersonResponse({
    this.status,
    this.name,
    this.email,
    this.phone,
    this.profileImageUrl,
    this.message,
  });

  factory GetSupportPersonResponse.fromJson(Map<String, dynamic> json) => GetSupportPersonResponse(
    status: json["status"] == null ? null : json["status"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    profileImageUrl: json["profileImageURL"] == null ? null : json["profileImageURL"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "phone": phone == null ? null : phone,
    "profileImageURL": profileImageUrl == null ? null : profileImageUrl,
    "message": message == null ? null : message,
  };
}
