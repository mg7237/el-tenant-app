import 'dart:convert';

RequestTypeListResponse requestTypeListResponseFromJson(String str) => RequestTypeListResponse.fromJson(json.decode(str));

String requestTypeListResponseToJson(RequestTypeListResponse data) => json.encode(data.toJson());

class RequestTypeListResponse {
  bool status;
  String message;
  List<TypesList> typesList;

  RequestTypeListResponse({
    this.status,
    this.message,
    this.typesList,
  });

  factory RequestTypeListResponse.fromJson(Map<String, dynamic> json) => new RequestTypeListResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    typesList: json["typesList"] == null ? null : new List<TypesList>.from(json["typesList"].map((x) => TypesList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "typesList": typesList == null ? null : new List<dynamic>.from(typesList.map((x) => x.toJson())),
  };
}

class TypesList {
  String id;
  String name;

  TypesList({
    this.id,
    this.name,
  });

  factory TypesList.fromJson(Map<String, dynamic> json) => new TypesList(
    id: json["id"] == null ? null : json["id"].toString(),
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
  };
}
