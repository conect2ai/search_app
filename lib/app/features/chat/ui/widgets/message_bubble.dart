import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isQuestion;
  Color bubbleColor;

  MessageBubble(
      {required this.message,
      required this.isQuestion,
      this.bubbleColor = AppColors.mainColor});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isQuestion ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: isQuestion ? bubbleColor : Colors.yellow,
                borderRadius: BorderRadius.circular(15)),
            child: Text(
              message,
              style: AppTextStyles.chatMessageTextStyle,
            ),
          ),
        ]);
  }
}