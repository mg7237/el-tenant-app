import 'dart:convert';

PastPaymentResponse pastPaymentResponseFromJson(String str) => PastPaymentResponse.fromJson(json.decode(str));

String pastPaymentResponseToJson(PastPaymentResponse data) => json.encode(data.toJson());

class PastPaymentResponse {
  bool status;
  String message;
  List<PaymentsDueList> paymentsDueList;

  PastPaymentResponse({
    this.status,
    this.message,
    this.paymentsDueList,
  });

  factory PastPaymentResponse.fromJson(Map<String, dynamic> json) => new PastPaymentResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    paymentsDueList: json["paymentsDueList"] == null ? null : new List<PaymentsDueList>.from(json["paymentsDueList"].map((x) => PaymentsDueList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "paymentsDueList": paymentsDueList == null ? null : new List<dynamic>.from(paymentsDueList.map((x) => x.toJson())),
  };
}

class PaymentsDueList {
  int paymentRowid;
  String dueDate;
  int paymentType;
  String title;
  String originalAmount;
  String penaltyAmount;
  String totalAmount;

  PaymentsDueList({
    this.paymentRowid,
    this.dueDate,
    this.paymentType,
    this.title,
    this.originalAmount,
    this.penaltyAmount,
    this.totalAmount,
  });

  factory PaymentsDueList.fromJson(Map<String, dynamic> json) => new PaymentsDueList(
    paymentRowid: json["paymentRowid"] == null ? null : json["paymentRowid"],
    dueDate: json["dueDate"] == null ? null : json["dueDate"],
    paymentType: json["paymentType"] == null ? null : json["paymentType"],
    title: json["title"] == null ? null : json["title"],
    originalAmount: json["originalAmount"] == null ? null : json["originalAmount"].toString(),
    penaltyAmount: json["penaltyAmount"] == null ? null : json["penaltyAmount"].toString(),
    totalAmount: json["totalAmount"] == null ? null : json["totalAmount"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "paymentRowid": paymentRowid == null ? null : paymentRowid,
    "dueDate": dueDate == null ? null : dueDate,
    "paymentType": paymentType == null ? null : paymentType,
    "title": title == null ? null : title,
    "originalAmount": originalAmount == null ? null : originalAmount,
    "penaltyAmount": penaltyAmount == null ? null : penaltyAmount,
    "totalAmount": totalAmount == null ? null : totalAmount,
  };
}