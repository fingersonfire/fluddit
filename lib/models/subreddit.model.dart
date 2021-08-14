class Subreddit {
  final String bannerImage;
  final String description;
  final String? flair;
  final String? headerImage;
  final String icon;
  final String name;
  final bool nsfw;
  final bool subscribed;

  Subreddit({
    required this.bannerImage,
    required this.description,
    required this.flair,
    required this.headerImage,
    required this.icon,
    required this.name,
    required this.nsfw,
    required this.subscribed,
  });

  factory Subreddit.fromJson(Map<String, dynamic> json) {
    return Subreddit(
      bannerImage: json['banner_img'],
      description: json['public_description'],
      flair: json['user_flair_text'],
      headerImage: json['header_img'],
      icon: json['community_icon'],
      name: json['display_name'],
      nsfw: json['over18'],
      subscribed: json['user_is_subscriber'],
    );
  }
}
