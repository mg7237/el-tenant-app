import 'dart:io';

import 'package:email_validator/email_validator.dart';

class EditProfileRequest {
  String userId;
  String name;
  String email;
  String phone;
  String addLine1;
  String addLine2;
  String city;
  String stateCode;
  String pinCode;
  File profilePic;

  EditProfileRequest({this.userId,this.name, this.email, this.phone, this.addLine1,
      this.addLine2, this.city, this.stateCode, this.pinCode,this.profilePic});


  /// To validate name in my profile form
  String nameValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your email.";
    }
  }

  /// To validate email in login form
  String emailValidate(String value) {
    if (value.isNotEmpty) {
      if (EmailValidator.validate(value)) {
        return null;
      } else {
        return "Enter valid email.";
      }
    } else {
      return "Enter your email.";
    }
  }

  /// To validate phone number in my profile form
  String numberValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your phone number.";
    }
  }

  /// To validate address line 1 in my profile form
  String addressLine1Validate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your address line 1.";
    }
  }

  /// To validate address line 2 in my profile form
  String addressLine2Validate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your address line 2.";
    }
  }

  /// To validate City in my profile form
  String cityValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your city.";
    }
  }

  /// To validate StateCode in my profile form
  String stateCodeValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your state code.";
    }
  }

  /// To validate Pin Code in my profile form
  String pinCodeValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your pin code.";
    }
  }
}
