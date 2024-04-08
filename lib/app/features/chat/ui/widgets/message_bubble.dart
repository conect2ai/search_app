import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isQuestion;
  late final Color bubbleColor;

  MessageBubble({
    super.key,
    required this.message,
    required this.isQuestion,
  }) {
    bubbleColor = isQuestion ? AppColors.mainColor : Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isQuestion ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
            padding: const EdgeInsets.all(15),
            width: 200,
            decoration: BoxDecoration(
                color: isQuestion ? bubbleColor : Colors.yellow,
                borderRadius: BorderRadius.circular(15)),
            child: Expanded(
              child: Text(
                message,
                style: AppTextStyles.chatMessageTextStyle,
                softWrap: true,
              ),
            ),
          ),
        ]);
  }
}
