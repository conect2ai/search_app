import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/entities/chat_message.dart';
import '../../../data/search_repository.dart';
import 'chat_page_event.dart';
import 'chat_page_states.dart';

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  final SearchRepository searchRepository;
  final List<ChatMessage> _results = [];
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  ChatPageBloc({required this.searchRepository})
      : super(InitialChatPageState()) {
    on<RemoveImageEvent>((event, emit) {
      _selectedImage = null;
      emit(InitialChatPageState());
    });
    on<SendTextEvent>(
      (event, emit) async {
        _results.add(ChatMessage(
            message: event.question,
            isQuestion: true,
            isAudio: false,
            imagePath: _selectedImage?.path));
        if (_selectedImage != null) {
          _results.add(ChatMessage(
            message: await searchRepository.sendQuestionByTextWithImage(
                event.question, _selectedImage!.path),
            isQuestion: false,
            isAudio: false,
          ));
        } else {
          _results.add(ChatMessage(
              message:
                  await searchRepository.sendQuestionByText(event.question),
              isQuestion: false,
              isAudio: false));
        }
        emit(ReceiveResponseState(results: _results));
      },
    );
    on<SendAudioEvent>(
      (event, emit) async {
        if (_selectedImage != null && event.path.isNotEmpty) {
          _results.add(ChatMessage(
              audioPath: event.path,
              isQuestion: true,
              isAudio: true,
              imagePath: _selectedImage!.path));
          final convertedAudio = await searchRepository.sendQuestionByAudio(
              event.path, _selectedImage?.path ?? '');
          final answer = await searchRepository.sendQuestionByTextWithImage(
              convertedAudio, _selectedImage!.path);

          _results.add(ChatMessage(
            isQuestion: false,
            isAudio: false,
            message: answer,
          ));
          emit(ReceiveResponseState(results: _results));
        }
      },
    );
    on<SelectImageEvent>(
        (event, emit) => emit(ImageSelectedState(file: event.file)));
  }

  void pickImage(ImageSource source) async {
    final file = await _imagePicker.pickImage(source: source);
    if (file != null) {
      _selectedImage = File(file.path);
      add(SelectImageEvent(file: file));
    }
  }
}
