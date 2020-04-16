import 'dart:convert';

UserProfileResponse userProfileResponseFromJson(String str) => UserProfileResponse.fromJson(json.decode(str));

String userProfileResponseToJson(UserProfileResponse data) => json.encode(data.toJson());

class UserProfileResponse {
  String name;
  String email;
  String phoneNumber;
  String profilePhotoUrl;
  String unitNo;
  String addressLine1;
  String addressLine2;
  String city;
  String stateCode;
  String pinCode;

  UserProfileResponse({
    this.name,
    this.email,
    this.phoneNumber,
    this.profilePhotoUrl,
    this.unitNo,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.stateCode,
    this.pinCode,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) => new UserProfileResponse(
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    profilePhotoUrl: json["profilePhotoURL"] == null ? null : json["profilePhotoURL"],
    unitNo: json["unitNo"] == null ? null : json["unitNo"],
    addressLine1: json["addressLine1"] == null ? null : json["addressLine1"],
    addressLine2: json["addressLine2"] == null ? null : json["addressLine2"],
    city: json["city"] == null ? null : json["city"],
    stateCode: json["stateCode"] == null ? null : json["stateCode"],
    pinCode: json["pincode"].toString() == null ? null : json["pincode"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "profilePhotoURL": profilePhotoUrl == null ? null : profilePhotoUrl,
    "unitNo": unitNo == null ? null : unitNo,
    "addressLine1": addressLine1 == null ? null : addressLine1,
    "addressLine2": addressLine2 == null ? null : addressLine2,
    "city": city == null ? null : city,
    "stateCode": stateCode == null ? null : stateCode,
    "pincode": pinCode == null ? null : pinCode,
  };
}