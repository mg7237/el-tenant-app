// To parse this JSON data, do
//
//     final deleteUserDocumentsResponse = deleteUserDocumentsResponseFromJson(jsonString);

import 'dart:convert';

DeleteUserDocumentsResponse deleteUserDocumentsResponseFromJson(String str) => DeleteUserDocumentsResponse.fromJson(json.decode(str));

String deleteUserDocumentsResponseToJson(DeleteUserDocumentsResponse data) => json.encode(data.toJson());

class DeleteUserDocumentsResponse {
  bool status;
  String message;

  DeleteUserDocumentsResponse({
    this.status,
    this.message,
  });

  factory DeleteUserDocumentsResponse.fromJson(Map<String, dynamic> json) => DeleteUserDocumentsResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
