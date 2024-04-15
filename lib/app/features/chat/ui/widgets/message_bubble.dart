import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String? imagePath;
  final bool isQuestion;
  late final Color bubbleColor;

  MessageBubble(
      {super.key,
      required this.message,
      required this.isQuestion,
      this.imagePath}) {
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: 200,
            decoration: BoxDecoration(
                color: isQuestion ? bubbleColor : Colors.yellow,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imagePath != null
                    ? Image.file(
                        File(imagePath!),
                        height: 150,
                        width: 220,
                        fit: BoxFit.fill,
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  message,
                  style: AppTextStyles.chatMessageTextStyle,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ]);
  }
}
