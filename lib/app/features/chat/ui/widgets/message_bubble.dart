import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/entities/chat_message.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import 'like_dislike_button.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage chatMessage;
  final String? imagePath;
  final bool isQuestion;
  late final Color bubbleColor;

  MessageBubble(
      {super.key,
      required this.chatMessage,
      required this.isQuestion,
      this.imagePath}) {
    bubbleColor =
        isQuestion ? AppColors.questionCardColor : AppColors.responseCardColor;
  }

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            widget.isQuestion ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: 230,
            decoration: BoxDecoration(
                color: widget.bubbleColor,
                borderRadius: widget.isQuestion
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.imagePath != null
                    ? Image.file(
                        File(widget.imagePath!),
                        height: 150,
                        width: 220,
                        fit: BoxFit.fill,
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.chatMessage.message ?? '',
                  style: widget.isQuestion
                      ? AppTextStyles.questionTextStyle
                      : AppTextStyles.responseTextStyle,
                  softWrap: true,
                ),
                const SizedBox(
                  height: 5,
                ),
                widget.isQuestion
                    ? const SizedBox()
                    : LikeDislikeButton(
                        chatMessage: widget.chatMessage,
                      ),
              ],
            ),
          ),
        ]);
  }
}
