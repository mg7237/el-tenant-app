// To parse this JSON data, do
//
//     final getBankDetailsResponse = getBankDetailsResponseFromJson(jsonString);

import 'dart:convert';

GetBankDetailsResponse getBankDetailsResponseFromJson(String str) => GetBankDetailsResponse.fromJson(json.decode(str));

String getBankDetailsResponseToJson(GetBankDetailsResponse data) => json.encode(data.toJson());

class GetBankDetailsResponse {
  String pan;
  String accountHolderName;
  String bankName;
  String branchName;
  String ifsc;
  String chequeImageUrl;
  String accountNumber;
  bool status;
  String message;

  GetBankDetailsResponse({
    this.pan,
    this.accountHolderName,
    this.bankName,
    this.branchName,
    this.ifsc,
    this.chequeImageUrl,
    this.accountNumber,
    this.status,
    this.message,
  });

  factory GetBankDetailsResponse.fromJson(Map<String, dynamic> json) => GetBankDetailsResponse(
    pan: json["PAN"] == null ? null : json["PAN"],
    accountHolderName: json["accountHolderName"] == null ? null : json["accountHolderName"],
    bankName: json["bankName"] == null ? null : json["bankName"],
    branchName: json["branchName"] == null ? null : json["branchName"],
    ifsc: json["IFSC"] == null ? null : json["IFSC"],
    chequeImageUrl: json["chequeImageURL"] == null ? null : json["chequeImageURL"],
    accountNumber: json["accountNumber"] == null ? null : json["accountNumber"],
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "PAN": pan == null ? null : pan,
    "accountHolderName": accountHolderName == null ? null : accountHolderName,
    "bankName": bankName == null ? null : bankName,
    "branchName": branchName == null ? null : branchName,
    "IFSC": ifsc == null ? null : ifsc,
    "chequeImageURL": chequeImageUrl == null ? null : chequeImageUrl,
    "accountNumber": accountNumber == null ? null : accountNumber,
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
