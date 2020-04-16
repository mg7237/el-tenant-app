import 'dart:convert';

AgreementResponse agreementResponseFromJson(String str) => AgreementResponse.fromJson(json.decode(str));

String agreementResponseToJson(AgreementResponse data) => json.encode(data.toJson());

class AgreementResponse {
  bool status;
  String message;
  List<PaymentsDueList> paymentsDueList;

  AgreementResponse({
    this.status,
    this.message,
    this.paymentsDueList,
  });

  factory AgreementResponse.fromJson(Map<String, dynamic> json) => new AgreementResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    paymentsDueList: json["agreements"] == null ? null : new List<PaymentsDueList>.from(json["agreements"].map((x) => PaymentsDueList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "paymentsDueList": paymentsDueList == null ? null : new List<dynamic>.from(paymentsDueList.map((x) => x.toJson())),
  };
}

class PaymentsDueList {
  bool showLoader;
  String propertyId;
  String rent;
  String maintenance;
  String deposit;
  String leaseStartDate;
  String leaseEndDate;
  String minimumStay;
  String noticePeriod;
  String lateFeeCharges;
  String lateFeeMinAmount;
  String propertyName;
  String agreementUrl;

  PaymentsDueList({
    this.showLoader,
    this.propertyId,
    this.rent,
    this.maintenance,
    this.deposit,
    this.leaseStartDate,
    this.leaseEndDate,
    this.minimumStay,
    this.noticePeriod,
    this.lateFeeCharges,
    this.lateFeeMinAmount,
    this.propertyName,
    this.agreementUrl,
  });

  factory PaymentsDueList.fromJson(Map<String, dynamic> json) => new PaymentsDueList(
   showLoader: false,
    propertyId: json["propertyId"] == null ? null : json["propertyId"].toString(),
    rent: json["rent"] == null ? null : json["rent"].toString(),
    maintenance: json["maintenance"] == null ? null : json["maintenance"].toString(),
    deposit: json["deposit"] == null ? null : json["deposit"].toString(),
    leaseStartDate: json["leaseStartDate"] == null ? null : json["leaseStartDate"].toString(),
    leaseEndDate: json["leaseEndDate"] == null ? null : json["leaseEndDate"].toString(),
    minimumStay: json["minimumStay"] == null ? null : json["minimumStay"].toString(),
    noticePeriod: json["noticePeriod"] == null ? null : json["noticePeriod"].toString(),
    lateFeeCharges: json["lateFeeCharges"] == null ? null : json["lateFeeCharges"].toString(),
    lateFeeMinAmount: json["lateFeeMinAmount"] == null ? null : json["lateFeeMinAmount"].toString(),
    propertyName: json["propertyName"] == null ? null : json["propertyName"].toString(),
    agreementUrl: json["agreementURL"] == null ? null : json["agreementURL"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "rent": rent == null ? null : rent,
    "maintenance": maintenance == null ? null : maintenance,
    "deposit": deposit == null ? null : deposit,
    "leaseStartDate": leaseStartDate == null ? null : leaseStartDate,
    "leaseEndDate": leaseEndDate == null ? null : leaseEndDate,
    "minimumStay": minimumStay == null ? null : minimumStay,
    "noticePeriod": noticePeriod == null ? null : noticePeriod,
    "lateFeeCharges": lateFeeCharges == null ? null : lateFeeCharges,
    "lateFeeMinAmount": lateFeeMinAmount == null ? null : lateFeeMinAmount,
    "propertyName": propertyName == null ? null : propertyName,
    "agreementURL": agreementUrl == null ? null : agreementUrl,
  };
}
