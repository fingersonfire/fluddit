import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:get_storage/get_storage.dart';

class SubredditDrawer extends StatelessWidget {
  SubredditDrawer({Key? key}) : super(key: key);

  final ComponentController component = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: SubredditList(),
          ),
          Container(
            margin: EdgeInsets.all(2),
            color: Theme.of(context).backgroundColor,
            height: 50,
            width: 300,
            child: ConditionalWidget(
              // condition: snapshot.data?.getString('access_token') != null,
              condition: GetStorage().read('access_token') != null,
              trueWidget: TextButton(
                onPressed: () async {},
                child: Text(
                  'Account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              falseWidget: TextButton(
                onPressed: () {
                  Get.back();
                  Get.to(() => LoginView());
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  color: Theme.of(context).backgroundColor,
                  width: 150,
                  height: 50,
                  child: IconButton(
                    onPressed: () {
                      Get.to(() => Settings());
                    },
                    icon: Icon(Icons.settings_outlined),
                  ),
                ),
                Container(
                  color: Theme.of(context).backgroundColor,
                  width: 150,
                  height: 50,
                  child: IconButton(
                    onPressed: () {
                      component.displaySnackbar(
                        'Mail not yet implemented',
                      );
                    },
                    icon: Icon(Icons.mail_outline),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
