import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/feed/sorting/components/listing.dropdown.dart';
import 'package:fluddit/components/feed/sorting/components/time.dropdown.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void sortDialog(BuildContext context) {
  final RedditController reddit = Get.find();

  Get.bottomSheet(
    GestureDetector(
      onTap: () {
        new FocusNode().requestFocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Container(
        color: Theme.of(context).cardColor,
        height: 190,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ListingDropdown(),
            TimeDropdown(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    reddit.getInitPosts(reddit.name.value);
                    Get.back();
                  },
                  child: Text(
                    'Apply',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    enterBottomSheetDuration: Duration(milliseconds: 150),
    exitBottomSheetDuration: Duration(milliseconds: 150),
  );
}
