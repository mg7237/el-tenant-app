import 'dart:convert';

CommentResponse commentResponseFromJson(String str) => CommentResponse.fromJson(json.decode(str));

String commentResponseToJson(CommentResponse data) => json.encode(data.toJson());

class CommentResponse {
  bool status;
  String message;

  CommentResponse({
    this.status,
    this.message,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) => new CommentResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
