import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubredditDrawer extends StatelessWidget {
  SubredditDrawer({Key? key}) : super(key: key);

  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: prefs,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: SubredditList(),
                ),
                Container(
                  color: Colors.black87,
                  height: 50,
                  width: 305,
                  child: ConditionalWidget(
                    condition: snapshot.data?.getString('access_token') != null,
                    trueWidget: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Account',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    falseWidget: TextButton(
                      onPressed: () {
                        Get.back();
                        Get.to(() => WebLogin());
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
