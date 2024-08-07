import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/entities/chat_message.dart';
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
  final _messageRateBloc = Modular.get<MessageRateBloc>();
  final _chatPageBloc = Modular.get<ChatPageBloc>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () async {
            final question = _chatPageBloc.results.firstWhere(
                (chatMessage) => chatMessage.id == widget.chatMessage.id);
            final rateData = {
              'message_id': widget.chatMessage.id,
              'assistant_message': widget.chatMessage.message,
              'user_message': question.message ?? '',
              'feedback': '',
              'additional_info': '',
            };
            // await _messageRateBloc.sendLike(rateData);
            setState(() {
              if (!_isBadAnswer && _isGoodAnswer) {
                _isGoodAnswer = false;
                return;
              }
              _isGoodAnswer = !_isGoodAnswer;
              _isBadAnswer = !_isGoodAnswer;
            });
          },
          child: Icon(
            _isGoodAnswer
                ? Icons.thumb_up_off_alt_sharp
                : Icons.thumb_up_off_alt,
            size: 20,
            color: Colors.green,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (!_isGoodAnswer && _isBadAnswer) {
                _isBadAnswer = false;
                return;
              }
              _isBadAnswer = !_isBadAnswer;
              _isGoodAnswer = !_isBadAnswer;
            });
          },
          child: Icon(
            _isBadAnswer ? Icons.thumb_down_sharp : Icons.thumb_down_off_alt,
            size: 20,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
