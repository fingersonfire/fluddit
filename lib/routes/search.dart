import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:fluddit/widgets/index.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final RedditController reddit = Get.find();
  final TextEditingController searchController = new TextEditingController();

  bool startSearch = false;

  void search() {
    setState(() {
      startSearch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        title: TextField(
          controller: searchController,
          style: TextStyle(fontSize: 20),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            focusColor: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: search,
            icon: Icon(Icons.search_outlined),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_outlined),
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

  final SubredditController controller = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return FutureBuilder(
        future: reddit.searchSubreddits(query: searchController.text),
        builder: (BuildContext content, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              child: ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int i) {
                  final Subreddit subreddit = snapshot.data[i] as Subreddit;
                  return MaterialButton(
                    height: 100,
                    onPressed: () {
                      controller.name.value = subreddit.name;
                      Get.to(
                        () => SubredditView(subreddit: subreddit),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: SubredditIcon(subreddit: subreddit),
                          margin: EdgeInsets.all(10),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  subreddit.name,
                                  style: TextStyle(fontSize: 22),
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
                  return Divider(height: 3, color: Colors.white);
                },
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.indigo[300],
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text('Search subreddits...'),
      );
    }
  }
}