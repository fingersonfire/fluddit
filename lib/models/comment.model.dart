class Comment {
  final String author;
  final String body;
  final String id;
  final List<Comment> replies;

  Comment({
    required this.author,
    required this.body,
    required this.id,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      author: json['author'],
      body: json['body'],
      id: json['id'],
      replies: _getReplies(json['replies']),
    );
  }
}

// This is what causes the recursion to occur
List<Comment> _getReplies(replies) {
  if (replies == '') {
    // An empty string is set as the replies value if none are present ヘ(>_<ヘ)
    final List<Comment> comments = [];
    return comments;
  } else {
    final List<dynamic> replyArray = replies['data']['children'];
    replyArray.removeWhere((e) => e['kind'] == 'more');

    return replyArray.map((e) {
      return Comment.fromJson(e['data']);
    }).toList();
  }
}
