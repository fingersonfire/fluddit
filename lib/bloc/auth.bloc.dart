import 'dart:convert';

import 'package:fluddit/secrets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as HTTP;
import 'package:get/get.dart';

class AuthController extends GetxController {
  Future refreshAuthToken() async {
    if (GetStorage().read('refresh_token') != null) {
      await _getToken({
        'grant_type': 'refresh_token',
        'refresh_token': GetStorage().read('refresh_token'),
      });
    }
  }

  /// Gets Reddit auth token.
  Future setAuthToken(String url) async {
    final Uri authUrl = Uri.parse('https://www.reddit.com/api/v1/access_token');

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

    final box = GetStorage();

    await box.write('access_token', _json['access_token']);
    await box.write('refresh_token', _json['refresh_token']);
  }
}

Future _getToken(Map<String, dynamic> body) async {
  final Uri authUrl = Uri.parse('https://www.reddit.com/api/v1/access_token');
  final HTTP.Response _resp = await HTTP.post(
    authUrl,
    headers: {
      'Authorization': 'basic $basicAuth',
      'Content-Type': 'application/x-www-form-urlencoded',
      'User-Agent': userAgent,
    },
    body: body,
  );

  Map<String, dynamic> _json = jsonDecode(_resp.body);

  final box = GetStorage();

  await box.write('access_token', _json['access_token']);
  await box.write('refresh_token', _json['refresh_token']);
}
