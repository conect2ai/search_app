import 'dart:io';

import 'package:app_search/app/features/chat/interactor/blocs/chat_page_event.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'chat_page_input_events.dart';
import 'chat_page_input_state.dart';

class ChatPageInputBloc extends Bloc<ChatPageInputEvent, ChatPageInputState> {
  RecorderController _recorderController = RecorderController();
  String? _path;
  late Directory _appDirectory;

  ChatPageInputBloc() : super(TextModeState()) {
    on<FocusTextEvent>((event, emit) {
      emit(TextModeState());
    });
    on<FocusAudioEvent>((event, emit) {
      emit(AudioModeState());
    });
  }

  void checkPermission() async {
    await _recorderController.checkPermission();
  }

  void getDir() async {
    _appDirectory = await getTemporaryDirectory();
  }

  String get path => _path!;

  void startRecording() async {
    final hasPermission = await _recorderController.checkPermission();
    if (hasPermission) {
      _path =
          '${_appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorderController.record(path: _path);
    }
  }

  void stopRecording() async {
    if (_recorderController.isRecording) {
      await _recorderController.stop();
    }
  }

  RecorderController get recorderController => _recorderController;
}
