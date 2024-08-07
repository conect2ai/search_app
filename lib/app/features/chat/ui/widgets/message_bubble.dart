import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/entities/chat_message.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../interactor/blocs/chatpage/chat_page_bloc.dart';
import '../../interactor/blocs/message_rate/message_rate_bloc.dart';
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
  bool _isGoodAnswer = false;

  bool _isBadAnswer = false;

  final _messageRateBloc = Modular.get<MessageRateBloc>();
  final _chatPageBloc = Modular.get<ChatPageBloc>();

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            widget.isQuestion ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: 216,
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
                widget.isQuestion
                    ? const SizedBox()
                    : LikeDislikeButton(
                        chatMessage: widget.chatMessage,
                      ),
                // : Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       GestureDetector(
                //         onTap: () async {
                //           final question = _chatPageBloc.results.firstWhere(
                //               (chatMessage) =>
                //                   chatMessage.id == widget.chatMessage.id);
                //           final rateData = {
                //             'message_id': widget.chatMessage.id,
                //             'assistant_message': widget.chatMessage.message,
                //             'user_message': question.message ?? '',
                //             'feedback': '',
                //             'additional_info': '',
                //           };
                //           // await _messageRateBloc.sendLike(rateData);
                //           setState(() {
                //             if (!_isBadAnswer && _isGoodAnswer) {
                //               _isGoodAnswer = false;
                //               return;
                //             }
                //             _isGoodAnswer = !_isGoodAnswer;
                //             _isBadAnswer = !_isGoodAnswer;
                //           });
                //         },
                //         child: Icon(
                //           Icons.thumb_up_sharp,
                //           size: 18,
                //           color: _isGoodAnswer
                //               ? Colors.green
                //               : Colors.grey.shade400,
                //         ),
                //       ),
                //       const SizedBox(
                //         width: 10,
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             if (!_isGoodAnswer && _isBadAnswer) {
                //               _isBadAnswer = false;
                //               return;
                //             }
                //             _isBadAnswer = !_isBadAnswer;
                //             _isGoodAnswer = !_isBadAnswer;
                //           });
                //         },
                //         child: Icon(
                //           Icons.thumb_down,
                //           size: 18,
                //           color: _isBadAnswer
                //               ? Colors.red
                //               : Colors.grey.shade400,
                //         ),
                //       ),
                //     ],
                //   ),
              ],
            ),
          ),
        ]);
  }
}
