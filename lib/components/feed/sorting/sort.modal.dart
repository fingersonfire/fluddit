import 'dart:io';

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
        FocusNode().requestFocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Container(
        color: Theme.of(context).cardColor,
        height: 225,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListingDropdown(),
                TimeDropdown(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    reddit.getInitPosts(reddit.name.value);
                    Get.back();
                  },
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            ConditionalWidget(
              condition: Platform.isIOS,
              trueWidget: const SizedBox(height: 5),
            ),
          ],
        ),
      ),
    ),
    enterBottomSheetDuration: const Duration(milliseconds: 150),
    exitBottomSheetDuration: const Duration(milliseconds: 150),
  );
}
