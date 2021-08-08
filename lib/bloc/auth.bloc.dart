import 'dart:convert';
import 'package:fluddit/secrets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  /// Gets Reddit auth token using the code provided in the redirect uri.
  Future<bool> setAuthToken(code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('code', code);

    // As of right now this request fails because Reddit's documentation
    // is absolute ass.
    Uri url = Uri.parse('https://www.reddit.com/api/v1/access_token');
    HTTP.Response resp = await HTTP.post(
      url,
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.86 Mobile Safari/537.36',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    Map<String, dynamic> json = jsonDecode(resp.body);

    await prefs.setString('access_token', json['access_token']);
    await prefs.setString('expires_in', json['expires_in']);
    await prefs.setString('refresh_token', json['refresh_token']);

    print(prefs.getString('access_token'));

    return true;
  }
}
