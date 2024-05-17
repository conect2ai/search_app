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
    // on<RemoveImageEvent>((event, emit) {
    //   _selectedImage = null;
    //   emit(InitialChatPageState());
    // });
    on<SendTextEvent>(
      (event, emit) async {
        _results.add(ChatMessage(
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
              message: message,
              isQuestion: false,
              isAudio: false,
            ));
            _selectedImage = null;
          } on HttpException catch (error) {
            _loadingOverlayBloc.add(ShowErrorEvent(message: error.message));
          } catch (error) {
            _loadingOverlayBloc.add(ShowErrorEvent(message: error.toString()));
          }
        } else {
          try {
            final message =
                await _searchRepository.sendQuestionByText(event.question);
            _results.add(ChatMessage(
                message: message, isQuestion: false, isAudio: false));
          } catch (error) {
            _loadingOverlayBloc.add(ShowErrorEvent(message: error.toString()));
          }
        }
        _loadingOverlayBloc.add(HideLoadingOverlayEvent());
        emit(ReceiveResponseState(results: _results));
      },
    );
    on<SendAudioEvent>(
      (event, emit) async {
        if (event.path.isNotEmpty) {
          _results.add(ChatMessage(
            audioPath: event.path,
            isQuestion: true,
            isAudio: true,
          ));
          emit(ReceiveResponseState(results: _results));
          _loadingOverlayBloc.add(ShowLoadingOverlayEvent());
          try {
            final response = await _searchRepository.sendQuestionByAudio(
              event.path,
            );

            _results.add(ChatMessage(
              isQuestion: false,
              isAudio: false,
              message: response,
            ));
          } on HttpException catch (error) {
            _loadingOverlayBloc.add(ShowErrorEvent(message: error.message));
          } catch (error) {
            _loadingOverlayBloc.add(ShowErrorEvent(message: error.toString()));
          }

          _loadingOverlayBloc.add(HideLoadingOverlayEvent());
          emit(ReceiveResponseState(results: _results));
        }
      },
    );
  }

  void pickImage(ImageSource source) async {
    final file = await _imagePicker.pickImage(source: source);
    if (file != null) {
      _selectedImage = File(file.path);
    }
  }
}
