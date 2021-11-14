import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/bloc/user.bloc.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/components/profile/components/content.dart';
import 'package:fluddit/widgets/index.dart';

void profileDialog() {
  Get.dialog(Dialog());
}

class Dialog extends StatelessWidget {
  Dialog({Key? key}) : super(key: key);

  final RedditController reddit = Get.find();
  final UserController user = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Theme.of(context).bottomAppBarColor,
          width: MediaQuery.of(context).size.width * .9,
          height: MediaQuery.of(context).size.height * .6,
          child: FutureBuilder(
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return const ProfileContent();
                  },
                );
              }
              return const LoadingIndicator();
            },
            future: Future.wait(
              [
                reddit.getUserInfo(),
                user.getUserPosts(reddit.userName.value),
                user.getUserComments(reddit.userName.value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
