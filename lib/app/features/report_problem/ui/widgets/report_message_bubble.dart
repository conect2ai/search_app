import 'package:flutter/material.dart';

import '../../../../core/entities/chat_message.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';

class ReportMessageBubble extends StatefulWidget {
  final ChatMessage chatMessage;
  final bool isQuestion;
  late final Color bubbleColor;

  ReportMessageBubble({
    super.key,
    required this.chatMessage,
    required this.isQuestion,
  }) {
    bubbleColor =
        isQuestion ? AppColors.questionCardColor : AppColors.responseCardColor;
  }

  @override
  State<ReportMessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<ReportMessageBubble> {
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
              ],
            ),
          ),
        ]);
  }
}
