import 'package:easyleases_tenant/screen/about_app_page.dart';
import 'package:easyleases_tenant/screen/about_us_page.dart';
import 'package:easyleases_tenant/screen/splash_screen.dart';
import 'package:easyleases_tenant/screen/web_page.dart';
import 'package:easyleases_tenant/util/preference_connector.dart';
import 'package:easyleases_tenant/util/route_setting.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          ListTile(
            title: Text("About Us"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AboutUsPage()));
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          ListTile(
            title: Text("About App"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AboutAppPage()));
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          ListTile(
            title: Text("FAQ"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      WebPage('FAQ', 'https://www.easyleases.in/faq')));
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          ListTile(
            title: Text("Privacy Policy"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WebPage('Privacy Policy',
                      'https://www.easyleases.in/privacy-policy')));
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          ListTile(
            title: Text("Terms & Conditions"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WebPage('Terms & Conditions',
                      'https://www.easyleases.in/terms-and-condition')));
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          ListTile(
            title: Text("Support Person"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, SUPPORT_PERSON_DETAILS);
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          ListTile(
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              logoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  logoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Are you sure, you want to logout?"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  PreferenceConnector()
                      .setBool(PreferenceConnector.REMEMBER_ME_STATUS, false);
                  final FirebaseMessaging _fireBaseMessaging = FirebaseMessaging();
                  _fireBaseMessaging.unsubscribeFromTopic('applicants');
                  _fireBaseMessaging.unsubscribeFromTopic('tenants');
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                      (Route<dynamic> route) => false);
                },
              )
            ],
          );
        });
  }
}
