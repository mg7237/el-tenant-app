import 'dart:io';

class UpdateBankDetailsRequest {
  String accountHolderName;
  String PAN;
  String bankName;
  String branchName;
  String IFSC;
  String accountNumber;
  File cancelledChequePic;

  UpdateBankDetailsRequest(
      {this.PAN,
      this.bankName,
      this.IFSC,
      this.accountHolderName,
      this.branchName,
      this.accountNumber,
      this.cancelledChequePic});

  /// To validate name
  String nameValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your name.";
    }
  }

  String panNumberValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your PAN number.";
    }
  }

  String bankNameValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter bank name.";
    }
  }

  String branchNameValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter branch name.";
    }
  }

  String iFSCValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter IFSC number.";
    }
  }

  String accountNumberValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your account number.";
    }
  }
}
