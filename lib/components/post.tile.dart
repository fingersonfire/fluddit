import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostTile extends StatelessWidget {
  PostTile({Key? key, required this.post}) : super(key: key);

  final RedditController c = Get.find();
  final RedditPost post;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Theme.of(context).cardColor,
      ),
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      child: ListTile(
        leading: Container(
          width: 30,
          height: 50,
          child: Center(
            child: Text(
              c.getScoreString(post.score),
            ),
          ),
        ),
        title: Text(
          post.title,
          maxLines: 2,
          style: TextStyle(
            color: post.stickied ? Colors.green : null,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'r/${post.subreddit} | ${post.author}',
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).hintColor,
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          height: 50,
          width: 50,
          child: post.thumbnail.contains('http')
              ? Image.network(
                  post.thumbnail,
                  fit: BoxFit.cover,
                )
              : Center(
                  child: Text('Tt'),
                ),
        ),
      ),
    );
  }
}
