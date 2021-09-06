import 'dart:io';

import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/secrets.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginView extends StatefulWidget {
  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final AuthController auth = Get.find();
  final RedditController reddit = Get.find();

  late WebViewController _webController;

  final String authUrl = 'https://www.reddit.com/api/v1/authorize.compact?' +
      'client_id=$clientId&response_type=code&state=$codeVerifier' +
      '&duration=permanent&redirect_uri=$redirectUri' +
      '&scope=identity edit flair history modconfig modflair modlog modposts ' +
      'modwiki mysubreddits privatemessages read report save submit subscribe ' +
      'vote wikiedit wikiread';

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  NavigationDecision handleNav(NavigationRequest request) {
    if (request.url.contains(redirectUri) &&
        !request.url.contains('www.reddit.com')) {
      handleAuth(request.url);
      return NavigationDecision.prevent;
    } else {
      return NavigationDecision.navigate;
    }
  }

  Future<void> handleAuth(String url) async {
    await auth.setAuthToken(url);
    await reddit.initFeed();

    Get.back();
  }

  void setController(WebViewController controller) {
    _webController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: authUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: setController,
          userAgent: userAgent,
          navigationDelegate: handleNav,
        ),
      ),
    );
  }
}
