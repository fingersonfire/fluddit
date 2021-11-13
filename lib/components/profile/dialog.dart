import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/widgets/index.dart';

void profileDialog() {
  final RedditController reddit = Get.find();

  Get.defaultDialog(
    title: reddit.userName.value,
    content: FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const Center(
            child: Text('Please excuse the dust'),
          );
        }
        return const LoadingIndicator();
      },
      future: reddit.getUserInfo(),
    ),
  );
}
