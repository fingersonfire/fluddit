import 'package:fluddit/secrets.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatelessWidget {
  const WebPage({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 50,
        leading: const NavBackButton(),
        actions: <Widget>[
          ShareButton(url: url),
          BrowserButton(url: url),
        ],
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: userAgent,
      ),
    );
  }
}
