import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:get/get.dart';

class SubredditView extends StatelessWidget {
  SubredditView({Key? key, required this.subreddit}) : super(key: key);

  final Subreddit subreddit;

  final SubredditController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.indigo[300],
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text(subreddit.name),
        actions: [
          SubscribeButton(subreddit: subreddit),
        ],
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              color: Colors.transparent,
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.posts.length + 1,
                  itemBuilder: (context, i) {
                    if (i < controller.posts.length) {
                      return PostTile(post: controller.posts[i]);
                    } else {
                      if (controller.after.value != '') {
                        if (controller.posts.length > 1) {
                          controller.getNextPosts();
                        }
                        return Container(
                          height: 75,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                  },
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.indigo[300],
            ),
          );
        },
        future: controller.getInitPosts(),
      ),
    );
  }
}
