import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:get_storage/get_storage.dart';

class SubredditDrawer extends StatelessWidget {
  SubredditDrawer({Key? key}) : super(key: key);

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: SubredditList(),
          ),
          Container(
            child: ConditionalWidget(
              condition: GetStorage().read('access_token') != null,
              trueWidget: AccountButton(),
              falseWidget: LoginButton(),
            ),
          ),
          Container(
            padding: EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MailButton(),
                SettingsButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
