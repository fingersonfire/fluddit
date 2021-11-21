import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/bloc/user.bloc.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/components/profile/components/content.dart';
import 'package:fluddit/widgets/index.dart';

void profileDialog({String? username}) {
  Get.bottomSheet(
    ProfilePage(username: username),
    isScrollControlled: true,
  );
}

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key, this.username}) : super(key: key);

  final String? username;
  final UserController user = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).bottomAppBarColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .8,
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
            user.getUserInfo(username),
          ],
        ),
      ),
    );
  }
}
