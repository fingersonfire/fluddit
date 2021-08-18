import 'package:fluddit/bloc/reddit.bloc.dart';
import 'package:get/get.dart';

class FrontpageController extends GetxController {
  final RedditController reddit = Get.find();

  RxString after = ''.obs;
  RxString listing = 'hot'.obs;
  RxList posts = [].obs;
  RxString name = 'frontpage'.obs;
  RxList subscriptions = [].obs;
  RxString time = 'week'.obs;

  Future getInitPosts() async {
    this.after.value = '';
    this.posts.clear();

    final Map<String, dynamic> _data = await reddit.getPosts(
      after: '',
      limit: 50,
      listing: this.listing.value,
      subreddit: this.name.value,
      time: this.time.value,
    );

    this.after.value = _data['after'];
    this.posts.value = _data['posts'];
  }

  Future getNextPosts() async {
    final Map<String, dynamic> _data = await reddit.getPosts(
      after: this.after.value,
      limit: 25,
      listing: this.listing.value,
      subreddit: this.name.value,
      time: this.time.value,
    );

    this.after.value = _data['after'];
    this.posts.addAll(_data['posts']);
  }

  Future getSubscriptions() async {
    final List subscriptions = await reddit.getUserSubreddits();
    if (subscriptions.length > 0) {
      this.subscriptions.value = subscriptions;
    }
  }
}
