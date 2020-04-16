// To parse this JSON data, do
//
//     final updateUserDocumentsResponse = updateUserDocumentsResponseFromJson(jsonString);

import 'dart:convert';

UpdateUserDocumentsResponse updateUserDocumentsResponseFromJson(String str) => UpdateUserDocumentsResponse.fromJson(json.decode(str));

String updateUserDocumentsResponseToJson(UpdateUserDocumentsResponse data) => json.encode(data.toJson());

class UpdateUserDocumentsResponse {
  bool status;
  String message;
  int documentId;

  UpdateUserDocumentsResponse({
    this.status,
    this.message,
    this.documentId,
  });

  factory UpdateUserDocumentsResponse.fromJson(Map<String, dynamic> json) => UpdateUserDocumentsResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    documentId: json["documentId"] == null ? null : json["documentId"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "documentId": documentId == null ? null : documentId,
  };
}
