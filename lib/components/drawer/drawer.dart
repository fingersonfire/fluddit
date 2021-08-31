import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubredditDrawer extends StatelessWidget {
  SubredditDrawer({Key? key}) : super(key: key);

  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  final ComponentController component = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: prefs,
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
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
                    condition: snapshot.data?.getString('access_token') != null,
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
                            component.displaySnackbar(
                              'Settings not yet implemented',
                            );
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
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.indigo[300],
            ),
          );
        },
      ),
    );
  }
}
