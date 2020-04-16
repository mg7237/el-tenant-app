import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About App"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/launcher_icon.png",
              height: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Easyleases Tenant",
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Version : 0.0.0.5",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
