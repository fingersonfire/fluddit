import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GalleryContent extends StatelessWidget {
  GalleryContent({
    Key? key,
    required this.constraints,
    required this.post,
  }) : super(key: key);

  final BoxConstraints constraints;
  final RedditPost post;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        height: constraints.maxHeight - 115,
        viewportFraction: 1,
      ),
      items: List.generate(
        post.galleryData.length,
        (i) {
          return Stack(
            children: [
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.all(15),
                child: Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.black45,
                  child: Text('${i + 1} / ${post.galleryData.length}'),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Image.network(
                  'https://i.redd.it/${post.galleryData[i]['media_id']}.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: constraints.maxHeight - 115,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
