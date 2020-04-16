import 'package:email_validator/email_validator.dart';

class UpdateProfileRequest {
  String name;
  String email;
  String phoneNumber;
  String unitNo;
  String addressLine1;
  String addressLine2;
  String city;
  String stateCode;
  String pinCode;

  UpdateProfileRequest({
    this.name,
    this.email,
    this.phoneNumber,
    this.unitNo,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.stateCode,
    this.pinCode,
  });

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "unit_no": unitNo == null ? null : unitNo,
        "address_line_1": addressLine1 == null ? null : addressLine1,
        "address_line_2": addressLine2 == null ? null : addressLine2,
        "City": city == null ? null : city,
        "State_Code": stateCode == null ? null : stateCode,
        "Pin_Code": pinCode == null ? null : pinCode,
      };

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
