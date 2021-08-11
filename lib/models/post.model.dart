class RedditPost {
  final String author;
  final String domain;
  final String id;
  final bool isSelf;
  final bool isVideo;
  final bool saved;
  final int score;
  final bool stickied;
  final String subreddit;
  final String thumbnail;
  final String title;
  final String? postHint;
  final String? url;

  RedditPost({
    required this.author,
    required this.domain,
    required this.id,
    required this.isSelf,
    required this.isVideo,
    required this.saved,
    required this.score,
    required this.stickied,
    required this.subreddit,
    required this.thumbnail,
    required this.title,
    required this.postHint,
    required this.url,
  });

  factory RedditPost.fromJson(Map<String, dynamic> json) {
    return RedditPost(
      author: json['author'],
      domain: json['domain'],
      id: json['id'],
      isSelf: json['is_self'],
      isVideo: json['is_video'],
      saved: json['saved'],
      score: json['score'],
      stickied: json['stickied'],
      subreddit: json['subreddit'],
      thumbnail: json['thumbnail'],
      title: json['title'],
      postHint: json['post_hint'],
      url: json['url_overridden_by_dest'],
    );
  }
}
