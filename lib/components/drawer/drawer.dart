import 'package:fluddit/components/index.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:get_storage/get_storage.dart';

class SubredditDrawer extends StatelessWidget {
  const SubredditDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SubredditList(),
            ),
            ConditionalWidget(
              condition: GetStorage().read('access_token') != null,
              trueWidget: AccountButton(),
              falseWidget: const LoginButton(),
            ),
            Container(
              padding: EdgeInsets.zero,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MailButton(),
                  const SettingsButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
