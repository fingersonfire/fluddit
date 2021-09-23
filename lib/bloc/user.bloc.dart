import 'dart:convert';
import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:http/http.dart' as HTTP;

class UserController extends GetxController {
  RxString after = ''.obs;
  RxString commentAfter = ''.obs;
  RxList<Comment> comments = <Comment>[].obs;
  RxBool isLoaded = false.obs;
  RxList<Post> posts = <Post>[].obs;
  RxString username = ''.obs;

  Future<void> getAdditionalComments(String userName) async {
    HTTP.Response _resp = await getR(
      '/user/$userName/comments?limit=25&after=${commentAfter.value}',
    );
    final _json = jsonDecode(_resp.body);

    final List<Comment> comments = _json['data']['children']
        .map((p) {
          return Comment.fromJson(p['data']);
        })
        .toList()
        .cast<Comment>();

    this.commentAfter.value = _json['data']['after'] ?? '';
    this.comments.addAll(comments);
  }

  Future<void> getUserComments(String userName) async {
    HTTP.Response _resp = await getR('/user/$userName/comments?limit=25');
    final _json = jsonDecode(_resp.body);

    final List<Comment> comments = _json['data']['children']
        .map((p) {
          return Comment.fromJson(p['data']);
        })
        .toList()
        .cast<Comment>();

    this.commentAfter.value = _json['data']['after'] ?? '';
    this.comments.value = comments;
  }

  Future<void> getUserPosts(String userName) async {
    HTTP.Response _resp = await getR('/user/$userName/submitted');
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
