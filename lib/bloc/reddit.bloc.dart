import 'dart:convert';
import 'dart:developer';
import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/secrets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class RedditController extends GetxController {
  RxString after = ''.obs;
  RxList<Post> feedPosts = <Post>[].obs;
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
    final http.Response _resp = await _comment(fullName, body);
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
      log(jsonDecode(_resp.body));
    }
  }

  Future<Map<String, dynamic>> getPosts({
    required String after,
    required int limit,
    required String listing,
    required String subreddit,
    required String time,
  }) async {
    http.Response _resp;

    // Fetch the default route json if subreddit is 'frontpage'.
    if (subreddit == 'frontpage') {
      _resp = await _get(
        '/$listing.json'
        '?limit=$limit'
        '&t=$time'
        '&after=$after', // [after] param being empty returns first page.
      );
    } else {
      _resp = await _get(
        '/r/$subreddit/'
        '$listing.json'
        '?limit=$limit'
        '&t=$time'
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

  Future<void> getFeedPosts(String subreddit) async {
    name.value = subreddit;
    after.value = '';
    feedPosts.clear();

    final Map<String, dynamic> _data = await getPosts(
      after: after.value,
      limit: 50,
      listing: listing.value,
      subreddit: name.value,
      time: time.value,
    );

    after.value = _data['after'] ?? '';
    feedPosts.value = _data['posts'].toList().cast<Post>();
  }

  Future getNextPosts() async {
    final Map<String, dynamic> _data = await getPosts(
      after: after.value,
      limit: 25,
      listing: listing.value,
      subreddit: name.value,
      time: time.value,
    );

    after.value = _data['after'];
    feedPosts.addAll(_data['posts'].toList().cast<Post>());
  }

  Future<List<Comment>> getPostComments({
    required String subreddit,
    required String postId,
  }) async {
    http.Response _resp = await _get('/r/$subreddit/comments/$postId.json');
    List<dynamic> _json = jsonDecode(_resp.body);

    log('Loaded post: $subreddit $postId');

    final List<dynamic> repliesJson = _json[1]['data']['children'];
    repliesJson.removeWhere((e) => e['kind'] == 'more');

    final List<Comment> comments =
        repliesJson.map((s) => Comment.fromJson(s['data'])).toList();

    final List<Comment> flattenedComments = _flattenComments(
      comments: comments,
      list: <Comment>[],
    );

    if (posts.where((p0) => p0.id == postId).isNotEmpty) {
      final int pIndex = _getPostIdIndex(postId);

      posts[pIndex].commentsLoaded = true;
      posts[pIndex].updateComments(flattenedComments);
      posts.refresh();
    }

    return flattenedComments;
  }

  int _getPostIdIndex(String postId) {
    return posts.indexWhere((p) => p.id == postId);
  }

  Future<User> getUserInfo({String? username}) async {
    http.Response _resp = username == null
        ? await _get('/api/v1/me')
        : await _get('/user/$username/about');

    final _json = jsonDecode(_resp.body);
    final User user = User.fromJson(_json);

    return user;
  }

  /// Get the subscribed subreddits for the currently authenticated user
  Future<void> getSubscriptions() async {
    final List<Subreddit> subscriptions = await getUserSubreddits();
    if (subscriptions.isNotEmpty) {
      this.subscriptions.value = subscriptions;
    }
  }

  /// Fetches the subreddits for the logged in user.
  Future<List<Subreddit>> getUserSubreddits() async {
    try {
      http.Response _resp = await _get('/subreddits/mine/subscriber?limit=150');

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
      return <Subreddit>[];
    }
  }

  Future<void> initFeed() async {
    final GetStorage box = GetStorage();

    if (box.read('access_token') != null) {
      await getSubscriptions();

      final info = await getUserInfo();
      userName.value = info.name;
    }

    getFeedPosts('frontpage');
  }

  Future<void> savePost(int postIndex) async {
    final bool _saveState = posts[postIndex].saved;
    final String _fullName = posts[postIndex].fullName;

    posts[postIndex].save(!_saveState);
    posts.refresh();

    final http.Response _resp = await _post(
      '/api/${_saveState ? 'unsave' : 'save'}?id=$_fullName',
      null,
    );

    if (_resp.statusCode != 200) {
      posts[postIndex].save(_saveState);
      posts.refresh();
    }
  }

  Future<List<dynamic>> searchSubreddits({required String query}) async {
    final http.Response _resp = await _get('/subreddits/search?q=$query');

    Map<String, dynamic> _json = jsonDecode(_resp.body);

    List filteredSubs = _json['data']['children'];
    filteredSubs.removeWhere((f) => f['data']['subreddit_type'] == 'private');

    List subreddits =
        filteredSubs.map((s) => Subreddit.fromJson(s['data'])).toList();

    return subreddits;
  }

  Future<bool> subscribe(Subreddit subreddit) async {
    subscriptions.add(subreddit);

    final http.Response _resp = await _post(
      '/api/subscribe?sr=${subreddit.fullName}&action=sub&skip_initial_defaults=true',
      null,
    );

    if (_resp.statusCode != 200) {
      subscriptions.removeWhere((s) => s.fullName == subreddit.fullName);
    }

    return _resp.statusCode == 200;
  }

  Future<bool> unsubscribe(String subredditFullName) async {
    final http.Response _resp = await _post(
      '/api/subscribe?sr=$subredditFullName&action=unsub',
      null,
    );

    if (_resp.statusCode == 200) {
      subscriptions.removeWhere((s) => s.fullName == subredditFullName);
    }

    return _resp.statusCode == 200;
  }

  void _updateLocalCommentVote(int commentIndex, int postIndex, int vote) {
    posts[postIndex].comments[commentIndex].updateVote(vote);
    posts.refresh();
  }

  void _updateLocalPostVote(int vote, int postIndex) {
    posts[postIndex].updateVote(vote);
    posts.refresh();
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
    final int i = posts.indexWhere((p) => p.fullName == fullName);
    final int originalVote = posts[i].vote;

    late int voteStatus;

    switch (vote) {
      case 1:
        if (posts[i].vote == 1) {
          _updateLocalPostVote(vote, i);
          voteStatus = await this.vote(fullName, 0);
        } else {
          _updateLocalPostVote(vote, i);
          voteStatus = await this.vote(fullName, 1);
        }
        break;
      case -1:
        if (posts[i].vote == -1) {
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

Future<http.Response> _comment(String fullName, String body) async {
  final http.Response _resp = await _post(
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

Future<http.Response> _post(String endpoint, Map? body) async {
  final box = GetStorage();

  http.Response _resp;
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
    _resp = await http.post(url, headers: headers, body: body);
  } else {
    _resp = await http.post(url, headers: headers);
  }

  if (_resp.statusCode == 401) {
    final AuthController auth = Get.find();
    await auth.refreshAuthToken();
    _resp = await http.get(url, headers: headers);
  }

  return _resp;
}
