// To parse this JSON data, do
//
//     final statusListResponse = statusListResponseFromJson(jsonString);

import 'dart:convert';

StatusListResponse statusListResponseFromJson(String str) => StatusListResponse.fromJson(json.decode(str));

String statusListResponseToJson(StatusListResponse data) => json.encode(data.toJson());

class StatusListResponse {
  bool status;
  String message;
  List<StatusList> statusList;

  StatusListResponse({
    this.status,
    this.message,
    this.statusList,
  });

  factory StatusListResponse.fromJson(Map<String, dynamic> json) => new StatusListResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    statusList: json["statusList"] == null ? null : new List<StatusList>.from(json["statusList"].map((x) => StatusList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "statusList": statusList == null ? null : new List<dynamic>.from(statusList.map((x) => x.toJson())),
  };
}

class StatusList {
  int id;
  String name;

  StatusList({
    this.id,
    this.name,
  });

  factory StatusList.fromJson(Map<String, dynamic> json) => new StatusList(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
  };
}
