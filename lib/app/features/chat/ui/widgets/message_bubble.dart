import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/entities/chat_message.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../interactor/blocs/chatpage/chat_page_bloc.dart';
import '../../interactor/blocs/message_rate/message_rate_bloc.dart';

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
    bubbleColor = isQuestion ? AppColors.mainColor : Colors.orange;
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
          Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: 200,
              decoration: BoxDecoration(
                  color: widget.isQuestion ? widget.bubbleColor : Colors.yellow,
                  borderRadius: BorderRadius.circular(15)),
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
                    style: AppTextStyles.chatMessageTextStyle,
                    softWrap: true,
                  ),
                  widget.isQuestion
                      ? const SizedBox()
                      : Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            spacing: 5,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final question = _chatPageBloc.results
                                      .firstWhere((chatMessage) =>
                                          chatMessage.id ==
                                          widget.chatMessage.id);
                                  final rateData = {
                                    'message_id': widget.chatMessage.id,
                                    'assistant_message':
                                        widget.chatMessage.message,
                                    'user_message': question.message ?? '',
                                    'feedback': '',
                                    'additional_info': '',
                                  };
                                  await _messageRateBloc.sendLike(rateData);
                                  setState(() {
                                    if (!_isBadAnswer && _isGoodAnswer) {
                                      _isGoodAnswer = false;
                                      return;
                                    }
                                    _isGoodAnswer = !_isGoodAnswer;
                                    _isBadAnswer = !_isGoodAnswer;
                                  });
                                },
                                icon: Icon(
                                  Icons.thumb_up_sharp,
                                  color: _isGoodAnswer
                                      ? Colors.green
                                      : Colors.grey.shade400,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (!_isGoodAnswer && _isBadAnswer) {
                                      _isBadAnswer = false;
                                      return;
                                    }
                                    _isBadAnswer = !_isBadAnswer;
                                    _isGoodAnswer = !_isBadAnswer;
                                  });
                                },
                                icon: Icon(
                                  Icons.thumb_down,
                                  color: _isBadAnswer
                                      ? Colors.red
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ]);
  }
}
