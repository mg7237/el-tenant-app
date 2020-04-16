// To parse this JSON data, do
//
//     final serviceRequestResponse = serviceRequestResponseFromJson(jsonString);

import 'dart:convert';

ServiceRequestResponse serviceRequestResponseFromJson(String str) => ServiceRequestResponse.fromJson(json.decode(str));

String serviceRequestResponseToJson(ServiceRequestResponse data) => json.encode(data.toJson());

class ServiceRequestResponse {
  bool status;
  String message;
  List<SrList> srList;

  ServiceRequestResponse({
    this.status,
    this.message,
    this.srList,
  });

  factory ServiceRequestResponse.fromJson(Map<String, dynamic> json) => new ServiceRequestResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    srList: json["srList"] == null ? null : new List<SrList>.from(json["srList"].map((x) => SrList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "srList": srList == null ? null : new List<dynamic>.from(srList.map((x) => x.toJson())),
  };
}

class SrList {
  int srId;
  String title;
  String updateDate;
  String status;
  String type;
  String supportName;
  String supportEmail;
  String supportContact;

  SrList({
    this.srId,
    this.title,
    this.updateDate,
    this.status,
    this.type,
    this.supportName,
    this.supportEmail,
    this.supportContact,
  });

  factory SrList.fromJson(Map<String, dynamic> json) => new SrList(
    srId: json["srId"] == null ? null : json["srId"],
    title: json["title"] == null ? null : json["title"],
    updateDate: json["updateDate"] == null ? null : json["updateDate"],
    status: json["status"] == null ? null : json["status"],
    type: json["type"] == null ? null : json["type"],
    supportName: json["supportName"] == null ? null : json["supportName"],
    supportEmail: json["supportEmail"] == null ? null : json["supportEmail"],
    supportContact: json["supportContact"] == null ? null : json["supportContact"],
  );

  Map<String, dynamic> toJson() => {
    "srId": srId == null ? null : srId,
    "title": title == null ? null : title,
    "updateDate": updateDate == null ? null : updateDate,
    "status": status == null ? null : status,
    "type": type == null ? null : type,
    "supportName": supportName == null ? null : supportName,
    "supportEmail": supportEmail == null ? null : supportEmail,
    "supportContact": supportContact == null ? null : supportContact,
  };
}
