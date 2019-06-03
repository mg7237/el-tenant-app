import 'package:easyleases_tenant/screen/forgot_password_page.dart';
import 'package:easyleases_tenant/screen/home_page.dart';
import 'package:easyleases_tenant/screen/login_page.dart';
import 'package:easyleases_tenant/screen/splash_screen.dart';
import 'package:easyleases_tenant/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Easyleases Tenant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF427BFF),
        accentColor: const Color(0xFFDC3545),
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/HomePage': (BuildContext context) => HomePage(),
        '/LoginPage': (BuildContext context) => LoginPage(),
        '/ForgotPassword': (BuildContext context) => ForgotPasswordPage()
      },
    );
  }
}
