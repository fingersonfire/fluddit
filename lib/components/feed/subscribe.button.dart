import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/widgets/index.dart';

class SubscribeButton extends StatelessWidget {
  SubscribeButton({Key? key, required this.subreddit}) : super(key: key);

  final Subreddit subreddit;

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ConditionalWidget(
          // Check if the user is subscribed
          condition: reddit.subscriptions
              .where((s) => s.name == subreddit.name)
              .isNotEmpty,
          trueWidget: IconButton(
            onPressed: () async {
              await reddit.unsubscribe(subreddit.fullName);
            },
            icon: const Icon(
              Icons.remove_outlined,
              color: Color(0xFF2e3440),
            ),
          ),
          falseWidget: IconButton(
            onPressed: () async {
              await reddit.subscribe(subreddit.fullName);
            },
            icon: const Icon(
              Icons.add_outlined,
              color: Color(0xFF2e3440),
            ),
          ),
        );
      },
    );
  }
}
