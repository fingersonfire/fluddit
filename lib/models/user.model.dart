class User {
  final int commentKarma;
  final String name;
  final int postKarma;

  User({
    required this.commentKarma,
    required this.name,
    required this.postKarma,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json['data'] ?? json;

    return User(
      commentKarma: data['comment_karma'] ?? 0,
      name: data['name'] ?? '',
      postKarma: data['link_karma'] ?? 0,
    );
  }
}
