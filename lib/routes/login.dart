import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';

class WebLogin extends StatefulWidget {
  const WebLogin({Key? key}) : super(key: key);

  @override
  _WebLoginState createState() => _WebLoginState();
}

class _WebLoginState extends State<WebLogin> {
  final AuthController auth = Get.find();
  final RedditController reddit = Get.find();

  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  final String authUrl = 'https://www.reddit.com/api/v1/authorize.compact?' +
      'client_id=$clientId&response_type=code&state=$codeVerifier' +
      '&duration=permanent&redirect_uri=$redirectUri' +
      '&scope=identity edit flair history modconfig modflair modlog modposts ' +
      'modwiki mysubreddits privatemessages read report save submit subscribe ' +
      'vote wikiedit wikiread';

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (url.contains(redirectUri) && !url.contains('www.reddit.com')) {
        flutterWebviewPlugin.close();

        await auth.setAuthToken(url);
        await reddit.getSubscriptions();

        Get.back();
      }
    });
  }

  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: authUrl,
      userAgent: userAgent,
      appBar: AppBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
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
