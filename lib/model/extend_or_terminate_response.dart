import 'dart:convert';

ExtendOrTerminateResponse extendOrTerminateResponseFromJson(String str) => ExtendOrTerminateResponse.fromJson(json.decode(str));

String extendOrTerminateResponseToJson(ExtendOrTerminateResponse data) => json.encode(data.toJson());

class ExtendOrTerminateResponse {
  bool status;
  String message;

  ExtendOrTerminateResponse({
    this.status,
    this.message,
  });

  factory ExtendOrTerminateResponse.fromJson(Map<String, dynamic> json) => ExtendOrTerminateResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}