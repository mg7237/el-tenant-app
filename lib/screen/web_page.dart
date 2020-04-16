import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebPage extends StatelessWidget {

  final String title;
  final String url;

  WebPage(this.title, this.url);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      withJavascript: true,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
    );
  }
}
