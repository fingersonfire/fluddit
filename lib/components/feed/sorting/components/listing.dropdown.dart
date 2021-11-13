import 'package:fluddit/bloc/index.dart';
import 'package:flutter/material.dart';

class ListingDropdown extends StatelessWidget {
  ListingDropdown({Key? key, required}) : super(key: key);

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(25),
        ),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton<String>(
          value: reddit.listing.value,
          underline: Container(),
          icon: const Icon(Icons.expand_more_rounded),
          items: <String>[
            'hot',
            'best',
            'top',
            'new',
            'rising',
          ].map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: SizedBox(
                  width: 100,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (String? newValue) {
            reddit.listing.value = newValue ?? 'hot';
          },
        ),
      );
    });
  }
}
