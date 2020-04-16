
import 'dart:convert';

PropertyListResponse propertyListResponseFromJson(String str) => PropertyListResponse.fromJson(json.decode(str));

String propertyListResponseToJson(PropertyListResponse data) => json.encode(data.toJson());

class PropertyListResponse {
  bool status;
  String message;
  List<PropertyList> propertyList;

  PropertyListResponse({
    this.status,
    this.message,
    this.propertyList,
  });

  factory PropertyListResponse.fromJson(Map<String, dynamic> json) => new PropertyListResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    propertyList: json["propertyList"] == null ? null : new List<PropertyList>.from(json["propertyList"].map((x) => PropertyList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "propertyList": propertyList == null ? null : new List<dynamic>.from(propertyList.map((x) => x.toJson())),
  };
}

class PropertyList {
  String id;
  String name;

  PropertyList({
    this.id,
    this.name,
  });

  factory PropertyList.fromJson(Map<String, dynamic> json) => new PropertyList(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
  };
}
