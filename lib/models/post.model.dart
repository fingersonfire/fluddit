class RedditPost {
  final String author;
  final bool saved;
  final int score;
  final bool stickied;
  final String subreddit;
  final String thumbnail;
  final String title;

  RedditPost({
    required this.author,
    required this.saved,
    required this.score,
    required this.stickied,
    required this.subreddit,
    required this.thumbnail,
    required this.title,
  });

  factory RedditPost.fromJson(Map<String, dynamic> json) {
    return RedditPost(
      author: json['author'],
      saved: json['saved'],
      score: json['score'],
      stickied: json['stickied'],
      subreddit: json['subreddit'],
      thumbnail: json['thumbnail'],
      title: json['title'],
    );
  }
}
