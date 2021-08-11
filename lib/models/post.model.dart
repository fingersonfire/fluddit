class RedditPost {
  final String author;
  final String id;
  final String? imageUrl;
  final bool isSelf;
  final bool isVideo;
  final bool saved;
  final int score;
  final bool stickied;
  final String subreddit;
  final String thumbnail;
  final String title;
  final String? postHint;

  RedditPost({
    required this.author,
    required this.id,
    required this.imageUrl,
    required this.isSelf,
    required this.isVideo,
    required this.saved,
    required this.score,
    required this.stickied,
    required this.subreddit,
    required this.thumbnail,
    required this.title,
    required this.postHint,
  });

  factory RedditPost.fromJson(Map<String, dynamic> json) {
    return RedditPost(
      author: json['author'],
      id: json['id'],
      imageUrl: json['url_overridden_by_dest'],
      isSelf: json['is_self'],
      isVideo: json['is_video'],
      saved: json['saved'],
      score: json['score'],
      stickied: json['stickied'],
      subreddit: json['subreddit'],
      thumbnail: json['thumbnail'],
      title: json['title'],
      postHint: json['post_hint'],
    );
  }
}
