import 'dart:async';

import 'package:easyleases_tenant/screen/bank_details.dart';
import 'package:easyleases_tenant/screen/dashboard_page.dart';
import 'package:easyleases_tenant/screen/emergency_contact.dart';
import 'package:easyleases_tenant/screen/employment_data.dart';
import 'package:easyleases_tenant/screen/forgot_password_init_page.dart';
import 'package:easyleases_tenant/screen/forgot_password_page.dart';
import 'package:easyleases_tenant/screen/home_page.dart';
import 'package:easyleases_tenant/screen/login_page.dart';
import 'package:easyleases_tenant/screen/my_documents.dart';
import 'package:easyleases_tenant/screen/service_request/requests_page.dart';
import 'package:easyleases_tenant/screen/splash_screen.dart';
import 'package:easyleases_tenant/screen/suport_person_details.dart';
import 'package:easyleases_tenant/util/hex_color.dart';
import 'package:easyleases_tenant/util/route_setting.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription subscription;
  bool showNoInternet = false;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showNoInternet = true;
      } else {
        showNoInternet = false;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return OverlaySupport(
      child: MaterialApp(
        title: 'Easyleases Tenant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: HexColor("#427BFF"),
          accentColor: HexColor("#DC3545"),
        ),
        builder: (context, child) {
          return showNoInternet ? NoInternet() : child;
        },
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          HOME_PAGE: (BuildContext context) => HomePage(),
          LOGIN: (BuildContext context) => LoginPage(),
          FORGOT_PASSWORD_INIT: (BuildContext context) =>
              ForgotPasswordInitPage(),
          FORGOT_PASSWORD: (BuildContext context) => ForgotPasswordPage(),
          MY_DOCUMENTS: (BuildContext context) => MyDocuments(),
          BANK_DETAILS: (BuildContext context) => BankDetails(),
          EMPLOYMENT_DATA: (BuildContext context) => EmploymentData(),
          EMERGENCY_CONTACT: (BuildContext context) => EmergencyContact(),
          SUPPORT_PERSON_DETAILS: (BuildContext context) => SupportPersonDetails(),
          REQUESTS_PAGE: (BuildContext context) => RequestsPage(),

        },
      ),
    );
  }
}

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset("assets/icon/login_logo.png"),
            Image.asset("assets/no_internet.png"),
          ],
        ),
      ),
    );
  }
}
