import 'package:easyleases_tenant/api_client/api_client.dart';
import 'package:easyleases_tenant/config/config.dart';
import 'package:easyleases_tenant/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PaymentWebPage extends StatefulWidget {
  final String deviceId;
  final String keyToken;
  final int paymentRowId;

  PaymentWebPage(
    this.deviceId,
    this.keyToken,
    this.paymentRowId,
  );

  @override
  _PaymentWebPageState createState() => _PaymentWebPageState();
}

class _PaymentWebPageState extends State<PaymentWebPage> {
  bool showButton = false;
  FlutterWebviewPlugin flutterWebviewPlugin;
  bool canGoBack = false;

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      canGoBack = true;
      if (url ==
          '${ApiClient.BASE_URL}/tenant/payrent/${widget.paymentRowId}') {
        print('need to back');
        canGoBack = false;
      } else if (url == '${ApiClient.BASE_URL}/tenant/rentpaymentfailed') {
        setState(() {
          showButton = true;
        });
      } else if (url.startsWith('${ApiClient.BASE_URL}/tenant/rentpaymentsuccessneft')) {
        setState(() {
          showButton = true;
        });
      } else if (url.startsWith('${ApiClient.BASE_URL}/tenant/rentpaymentsuccess')) {
        setState(() {
          showButton = true;
        });
      }
    });
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    flutterWebviewPlugin.goBack();
    return false; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: '${ApiClient.BASE_URL}/tenant/payrent/${widget.paymentRowId}',
      headers: {
        "APPID": Config.APP_ID,
        "Platform": ApiClient.DEVICE_TYPE,
        "DeviceID": widget.deviceId,
        "Content-Type": "application/json",
        "x-api-key": widget.keyToken,
      },
      withJavascript: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Payment"),
        leading: IconButton(
            icon: Icon(showButton ? Icons.close : Icons.arrow_back),
            onPressed: () {
              if (showButton) {
                /*Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false);*/
                Navigator.of(context).pop();
              } else {
                if (canGoBack) {
                  flutterWebviewPlugin.goBack();
                } else {
                  Navigator.of(context).pop();
                }
              }
            }),
      ),
      bottomNavigationBar: showButton ? InkWell(
              onTap: () {
                Navigator.of(context).pop();
                /*Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false);*/
              },
              child: Container(
                height: 50,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    "Return",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )) : Container(height: 1)
          ,
    );
  }
}
