import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebContent extends StatefulWidget {
  const WebContent({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  WebContentState createState() => WebContentState();
}

class WebContentState extends State<WebContent> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      gestureRecognizers: {
        Factory<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
        ), // or null
      },
      debuggingEnabled: true,
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: widget.url,
    );
  }
}
