import 'dart:convert';

DeleteAttachmentResponse deleteAttachmentResponseFromJson(String str) => DeleteAttachmentResponse.fromJson(json.decode(str));

String deleteAttachmentResponseToJson(DeleteAttachmentResponse data) => json.encode(data.toJson());

class DeleteAttachmentResponse {
  bool status;
  String message;

  DeleteAttachmentResponse({
    this.status,
    this.message,
  });

  factory DeleteAttachmentResponse.fromJson(Map<String, dynamic> json) => new DeleteAttachmentResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
