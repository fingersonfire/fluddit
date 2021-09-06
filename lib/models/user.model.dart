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
    return User(
      commentKarma: json['comment_karma'],
      name: json['name'],
      postKarma: json['link_karma'],
    );
  }
}
