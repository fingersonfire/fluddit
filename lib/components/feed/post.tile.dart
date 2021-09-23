import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/routes/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostTile extends StatelessWidget {
  PostTile({Key? key, required this.post, this.width}) : super(key: key);

  final Post post;
  double? width;

  final RedditController reddit = Get.find();
  final ComponentController comp = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          final postIndex = reddit.posts.indexOf(post);
          comp.carouselIndex.value = postIndex;

          Get.to(
            () => PostView(post: post),
            transition: Transition.rightToLeft,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            color: Theme.of(context).cardColor,
          ),
          padding: EdgeInsets.symmetric(vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 30,
                child: Center(
                  child: Text(
                    post.getScoreString(),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width ?? MediaQuery.of(context).size.width - 125,
                    child: Text(
                      post.title,
                      maxLines: 4,
                      style: TextStyle(
                        color: post.stickied ? Colors.green : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'r/${post.subreddit} | ${post.author}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        post.thumbnail == 'nsfw'
                            ? Text(
                                '[NSFW]',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red[400],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                height: 50,
                width: 50,
                child: comp.getPostThumbnail(post),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
