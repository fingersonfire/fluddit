import 'package:fluddit/bloc/index.dart';
import 'package:flutter/material.dart';

class TimeDropdown extends StatelessWidget {
  TimeDropdown({Key? key, required}) : super(key: key);

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton<String>(
          value: reddit.time.value,
          underline: Container(),
          icon: Icon(Icons.expand_more_rounded),
          items: <String>[
            'day',
            'week',
            'month',
            'year',
            'all',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                width: 100,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 22),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            reddit.time.value = newValue ?? 'day';
          },
        ),
      );
    });
  }
}
