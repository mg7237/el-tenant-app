import 'dart:io';

import 'package:email_validator/email_validator.dart';

class UpdateEmploymentDetailsRequest {
  String employerName='';
  String employeeId='';
  String employerEmail='';
  String employmentStartDate='';
  File employmentProof;

  UpdateEmploymentDetailsRequest(
      {this.employerName, this.employeeId, this.employerEmail, this.employmentStartDate, this.employmentProof});

  String emailValidate(String value) {
    if (value.isNotEmpty) {
      if (EmailValidator.validate(value)) {
        return null;
      } else {
        return "Enter valid email.";
      }
    } else {
      return null;
    }
  }

  String startDateValidate(String value) {
    if (value.isNotEmpty&&value!=null) {
      return null;
    } else {
      return "Enter Employment Start Date.";
    }
  }

}
