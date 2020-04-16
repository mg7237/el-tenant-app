// To parse this JSON data, do
//
//     final getUserDocumentsResponse = getUserDocumentsResponseFromJson(jsonString);

import 'dart:convert';

GetUserDocumentsResponse getUserDocumentsResponseFromJson(String str) => GetUserDocumentsResponse.fromJson(json.decode(str));

String getUserDocumentsResponseToJson(GetUserDocumentsResponse data) => json.encode(data.toJson());

class GetUserDocumentsResponse {
  bool status;
  String message;
  List<UserDocument> userDocuments;

  GetUserDocumentsResponse({
    this.status,
    this.message,
    this.userDocuments,
  });

  factory GetUserDocumentsResponse.fromJson(Map<String, dynamic> json) => GetUserDocumentsResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    userDocuments: json["userDocuments"] == null ? null : List<UserDocument>.from(json["userDocuments"].map((x) => UserDocument.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "userDocuments": userDocuments == null ? null : List<dynamic>.from(userDocuments.map((x) => x.toJson())),
  };
}

class UserDocument {
  int id;
  String proofType;
  String proofUrl;

  UserDocument({
    this.id,
    this.proofType,
    this.proofUrl,
  });

  factory UserDocument.fromJson(Map<String, dynamic> json) => UserDocument(
    id: json["id"] == null ? null : json["id"],
    proofType: json["proofType"] == null ? null : json["proofType"],
    proofUrl: json["proofURL"] == null ? null : json["proofURL"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "proofType": proofType == null ? null : proofType,
    "proofURL": proofUrl == null ? null : proofUrl,
  };
}
