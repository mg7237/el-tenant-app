import 'dart:convert';

DashboardResponse dashboardResponseFromJson(String str) => DashboardResponse.fromJson(json.decode(str));

String dashboardResponseToJson(DashboardResponse data) => json.encode(data.toJson());

class DashboardResponse {
  String paymentOverdue;
  String upcomingPayment;
  String dayesToExpiry;
  String propertyName;
  String depositAmount;

  DashboardResponse({
    this.paymentOverdue,
    this.upcomingPayment,
    this.dayesToExpiry,
    this.propertyName,
    this.depositAmount,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) => new DashboardResponse(
    paymentOverdue: json["paymentOverdue"] == null ? null : json["paymentOverdue"].toString(),
    upcomingPayment: json["upcomingPayment"] == null ? null : json["upcomingPayment"].toString(),
    dayesToExpiry: json["dayesToExpiry"] == null ? null : json["dayesToExpiry"].toString(),
    propertyName: json["propertyName"] == null ? null : json["propertyName"].toString(),
    depositAmount: json["depositAmount"] == null ? null : json["depositAmount"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "paymentOverdue": paymentOverdue == null ? null : paymentOverdue,
    "upcomingPayment": upcomingPayment == null ? null : upcomingPayment,
    "dayesToExpiry": dayesToExpiry == null ? null : dayesToExpiry,
    "propertyName": propertyName == null ? null : propertyName,
    "depositAmount": depositAmount == null ? null : depositAmount,
  };
}
