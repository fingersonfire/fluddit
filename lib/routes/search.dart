import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:flutter/services.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final RedditController reddit = Get.find();
  final TextEditingController searchController = TextEditingController();

  InputBorder inputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        width: 0,
        color: Colors.transparent,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  bool startSearch = false;

  void search() {
    if (searchController.text != "") {
      setState(() {
        startSearch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        toolbarHeight: 50,
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF2e3440),
          ),
          height: 40,
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            child: TextField(
              controller: searchController,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(
                fontSize: 18,
              ),
              cursorColor: Theme.of(context).primaryColor,
              textInputAction: TextInputAction.search,
              onSubmitted: (String param) {
                search();
              },
              decoration: InputDecoration(
                enabledBorder: inputBorder(),
                focusedBorder: inputBorder(),
                border: inputBorder(),
                filled: false,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: search,
            icon: const Icon(
              Icons.search_outlined,
              color: Color(0xFF2e3440),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            reddit.getFeedPosts('frontpage');
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0xFF2e3440),
          ),
        ),
      ),
      body: SearchBody(
        condition: startSearch,
        searchController: searchController,
      ),
    );
  }
}

class SearchBody extends StatelessWidget {
  SearchBody({
    Key? key,
    required this.condition,
    required this.searchController,
  }) : super(key: key);

  final bool condition;
  final TextEditingController searchController;

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return WillPopScope(
        onWillPop: () async {
          reddit.getFeedPosts('frontpage');
          return true;
        },
        child: FutureBuilder(
          future: reddit.searchSubreddits(query: searchController.text),
          builder: (BuildContext content, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int i) {
                  final Subreddit subreddit = snapshot.data[i] as Subreddit;
                  return MaterialButton(
                    height: 100,
                    onPressed: () {
                      reddit.name.value = subreddit.name;
                      reddit.getFeedPosts(subreddit.name);
                      Get.to(() => SearchFeed(subreddit: subreddit));
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: SubredditIcon(subreddit: subreddit),
                          margin: const EdgeInsets.all(10),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  subreddit.name,
                                  style: const TextStyle(fontSize: 22),
                                ),
                                Text(
                                  subreddit.title,
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(height: 3, color: Colors.white);
                },
              );
            }
            return const LoadingIndicator();
          },
        ),
      );
    } else {
      return const Center(
        child: Text('Search subreddits...'),
      );
    }
  }
}
