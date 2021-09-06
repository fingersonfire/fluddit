import 'dart:convert';
import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/secrets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as HTTP;

class RedditController extends GetxController {
  RxString after = ''.obs;
  RxString listing = 'hot'.obs;
  RxList<Comment> postComments = <Comment>[].obs;
  RxList posts = [].obs;
  RxString name = 'frontpage'.obs;
  RxList subscriptions = [].obs;
  RxString time = 'day'.obs;
  RxString userName = ''.obs;

  late Subreddit subreddit;

  /// Get the subscribed subreddits for the currently authenticated user
  Future getSubscriptions() async {
    final List subscriptions = await this.getUserSubreddits();
    if (subscriptions.length > 0) {
      this.subscriptions.value = subscriptions;
    }
  }

  Future<Map<String, dynamic>> getPosts({
    required String after,
    required int limit,
    required String listing,
    required String subreddit,
    required String time,
  }) async {
    HTTP.Response resp;

    // Fetch the default route json if subreddit is 'frontpage'.
    if (subreddit == 'frontpage') {
      resp = await _get(
        '/.json' +
            '?limit=$limit' +
            '&after=$after', // [after] param being empty returns first page.
      );
    } else {
      resp = await _get(
        '/r/$subreddit/' +
            '$listing.json' +
            '?limit=$limit' +
            '&t=$time' +
            '&after=$after', // [after] param being empty returns first page.
      );
    }

    Map<String, dynamic> _json = jsonDecode(resp.body);
    List posts = _json['data']['children']
        .map((p) => RedditPost.fromJson(p['data']))
        .toList();

    final Map<String, dynamic> response = {
      'after': _json['data']['after'],
      'posts': posts
    };

    return response;
  }

  Future<void> getInitPosts(String subreddit) async {
    this.name.value = subreddit;
    this.after.value = '';
    this.posts.clear();

    final Map<String, dynamic> _data = await this.getPosts(
      after: this.after.value,
      limit: 50,
      listing: this.listing.value,
      subreddit: this.name.value,
      time: this.time.value,
    );

    this.after.value = _data['after'] == null ? '' : _data['after'];
    this.posts.value = _data['posts'];
  }

  Future getNextPosts() async {
    final Map<String, dynamic> _data = await this.getPosts(
      after: this.after.value,
      limit: 25,
      listing: this.listing.value,
      subreddit: this.name.value,
      time: this.time.value,
    );

    this.after.value = _data['after'];
    this.posts.addAll(_data['posts']);
  }

  Future<void> getPostComments({
    required String subreddit,
    required String postId,
  }) async {
    HTTP.Response _resp = await _get('/r/$subreddit/comments/$postId');
    List<dynamic> _json = jsonDecode(_resp.body);

    print('Loaded post: $subreddit $postId');

    final List<dynamic> repliesJson = _json[1]['data']['children'];
    repliesJson.removeWhere((e) => e['kind'] == 'more');

    final List<Comment> comments = repliesJson
        .map(
          (s) => Comment.fromJson(s['data']),
        )
        .toList();

    final List<Comment> flattenedComments = _flattenComments(
      comments: comments,
      list: <Comment>[],
    );

    this.postComments.value = flattenedComments;
  }

  Future getUserComments(String username) async {
    HTTP.Response _resp = await _get('/user/$username/comments');
    return jsonDecode(_resp.body);
  }

  Future<User> getUserInfo() async {
    HTTP.Response _resp = await _get('/api/v1/me');

    final _json = jsonDecode(_resp.body);
    final User user = User.fromJson(_json);

    return user;
  }

  Future<List<RedditPost>> getUserPosts(String username) async {
    HTTP.Response _resp = await _get('/user/$username/submitted');
    final _json = jsonDecode(_resp.body);

    final List<RedditPost> posts = _json['data']['children']
        .map(
          (p) {
            return RedditPost.fromJson(p['data']);
          },
        )
        .toList()
        .cast<RedditPost>();

    return posts;
  }

  /// Fetches the subreddits for the logged in user.
  Future getUserSubreddits() async {
    try {
      HTTP.Response _resp = await _get('/subreddits/mine/subscriber?limit=150');

      Map<String, dynamic> _json = jsonDecode(_resp.body);
      List subreddits = _json['data']['children']
          .map((s) => Subreddit.fromJson(s['data']))
          .toList();

      subreddits.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      return subreddits;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> initFeed() async {
    final GetStorage box = GetStorage();

    if (box.read('access_token') != null) {
      await this.getSubscriptions();

      final info = await this.getUserInfo();
      this.userName.value = info.name;
    }

    this.getInitPosts('frontpage');
  }

  Future<List<dynamic>> searchSubreddits({required String query}) async {
    final HTTP.Response _resp = await _get('/subreddits/search?q=$query');

    Map<String, dynamic> _json = jsonDecode(_resp.body);

    List filteredSubs = _json['data']['children'];
    filteredSubs.removeWhere((f) => f['data']['subreddit_type'] == 'private');

    List subreddits =
        filteredSubs.map((s) => Subreddit.fromJson(s['data'])).toList();

    return subreddits;
  }

  Future<bool> subscribe(String subredditFullName) async {
    final HTTP.Response _resp = await _post(
      '/api/subscribe?sr=$subredditFullName&action=sub&skip_initial_defaults=true',
      null,
    );

    if (_resp.statusCode == 200) {
      await this.getUserSubreddits();
    }

    return _resp.statusCode == 200;
  }

  Future<bool> unsubscribe(String subredditFullName) async {
    final HTTP.Response _resp = await _post(
      '/api/subscribe?sr=$subredditFullName&action=unsub',
      null,
    );

    if (_resp.statusCode == 200) {
      this.subscriptions.removeWhere((s) => s.fullName == subredditFullName);
    }

    return _resp.statusCode == 200;
  }

  void _updateLocalCommentVote(int vote, int commentIndex) {
    this.postComments[commentIndex].updateVote(vote);
    this.postComments.refresh();
  }

  void _updateLocalPostVote(int vote, int postIndex) {
    this.posts[postIndex].updateVote(vote);
    this.posts.refresh();
  }

  Future<int> vote(String fullname, int dir) async {
    final _resp = await _post('/api/vote?id=$fullname&dir=$dir', null);
    return _resp.statusCode;
  }

  Future<void> voteOnComment(String fullName, int vote) async {
    final int i = this.postComments.indexWhere((c) => c.fullName == fullName);
    final int originalVote = this.postComments[i].vote;

    late int voteStatus;

    switch (vote) {
      case 1:
        if (this.postComments[i].vote == 1) {
          _updateLocalCommentVote(vote, i);
          voteStatus = await this.vote(fullName, 0);
        } else {
          _updateLocalCommentVote(vote, i);
          voteStatus = await this.vote(fullName, 1);
        }
        break;
      case -1:
        if (this.postComments[i].vote == -1) {
          _updateLocalCommentVote(vote, i);
          voteStatus = await this.vote(fullName, 0);
        } else {
          _updateLocalCommentVote(vote, i);
          voteStatus = await this.vote(fullName, -1);
        }
        break;
      default:
        break;
    }

    if (voteStatus != 200) {
      _updateLocalCommentVote(originalVote, i);
    }
  }

  Future<void> voteOnPost(String fullName, int vote) async {
    final int i = this.posts.indexWhere((p) => p.fullName == fullName);
    final int originalVote = this.posts[i].vote;

    late int voteStatus;

    switch (vote) {
      case 1:
        if (this.posts[i].vote == 1) {
          _updateLocalPostVote(vote, i);
          voteStatus = await this.vote(fullName, 0);
        } else {
          _updateLocalPostVote(vote, i);
          voteStatus = await this.vote(fullName, 1);
        }
        break;
      case -1:
        if (this.posts[i].vote == -1) {
          _updateLocalPostVote(vote, i);
          voteStatus = await this.vote(fullName, 0);
        } else {
          _updateLocalPostVote(vote, i);
          voteStatus = await this.vote(fullName, -1);
        }
        break;
      default:
        break;
    }

    if (voteStatus != 200) {
      _updateLocalPostVote(originalVote, i);
    }
  }
}

Future<HTTP.Response> _get(String endpoint) async {
  final box = GetStorage();

  HTTP.Response resp;
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
  resp = await HTTP.get(url, headers: headers);

  if (resp.statusCode == 401) {
    final AuthController auth = Get.find();
    await auth.refreshAuthToken();
    resp = await HTTP.get(url, headers: headers);
  }

  print(box.read('access_token'));
  return resp;
}

List<Comment> _flattenComments({
  required List comments,
  required List<Comment> list,
  int level = 0,
}) {
  for (Comment comment in comments) {
    comment.level = level;
    list.add(comment);

    list = _flattenComments(
      comments: comment.replies,
      list: list,
      level: level + 1,
    );
  }

  return list;
}

Future<HTTP.Response> _post(String endpoint, Map? body) async {
  final box = GetStorage();

  HTTP.Response _resp;
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

  if (body != null) {
    _resp = await HTTP.post(url, headers: headers, body: body);
  } else {
    _resp = await HTTP.post(url, headers: headers);
  }

  if (_resp.statusCode == 401) {
    final AuthController auth = Get.find();
    await auth.refreshAuthToken();
    _resp = await HTTP.get(url, headers: headers);
  }

  return _resp;
}
