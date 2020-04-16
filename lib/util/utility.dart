import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

class Utility {
  static void showSuccessSnackBar(
      GlobalKey<ScaffoldState> scaffoldState, String message,
      {Color color}) {
    if (color == null) {
      color = Colors.green[900];
    }
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    if (scaffoldState.currentState != null) {
      scaffoldState.currentState.showSnackBar(snackBar);
    }
  }

  static void showErrorSnackBar(
      GlobalKey<ScaffoldState> scaffoldState, String message,
      {Color color}) {
    if (color == null) {
      color = Colors.red[900];
    }
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    if (scaffoldState.currentState != null) {
      scaffoldState.currentState.removeCurrentSnackBar();
      scaffoldState.currentState.showSnackBar(snackBar);
    }
  }

  static String getFilterNumber(String x) {
    var lastThree = x.substring(x.length - 3);
    var otherNumbers = x.substring(0, x.length - 3);
    if (otherNumbers != '') lastThree = ',' + lastThree;
    var res = otherNumbers.replaceAll(RegExp("\\B(?=(\\d{2})+(?!\\d))"), ",") +
        lastThree;
    return res;
  }

  static String getFilerExtension(String x) {
    var lastThree = x.substring(x.length - 3);
    var otherNumbers = x.substring(0, x.length - 3);
    if (otherNumbers != '') lastThree = lastThree;
    var res = lastThree;
    return res;
  }
  

}
