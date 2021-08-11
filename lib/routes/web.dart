import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';

class WebView extends StatefulWidget {
  const WebView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.indigo[300],
        leading: IconButton(
          onPressed: () {
            flutterWebviewPlugin.close();
            Get.back();
          },
          icon: Icon(Icons.close),
        ),
      ),
    );
  }
}
