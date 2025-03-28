import 'package:flutter/material.dart';

import '../../../chat/ui/widgets/audio_wave_bubble.dart';
import '../../interactor/blocs/states/report_problem_page_states.dart';
import 'report_message_bubble.dart';

class ReportPageMessagesList extends StatefulWidget {
  final ReceiveReportResponseState state;
  const ReportPageMessagesList({required this.state, super.key});

  @override
  State<ReportPageMessagesList> createState() => _ReportPageMessagesListState();
}

class _ReportPageMessagesListState extends State<ReportPageMessagesList> {
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
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(
        height: 20,
      ),
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
            : ReportMessageBubble(
                chatMessage: message,
                isQuestion: message.isQuestion,
              );
      },
    );
  }
}
