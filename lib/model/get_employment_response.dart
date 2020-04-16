// To parse this JSON data, do
//
//     final employmentResponse = employmentResponseFromJson(jsonString);

import 'dart:convert';

EmploymentResponse employmentResponseFromJson(String str) => EmploymentResponse.fromJson(json.decode(str));

String employmentResponseToJson(EmploymentResponse data) => json.encode(data.toJson());

class EmploymentResponse {
  String employerName;
  String employerEmail;
  String employeeId;
  String employmentStartDate;
  String employmentProofUrl;
  bool status;
  String message;

  EmploymentResponse({
    this.employerName,
    this.employerEmail,
    this.employeeId,
    this.employmentStartDate,
    this.employmentProofUrl,
    this.status,
    this.message,
  });

  factory EmploymentResponse.fromJson(Map<String, dynamic> json) => EmploymentResponse(
    employerName: json["employerName"] == null ? null : json["employerName"],
    employerEmail: json["employerEmail"] == null ? null : json["employerEmail"],
    employeeId: json["employeeId"] == null ? null : json["employeeId"],
    employmentStartDate: json["employmentStartDate"] == null ? null : json["employmentStartDate"],
    employmentProofUrl: json["employmentProofURL"] == null ? null : json["employmentProofURL"],
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "employerName": employerName == null ? null : employerName,
    "employerEmail": employerEmail == null ? null : employerEmail,
    "employeeId": employeeId == null ? null : employeeId,
    "employmentStartDate": employmentStartDate == null ? null : employmentStartDate,
    "employmentProofURL": employmentProofUrl == null ? null : employmentProofUrl,
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
