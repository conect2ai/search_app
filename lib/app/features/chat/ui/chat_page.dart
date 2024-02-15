import 'package:app_search/app/features/chat/interactor/chat_page_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../widgets/logo_appbar.dart';
import '../interactor/chat_page_bloc.dart';
import '../interactor/chat_page_states.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _bloc = Modular.get<ChatPageBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppBar.generateLogoAppBar(context),
      body: Center(
        child: BlocBuilder<ChatPageBloc, ChatPageState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is InitialChatPageState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  IconButton(
                    onPressed: () => _bloc.add(SendTextEvent()),
                    icon: Icon(Icons.send),
                  )
                ],
              );
            } else if (state is ReceiveResponseState) {
              return Text("Sua resposa: ${state.response}");
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
