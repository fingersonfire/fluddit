class RedditPost {
  final String author;
  final String domain;
  final String fullName;
  final List galleryData;
  final String id;
  final bool isGallery;
  final bool isSelf;
  final bool isVideo;
  final Map metaData;
  final bool saved;
  int score;
  final String selfText;
  final bool stickied;
  final String subreddit;
  final String thumbnail;
  final String title;
  final String? postHint;
  final String? url;
  int vote;

  RedditPost({
    required this.author,
    required this.domain,
    required this.fullName,
    required this.galleryData,
    required this.id,
    required this.isGallery,
    required this.isSelf,
    required this.isVideo,
    required this.metaData,
    required this.saved,
    required this.score,
    required this.selfText,
    required this.stickied,
    required this.subreddit,
    required this.thumbnail,
    required this.title,
    required this.postHint,
    required this.url,
    required this.vote,
  });

  factory RedditPost.fromJson(Map<String, dynamic> json) {
    return RedditPost(
      author: json['author'],
      domain: json['domain'],
      fullName: json['name'],
      galleryData: json['gallery_data']?['items'] ?? [],
      id: json['id'],
      isGallery: json['is_gallery'] ?? false,
      isSelf: json['is_self'],
      isVideo: json['is_video'],
      metaData: json['media_metadata'] ?? {},
      saved: json['saved'],
      score: json['score'],
      selfText: json['selftext'],
      stickied: json['stickied'],
      subreddit: json['subreddit'],
      thumbnail: json['thumbnail'],
      title: json['title'],
      postHint: json['post_hint'],
      url: json['url_overridden_by_dest'],
      vote: _getVote(json['likes']),
    );
  }

  /// Returns the [score] int as a concatinated String (e.g. 3000 => "3k").
  /// Anything that's less than 4 digits long returns as a unconcatinated String.
  String getScoreString() {
    if (this.score > 999) {
      String str = this.score.toString();
      return '${str.substring(0, str.length - 3)}k';
    } else {
      return this.score.toString();
    }
  }

  void updateVote(int vote) {
    switch (vote) {
      case 1:
        if (this.vote == 1) {
          this.vote = 0;
          --this.score;
        } else {
          if (this.vote == -1) {
            this.score = this.score + 2;
          } else {
            ++this.score;
          }
          this.vote = 1;
        }
        break;
      case -1:
        if (this.vote == -1) {
          this.vote = 0;
          ++this.score;
        } else {
          if (this.vote == 1) {
            this.score = this.score - 2;
          } else {
            --this.score;
          }
          this.vote = -1;
        }
        break;
      default:
        break;
    }
  }
}

int _getVote(bool? likes) {
  if (likes == null) {
    return 0;
  } else {
    return likes ? 1 : -1;
  }
}
