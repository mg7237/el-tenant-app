import 'dart:convert';

ReversePaymentResponse reversePaymentResponseFromJson(String str) => ReversePaymentResponse.fromJson(json.decode(str));

String reversePaymentResponseToJson(ReversePaymentResponse data) => json.encode(data.toJson());

class ReversePaymentResponse {
  bool status;
  String message;


  ReversePaymentResponse({
    this.status,
    this.message
  });

  factory ReversePaymentResponse.fromJson(Map<String, dynamic> json) => new ReversePaymentResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"]
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}