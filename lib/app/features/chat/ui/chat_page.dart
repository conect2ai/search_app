import 'package:app_search/app/features/chat/interactor/blocs/chatpage_inputs/chat_page_input_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/themes/app_colors.dart';
import '../../../widgets/logo_appbar.dart';
import '../../auth/data/auth_repository.dart';
import '../interactor/blocs/chatpage/chat_page_bloc.dart';
import '../interactor/blocs/chatpage/chat_page_event.dart';
import '../interactor/blocs/chatpage/chat_page_states.dart';
import '../interactor/blocs/chatpage_inputs/chat_page_input_bloc.dart';
import '../interactor/blocs/chatpage_inputs/chat_page_input_state.dart';
import 'widgets/chat_page_input.dart';
import 'widgets/messages_list.dart';
import 'widgets/picture_container.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _bloc = Modular.get<ChatPageBloc>();
  final _chatInputBloc = Modular.get<ChatPageInputBloc>();
  final _authRepo = Modular.get<AuthRepository>();
  int lastIndex = 0;
  final LoadingOverlay _loadingOverlay = LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        appBar: LogoAppBar.generateLogoAppBar(context, _authRepo.logout),
        body: BlocListener<ChatPageInputBloc, ChatPageInputState>(
          bloc: _chatInputBloc,
          listener: (context, state) async {
            if (state is AwatingForResponstState) {
              _loadingOverlay.show(context);
            } else if (state is ResponseReceveidSuccessState) {
              _loadingOverlay.hide();
              _chatInputBloc.add(FocusTextEvent());
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: BlocBuilder<ChatPageBloc, ChatPageState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      if (state is InitialChatPageState) {
                        return const Text('Ask a question');
                      } else if (state is ReceiveResponseState) {
                        return MessagesList(
                          state: state,
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.grey, boxShadow: [
                  BoxShadow(
                      color: AppColors.mainColor,
                      offset: Offset(0, 0),
                      blurStyle: BlurStyle.solid,
                      blurRadius: 5)
                ]),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: const ChatPageInput(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingOverlay {
  OverlayEntry? _overlay;

  LoadingOverlay();

  void show(BuildContext context) {
    if (_overlay == null) {
      _overlay = OverlayEntry(
        // replace with your own layout
        builder: (context) => const ColoredBox(
          color: Color(0x80000000),
          child: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  AppColors.mainColor,
                ),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(_overlay!);
    }
  }

  void hide() {
    if (_overlay != null) {
      _overlay?.remove();
      _overlay = null;
    }
  }
}
