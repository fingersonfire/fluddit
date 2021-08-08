import 'package:fluddit/secrets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  /// Gets Reddit auth token using the code provided in the redirect uri.
  Future setAuthToken(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String _query = url.split('$redirectUri/#')[1];
    final Map<String, dynamic> _result = Uri.splitQueryString(_query);

    await prefs.setString('access_token', _result['access_token']);
    await prefs.setString('expires_in', _result['expires_in']);

    print(prefs.getString('access_token'));
  }
}
