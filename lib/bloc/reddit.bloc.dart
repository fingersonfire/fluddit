import 'dart:convert';
import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/secrets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as HTTP;

class RedditController extends GetxController {
  RxString after = ''.obs;
  RxString listing = 'hot'.obs;
  RxList<Post> posts = <Post>[].obs;
  RxString name = 'frontpage'.obs;
  late Subreddit subreddit;
  RxList<Subreddit> subscriptions = <Subreddit>[].obs;
  RxString time = 'day'.obs;
  RxString userName = ''.obs;

  Future<void> commentOnPost(
    String subreddit,
    String postId,
    String fullName,
    String body,
  ) async {
    print(
      'comment on subreddit: $subreddit, postId: $postId, fullName: $fullName',
    );

    final HTTP.Response _resp = await _comment(fullName, body);
    final int pIndex = _getPostIdIndex(postId);

    if (_resp.statusCode == 200) {
      final response = jsonDecode(_resp.body);

      // Get the new comment data from the jquery response
      final commentData = List.castFrom(response['jquery'])
          .singleWhere((c) => c.toString().contains('kind'))
          .last
          .first
          .first['data'];

      // Create a new comment object from the parsed response
      final Comment newComment = Comment.fromJson(commentData);

      if (posts[pIndex].fullName == fullName) {
        // If the comment is a direct response to the post, add it to the top
        posts[pIndex].comments.insert(0, newComment);
      } else {
        // If a comment is a reply to another comment, display below the original
        final int cIndex =
            posts[pIndex].comments.indexWhere((c) => c.fullName == fullName);

        newComment.level = posts[pIndex].comments[cIndex].level + 1;
        posts[pIndex].comments.insert(cIndex + 1, newComment);
      }

      // Refresh the posts item to update UI
      posts.refresh();
    } else {
      print(jsonDecode(_resp.body));
    }
  }

  Future<Map<String, dynamic>> getPosts({
    required String after,
    required int limit,
    required String listing,
    required String subreddit,
    required String time,
  }) async {
    HTTP.Response _resp;

    // Fetch the default route json if subreddit is 'frontpage'.
    if (subreddit == 'frontpage') {
      _resp = await _get(
        '/$listing.json' +
            '?limit=$limit' +
            '&t=$time' +
            '&after=$after', // [after] param being empty returns first page.
      );
    } else {
      _resp = await _get(
        '/r/$subreddit/' +
            '$listing.json' +
            '?limit=$limit' +
            '&t=$time' +
            '&after=$after', // [after] param being empty returns first page.
      );
    }

    Map<String, dynamic> _json = jsonDecode(_resp.body);
    List posts = _json['data']['children']
        .map((p) => Post.fromJson(p['data']))
        .toList()
        .cast<Post>();

    return {'after': _json['data']['after'], 'posts': posts};
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
    this.posts.value = _data['posts'].toList().cast<Post>();
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
    this.posts.addAll(_data['posts'].toList().cast<Post>());
  }

  Future<void> getPostComments({
    required String subreddit,
    required String postId,
  }) async {
    HTTP.Response _resp = await _get('/r/$subreddit/comments/$postId.json');
    List<dynamic> _json = jsonDecode(_resp.body);

    print('Loaded post: $subreddit $postId');

    final List<dynamic> repliesJson = _json[1]['data']['children'];
    repliesJson.removeWhere((e) => e['kind'] == 'more');

    final List<Comment> comments =
        repliesJson.map((s) => Comment.fromJson(s['data'])).toList();

    final List<Comment> flattenedComments = _flattenComments(
      comments: comments,
      list: <Comment>[],
    );

    final int pIndex = _getPostIdIndex(postId);
    posts[pIndex].updateComments(flattenedComments);
    posts[pIndex].commentsLoaded = true;
    posts.refresh();
  }

  int _getPostIdIndex(String postId) {
    return this.posts.indexWhere((p) => p.id == postId);
  }

  Future<dynamic> getUserComments(String username) async {
    HTTP.Response _resp = await _get('/user/$username/comments');
    return jsonDecode(_resp.body);
  }

  Future<User> getUserInfo() async {
    HTTP.Response _resp = await _get('/api/v1/me');

    final _json = jsonDecode(_resp.body);
    final User user = User.fromJson(_json);

    return user;
  }

  /// Get the subscribed subreddits for the currently authenticated user
  Future<void> getSubscriptions() async {
    final List<Subreddit> subscriptions = await this.getUserSubreddits();
    if (subscriptions.length > 0) {
      this.subscriptions.value = subscriptions;
    }
  }

  Future<List<Post>> getUserPosts(String username) async {
    HTTP.Response _resp = await _get('/user/$username/submitted');
    final _json = jsonDecode(_resp.body);

    final List<Post> posts = _json['data']['children']
        .map((p) {
          return Post.fromJson(p['data']);
        })
        .toList()
        .cast<Post>();

    return posts;
  }

  /// Fetches the subreddits for the logged in user.
  Future<List<Subreddit>> getUserSubreddits() async {
    try {
      HTTP.Response _resp = await _get('/subreddits/mine/subscriber?limit=150');

      Map<String, dynamic> _json = jsonDecode(_resp.body);
      List<Subreddit> subreddits = _json['data']['children']
          .map((s) => Subreddit.fromJson(s['data']))
          .toList()
          .cast<Subreddit>();

      subreddits.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      return subreddits;
    } catch (e) {
      print(e);
      return <Subreddit>[];
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

  Future<void> savePost(int postIndex) async {
    final bool _saveState = this.posts[postIndex].saved;
    final String _fullName = this.posts[postIndex].fullName;

    this.posts[postIndex].save(!_saveState);
    this.posts.refresh();

    final HTTP.Response _resp = await _post(
      '/api/${_saveState ? 'unsave' : 'save'}?id=$_fullName',
      null,
    );

    if (_resp.statusCode != 200) {
      this.posts[postIndex].save(_saveState);
      this.posts.refresh();
    }
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

  void _updateLocalCommentVote(int commentIndex, int postIndex, int vote) {
    this.posts[postIndex].comments[commentIndex].updateVote(vote);
    this.posts.refresh();
  }

  void _updateLocalPostVote(int vote, int postIndex) {
    this.posts[postIndex].updateVote(vote);
    this.posts.refresh();
  }

  Future<int> vote(String fullname, int dir) async {
    final _resp = await _post('/api/vote?id=$fullname&dir=$dir', null);
    return _resp.statusCode;
  }

  Future<void> voteOnComment(int commentIndex, int postIndex, int vote) async {
    final String id = posts[postIndex].comments[commentIndex].fullName;
    final int originalVote = posts[postIndex].comments[commentIndex].vote;

    late int voteStatus;

    switch (vote) {
      case 1:
        if (originalVote == 1) {
          _updateLocalCommentVote(commentIndex, postIndex, vote);
          voteStatus = await this.vote(id, 0);
        } else {
          _updateLocalCommentVote(commentIndex, postIndex, vote);
          voteStatus = await this.vote(id, 1);
        }
        break;
      case -1:
        if (originalVote == -1) {
          _updateLocalCommentVote(commentIndex, postIndex, vote);
          voteStatus = await this.vote(id, 0);
        } else {
          _updateLocalCommentVote(commentIndex, postIndex, vote);
          voteStatus = await this.vote(id, -1);
        }
        break;
      default:
        break;
    }

    if (voteStatus != 200) {
      _updateLocalCommentVote(commentIndex, postIndex, originalVote);
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

Future<HTTP.Response> _comment(String fullName, String body) async {
  final HTTP.Response _resp = await _post(
    '/api/comment?thing_id=$fullName&text=$body',
    null,
  );

  return _resp;
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
