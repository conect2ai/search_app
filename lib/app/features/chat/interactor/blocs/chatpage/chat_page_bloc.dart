import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../blocs/loading_overlay_bloc.dart';
import '../../../../../blocs/loading_overlay_event.dart';
import '../../../../../core/entities/chat_message.dart';
import '../../../data/search_repository.dart';
import 'chat_page_event.dart';
import 'chat_page_states.dart';

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  final SearchRepository _searchRepository;
  final LoadingOverlayBloc _loadingOverlayBloc;
  final List<ChatMessage> _results = [];
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  ChatPageBloc(this._searchRepository, this._loadingOverlayBloc)
      : super(InitialChatPageState()) {
    on<SendTextEvent>(
      (event, emit) async {
        final messageId = DateTime.timestamp().toIso8601String();
        _results.add(ChatMessage(
            id: messageId,
            message: event.question,
            isQuestion: true,
            isAudio: false,
            imagePath: _selectedImage?.path ?? event.picture?.path));
        emit(ReceiveResponseState(results: _results));

        _loadingOverlayBloc.add(ShowLoadingOverlayEvent());
        if (_selectedImage != null || event.picture != null) {
          try {
            final message = await _searchRepository.sendQuestionByTextWithImage(
                event.question, _selectedImage?.path ?? event.picture!.path);

            _results.add(ChatMessage(
              id: message['response_id'],
              message: message['response_content'],
              isQuestion: false,
              isAudio: false,
            ));
            _selectedImage = null;
          } catch (_) {
            _loadingOverlayBloc.add(
                ShowErrorEvent(message: 'Failed to communicate with server'));
          }
        } else {
          try {
            final message =
                await _searchRepository.sendQuestionByText(event.question);
            // final message =
            //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse at arcu eros. Sed et tincidunt lectus. Nam lectus dolor, iaculis at tristique non, gravida a dolor. Ut in nisi dui. Sed tristique vestibulum dignissim. Etiam at ligula eget libero porta eleifend sed quis nisl. Sed metus erat, euismod et lorem.';

            _results.add(ChatMessage(
                id: message['response_id'].toString(),
                message: message['response_content'].toString(),
                isQuestion: false,
                isAudio: false));
          } catch (_) {
            _loadingOverlayBloc.add(
                ShowErrorEvent(message: 'Failed to communicate with server'));
          }
        }
        _loadingOverlayBloc.add(HideLoadingOverlayEvent());
        emit(ReceiveResponseState(results: _results));
      },
    );
    on<SendAudioEvent>(
      (event, emit) async {
        final messageId = DateTime.timestamp().toIso8601String();
        if (event.path.isNotEmpty) {
          _results.add(ChatMessage(
            id: messageId,
            audioPath: event.path,
            isQuestion: true,
            isAudio: true,
          ));
          emit(ReceiveResponseState(results: _results));
          _loadingOverlayBloc.add(ShowLoadingOverlayEvent());
          try {
            final message = await _searchRepository.sendQuestionByAudio(
              event.path,
            );

            _results.add(ChatMessage(
              id: message['response_id'],
              isQuestion: false,
              isAudio: false,
              message: message['response_content'],
            ));
          } catch (_) {
            _loadingOverlayBloc.add(
                ShowErrorEvent(message: 'Failed to communicate with server'));
          }

          _loadingOverlayBloc.add(HideLoadingOverlayEvent());
          emit(ReceiveResponseState(results: _results));
        }
      },
    );
  }

  List<ChatMessage> get results => _results;

  void pickImage(ImageSource source) async {
    final file = await _imagePicker.pickImage(source: source);
    if (file != null) {
      _selectedImage = File(file.path);
    }
  }
}
