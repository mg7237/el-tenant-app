import 'package:email_validator/email_validator.dart';

class UpdateEmergencyDetailsRequest{
  String contactName='';
  String contactEmail='';
  String contactPhone='';

  UpdateEmergencyDetailsRequest({this.contactName, this.contactEmail, this.contactPhone});

  Map<String, dynamic> toMap() => {
    "contactName": contactName == null ? null : contactName,
    "contactEmail": contactEmail == null ? null : contactEmail,
    "contactPhone": contactPhone == null ? null : contactPhone,

  };

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

}