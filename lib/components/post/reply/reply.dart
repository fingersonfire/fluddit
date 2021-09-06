import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:get/get.dart';

void replyDialog(BuildContext context, String fullName) {
  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();
  final TextEditingController textController = new TextEditingController();

  bool isSubmitting = false;

  Get.defaultDialog(
    title: 'Enter comment below...',
    content: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width * .75,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              cursorColor: Theme.of(context).accentColor,
              cursorHeight: 20,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 10,
              controller: textController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    onConfirm: () async {
      if (!isSubmitting) {
        isSubmitting = true;
        final RedditPost post =
            reddit.posts[component.carouselIndex.value] as RedditPost;

        await reddit.commentOnPost(
          post.subreddit,
          post.id,
          fullName,
          textController.text,
        );
        Get.back();
      }
    },
    textCancel: 'CANCEL',
    textConfirm: 'REPLY',
  );
}
