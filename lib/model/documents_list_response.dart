// To parse this JSON data, do
//
//     final documentListResponse = documentListResponseFromJson(jsonString);

import 'dart:convert';

DocumentListResponse documentListResponseFromJson(String str) => DocumentListResponse.fromJson(json.decode(str));

String documentListResponseToJson(DocumentListResponse data) => json.encode(data.toJson());

class DocumentListResponse {
  List<ProofType> proofTypes;
  bool status;
  String message;

  DocumentListResponse({
    this.proofTypes,
    this.status,
    this.message,
  });

  factory DocumentListResponse.fromJson(Map<String, dynamic> json) => DocumentListResponse(
    proofTypes: json["proofTypes"] == null ? null : List<ProofType>.from(json["proofTypes"].map((x) => ProofType.fromJson(x))),
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "proofTypes": proofTypes == null ? null : List<dynamic>.from(proofTypes.map((x) => x.toJson())),
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}

class ProofType {
  String name;
  int id;

  ProofType({
    this.name,
    this.id,
  });

  factory ProofType.fromJson(Map<String, dynamic> json) => ProofType(
    name: json["name"] == null ? null : json["name"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "id": id == null ? null : id,
  };
}
