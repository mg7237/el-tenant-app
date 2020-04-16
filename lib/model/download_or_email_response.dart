import 'dart:convert';

DownloadOrEmailResponse downloadOrEmailResponseFromJson(String str) => DownloadOrEmailResponse.fromJson(json.decode(str));

String downloadOrEmailResponseToJson(DownloadOrEmailResponse data) => json.encode(data.toJson());

class DownloadOrEmailResponse {
  String docUrl;
  bool status;
  String message;

  DownloadOrEmailResponse({
    this.docUrl,
    this.status,
    this.message,
  });

  factory DownloadOrEmailResponse.fromJson(Map<String, dynamic> json) => new DownloadOrEmailResponse(
    docUrl: json["docURL"] == null ? null : json["docURL"],
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "docURL": docUrl == null ? null : docUrl,
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
