import 'package:fluddit/bloc/reddit.bloc.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  const PostTile({Key? key, required this.post}) : super(key: key);

  final RedditPost post;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      child: ListTile(
          leading: Container(
            width: 20,
            height: 50,
            child: Center(child: Text('${post.score}')),
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
            post.author,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).hintColor,
            ),
          ),
          trailing: Container(
            color: Theme.of(context).canvasColor,
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
          )),
    );
  }
}
