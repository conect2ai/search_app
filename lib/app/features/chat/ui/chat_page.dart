import 'package:app_search/app/features/chat/interactor/blocs/chatpage_inputs/chat_page_input_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../blocs/loading_overlay_bloc.dart';
import '../../../blocs/loading_overlay_state.dart';
import '../../../core/themes/app_colors.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/loading_overlay.dart';
import '../../../widgets/logo_appbar.dart';
import '../../auth/data/auth_repository.dart';
import '../interactor/blocs/chatpage/chat_page_bloc.dart';
import '../interactor/blocs/chatpage/chat_page_states.dart';
import '../interactor/blocs/chatpage_inputs/chat_page_input_bloc.dart';
import 'widgets/chat_page_input.dart';
import 'widgets/messages_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _bloc = Modular.get<ChatPageBloc>();
  final _chatInputBloc = Modular.get<ChatPageInputBloc>();
  final _loadingOverlayBloc = Modular.get<LoadingOverlayBloc>();
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
        body: BlocListener<LoadingOverlayBloc, LoadingOverlayState>(
          bloc: _loadingOverlayBloc,
          listener: (context, state) async {
            if (state is ShowingLoadingOverlayState) {
              _loadingOverlay.showOverlay(context);
            } else if (state is HidingLoadingOverlayState) {
              _loadingOverlay.hideOverlay();
              _chatInputBloc.add(FocusTextEvent());
            } else if (state is OnErrorState) {
              _loadingOverlay.hideOverlay();
              await showDialog(
                context: context,
                builder: (context) => CustomDialog(
                  message: state.message,
                  buttonMessage: 'Close',
                ),
              );
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
                        return const SpinKitSpinningLines(
                          size: 100,
                          color: AppColors.mainColor,
                        );
                        ;
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
