import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_page_input_events.dart';
import 'chat_page_input_state.dart';

class ChatPageInputBloc extends Bloc<ChatPageInputEvent, ChatPageInputState> {
  RecorderController _recorderController = RecorderController();

  ChatPageInputBloc() : super(TextModeState()) {
    on<FocusTextEvent>((event, emit) {
      emit(TextModeState());
      if (_recorderController.isRecording) {
        _stopRecording();
      }
    });
    on<FocusAudioEvent>((event, emit) {
      emit(AudioModeState());
      _startRecording();
    });
  }

  void _startRecording() async {
    final hasPermission = await _recorderController.checkPermission();
    if (hasPermission) {
      await _recorderController.record();
    }
  }

  void _stopRecording() async {
    if (_recorderController.isRecording) {
      await _recorderController.stop();
    }
  }

  RecorderController get recorderController => _recorderController;
}
