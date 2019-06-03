import 'package:easyleases_tenant/screen/about_app_page.dart';
import 'package:easyleases_tenant/screen/about_us_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Drawer(
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
          ],
        ),
      ),
    );
  }
}
