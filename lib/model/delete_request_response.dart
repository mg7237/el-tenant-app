import 'dart:convert';

DeleteRequestResponse deleteRequestResponseFromJson(String str) => DeleteRequestResponse.fromJson(json.decode(str));

String deleteRequestResponseToJson(DeleteRequestResponse data) => json.encode(data.toJson());

class DeleteRequestResponse {
  bool status;
  String message;

  DeleteRequestResponse({
    this.status,
    this.message,
  });

  factory DeleteRequestResponse.fromJson(Map<String, dynamic> json) => new DeleteRequestResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
