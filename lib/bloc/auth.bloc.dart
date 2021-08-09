import 'dart:convert';

import 'package:fluddit/secrets.dart';
import 'package:http/http.dart' as HTTP;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final Uri authUrl = Uri.parse('https://www.reddit.com/api/v1/access_token');

  Future refreshAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // TODO: Add request to fetch new bearer using refresh_token.
  }

  /// Gets Reddit auth token.
  Future setAuthToken(String url) async {
    // Starts the getInstance function while making time consuming requests.
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();

    final String _query = url.split('$redirectUri/')[1];
    final Map<String, dynamic> _result = Uri.splitQueryString(_query);

    final HTTP.Response _resp = await HTTP.post(
      authUrl,
      headers: {
        'Authorization': 'basic $basicAuth',
        'Content-Type': 'application/x-www-form-urlencoded',
        'User-Agent': userAgent,
      },
      body: {
        'grant_type': 'authorization_code',
        'redirect_uri': redirectUri,
        // Figuring out the split was needed to get a working code took quite
        // a bit of time. Shout out to iOS for making it easy to setup proxy
        // certs and other projects for figuring out the code before me.
        'code': _result['code'].split('#_')[0],
      },
    );

    Map<String, dynamic> _json = jsonDecode(_resp.body);

    // Await the results of the getInstance function called earlier.
    SharedPreferences instance = await prefs;
    await instance.setString('access_token', _json['access_token']);
    await instance.setString('refresh_token', _json['refresh_token']);
  }
}
