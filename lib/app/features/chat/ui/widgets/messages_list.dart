import 'package:flutter/material.dart';

import '../../interactor/blocs/chatpage/chat_page_states.dart';
import 'message_bubble.dart';
import 'audio_wave_bubble.dart';

class MessagesList extends StatefulWidget {
  final ReceiveResponseState state;
  const MessagesList({required this.state, super.key});

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  final _scrollController = ScrollController();
  int lastIndex = 0;

  void _updateScrollControllerPosition() {
    if (lastIndex != widget.state.results.length &&
        _scrollController.hasClients) {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 150,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear);
    }
    lastIndex = widget.state.results.length;
  }

  @override
  Widget build(BuildContext context) {
    _updateScrollControllerPosition();
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.state.results.length,
      itemBuilder: (context, index) {
        final message = widget.state.results[index];
        return message.isAudio
            ? Align(
                alignment: Alignment.centerRight,
                child: WaveBubble(
                  path: message.audioPath!,
                ))
            : MessageBubble(
                chatMessage: message,
                isQuestion: message.isQuestion,
                imagePath: message.imagePath,
              );
      },
    );
  }
}
