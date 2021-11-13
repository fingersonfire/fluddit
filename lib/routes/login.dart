import 'dart:io';

import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/secrets.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final AuthController auth = Get.find();
  final RedditController reddit = Get.find();

  final String authUrl = 'https://www.reddit.com/api/v1/authorize.compact?'
      'client_id=$clientId&response_type=code&state=$codeVerifier'
      '&duration=permanent&redirect_uri=$redirectUri'
      '&scope=identity%20edit%20flair%20history%20modconfig%20modflair%20modlog%20modposts%20'
      'modwiki%20mysubreddits%20privatemessages%20read%20report%20save%20submit%20subscribe%20'
      'vote%20wikiedit%20wikiread';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          onWebViewCreated: (WebViewController controller) {
            controller.clearCache();
          },
          initialUrl: authUrl,
          javascriptMode: JavascriptMode.unrestricted,
          userAgent: userAgent,
          navigationDelegate: handleNav,
        ),
      ),
    );
  }
}
