import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/entities/chat_message.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../interactor/blocs/chatpage/chat_page_bloc.dart';
import '../../interactor/blocs/message_rate/message_rate_bloc.dart';

class LikeDislikeButton extends StatefulWidget {
  final ChatMessage chatMessage;
  const LikeDislikeButton({required this.chatMessage, super.key});

  @override
  State<LikeDislikeButton> createState() => _LikeDislikeButtonState();
}

class _LikeDislikeButtonState extends State<LikeDislikeButton> {
  bool _isGoodAnswer = false;
  bool _isBadAnswer = false;
  bool _isCommentaryTextFieldClosed = true;
  bool _isCommentaryDone = false;
  final _messageRateBloc = Modular.get<MessageRateBloc>();
  final _chatPageBloc = Modular.get<ChatPageBloc>();

  final _commentaryFocusNode = FocusNode();
  final _commentaryTextController = TextEditingController();

  void _sendMessageRate() {
    final formData = {
      "response_id": widget.chatMessage.id!,
      "additional_info": _commentaryTextController.text
    };

    _isGoodAnswer
        ? _messageRateBloc.sendLike(formData)
        : _messageRateBloc.sendDislike(formData);

    setState(() {
      _isCommentaryTextFieldClosed = true;
      _isCommentaryDone = true;
    });
  }

  void _checkIfShouldCloseCommentary() {
    setState(() {
      if (_isBadAnswer == false && _isGoodAnswer == false) {
        _isCommentaryTextFieldClosed = true;
      } else {
        _isCommentaryTextFieldClosed = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () async {
            if (!_isCommentaryDone) {
              setState(() {
                if (!_isBadAnswer && _isGoodAnswer) {
                  _isGoodAnswer = false;
                  _checkIfShouldCloseCommentary();
                  return;
                }
                _isGoodAnswer = !_isGoodAnswer;
                _isBadAnswer = !_isGoodAnswer;

                _checkIfShouldCloseCommentary();
              });
            }
          },
          child: Icon(
            _isGoodAnswer
                ? Icons.thumb_up_off_alt_sharp
                : Icons.thumb_up_off_alt,
            size: _isGoodAnswer ? 16 : 20,
            color: Colors.green,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        GestureDetector(
          onTap: () {
            if (!_isCommentaryDone) {
              setState(() {
                if (!_isGoodAnswer && _isBadAnswer) {
                  _isBadAnswer = false;
                  _checkIfShouldCloseCommentary();
                  return;
                }
                _isBadAnswer = !_isBadAnswer;
                _isGoodAnswer = !_isBadAnswer;

                _checkIfShouldCloseCommentary();
              });
            }
          },
          child: Icon(
            _isBadAnswer ? Icons.thumb_down_sharp : Icons.thumb_down_off_alt,
            size: _isBadAnswer ? 16 : 20,
            color: Colors.red,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Visibility(
            maintainSize: false,
            visible: !_isCommentaryTextFieldClosed,
            child: Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 20,
                      child: TextField(
                        focusNode: _commentaryFocusNode,
                        controller: _commentaryTextController,
                        textAlignVertical: TextAlignVertical.center,
                        cursorHeight: 18,
                        style: TextStyle(fontSize: 12),
                        cursorColor: _isGoodAnswer ? Colors.green : Colors.red,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 7, top: 0),
                            hintText: 'Comentário',
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: _isGoodAnswer ? Colors.green : Colors.red,
                            )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: _isGoodAnswer ? Colors.green : Colors.red,
                            )),
                            hintStyle: AppTextStyles.commentaryHintTextStyle
                                .copyWith(
                                    color: _isGoodAnswer
                                        ? Colors.green
                                        : Colors.red),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: _isGoodAnswer
                                        ? Colors.green
                                        : Colors.red))),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (_commentaryFocusNode.hasFocus) {
                          _commentaryFocusNode.unfocus();
                        }
                        _sendMessageRate();
                        print(_commentaryTextController.text);
                      },
                      child: Text(
                        'SUBMIT',
                        style: AppTextStyles.commentarySubmitButtonTextStyle
                            .copyWith(
                                color:
                                    _isGoodAnswer ? Colors.green : Colors.red),
                      )),
                ],
              ),
            ))
      ],
    );
  }
}
