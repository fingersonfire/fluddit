class User {
  User({
    required this.commentKarma,
    required this.name,
    required this.postKarma,
    required this.profileImage,
  });

  final int commentKarma;
  final String name;
  final int postKarma;
  final String profileImage;

  factory User.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json['data'] ?? json;

    return User(
      commentKarma: data['comment_karma'] ?? 0,
      name: data['name'] ?? '',
      postKarma: data['link_karma'] ?? 0,
      profileImage: data['icon_img'] ?? '',
    );
  }
}
