import 'dart:math';

import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/post/reply/components/comment.textfield.dart';
import 'package:fluddit/components/post/reply/components/format.buttons.dart';
import 'package:fluddit/components/post/reply/components/quote.button.dart';
import 'package:fluddit/components/post/reply/components/send.button.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void replyDialog(
  BuildContext context,
  String fullName,
  String postId,
  String quoteText,
) {
  final TextEditingController textController = TextEditingController();

  void insertText({required String insert, int? positionFromEnd}) {
    final int cursorPos = textController.selection.base.offset;

    textController.value = textController.value.copyWith(
      text: textController.text.replaceRange(
        max(cursorPos, 0),
        max(cursorPos, 0),
        insert,
      ),
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: max(cursorPos, 0) + (insert.length - (positionFromEnd ?? 0)),
        ),
      ),
    );
  }

  Get.bottomSheet(
    GestureDetector(
      onTap: () {
        FocusNode().requestFocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Container(
        color: Theme.of(context).cardColor,
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            QuoteButton(insertText: insertText, quoteText: quoteText),
            Expanded(
              child: CommentInput(textController: textController),
            ),
            FormatButtons(insertText: insertText),
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color(0xFF2e3440),
                    ),
                  ),
                  SendCommentButton(
                    fullName: fullName,
                    postId: postId,
                    textController: textController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    enterBottomSheetDuration: const Duration(milliseconds: 150),
    exitBottomSheetDuration: const Duration(milliseconds: 150),
  );
}
