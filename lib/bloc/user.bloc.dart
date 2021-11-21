import 'dart:convert';
import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/secrets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  RxString after = ''.obs;
  RxString commentAfter = ''.obs;
  RxList<Comment> comments = <Comment>[].obs;
  RxBool isLoaded = false.obs;
  RxList<Post> posts = <Post>[].obs;
  Rx<String> username = ''.obs;

  Future<void> getAdditionalComments(String userName) async {
    http.Response _resp = await _get(
      '/user/$userName/comments?limit=25&after=${commentAfter.value}',
    );
    final _json = jsonDecode(_resp.body);

    final List<Comment> comments = _json['data']['children']
        .map((p) {
          return Comment.fromJson(p['data']);
        })
        .toList()
        .cast<Comment>();

    commentAfter.value = _json['data']['after'] ?? '';
    this.comments.addAll(comments);
  }

  Future<void> getUserInfo(String? username) async {
    http.Response _resp = username == null
        ? await _get('/api/v1/me')
        : await _get('/user/$username/about');

    final _json = jsonDecode(_resp.body);
    final User user = User.fromJson(_json);

    this.username.value = user.name;

    await getUserComments(user.name);
    await getUserPosts(user.name);
  }

  Future<void> getUserComments(String userName) async {
    http.Response _resp = await _get('/user/$userName/comments?limit=25');
    final _json = jsonDecode(_resp.body);

    final List<Comment> comments = _json['data']['children']
        .map((p) {
          return Comment.fromJson(p['data']);
        })
        .toList()
        .cast<Comment>();

    commentAfter.value = _json['data']['after'] ?? '';
    this.comments.value = comments;
  }

  Future<void> getUserPosts(String userName) async {
    http.Response _resp = await _get('/user/$userName/submitted');
    final _json = jsonDecode(_resp.body);

    final List<Post> posts = _json['data']['children']
        .map((p) {
          return Post.fromJson(p['data']);
        })
        .toList()
        .cast<Post>();

    this.posts.value = posts;
  }
}

Future<http.Response> _get(String endpoint) async {
  final box = GetStorage();

  http.Response resp;
  final bool isLoggedIn = box.read('access_token') != null;

  // Requests need to be made to different URl dependeding on auth state.
  String baseUrl = isLoggedIn ? 'oauth.reddit.com' : 'www.reddit.com';

  Map<String, String> headers = {
    'User-Agent': userAgent,
  };

  // Add bearer auth to header if token exists.
  if (isLoggedIn) {
    headers['Authorization'] = 'bearer ${box.read('access_token')}';
  }

  Uri url = Uri.parse('https://$baseUrl$endpoint');
  resp = await http.get(url, headers: headers);

  if (resp.statusCode == 401) {
    final AuthController auth = Get.find();
    await auth.refreshAuthToken();
    resp = await http.get(url, headers: headers);
  }
  return resp;
}
