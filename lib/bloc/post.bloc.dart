import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';

class PostController extends GetxController {
  Rx<Post> single = Post(
    author: '',
    comments: <Comment>[],
    commentsLoaded: false,
    domain: '',
    fullName: '',
    galleryData: [],
    id: '',
    isGallery: false,
    isSelf: false,
    isVideo: false,
    metaData: {},
    postHint: '',
    saved: false,
    score: 0,
    selfText: '',
    stickied: false,
    subreddit: '',
    thumbnail: '',
    title: '',
    url: '',
    videoUrl: '',
    vote: 0,
  ).obs;

  Future<void> get(String id) async {}

  Future<void> getComments() async {}

  Future<void> vote() async {}
}
