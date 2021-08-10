import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/routes/login.dart';
import 'package:fluddit/widgets/conditional.widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Drawer subredditsDrawer() {
  final RedditController reddit = Get.find();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  return Drawer(
    child: FutureBuilder(
      future: Future.wait([reddit.getUserSubreddits(), prefs]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
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
                  condition:
                      snapshot.data?[1].getString('access_token') != null,
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
          child: CircularProgressIndicator(),
        );
      },
    ),
  );
}
