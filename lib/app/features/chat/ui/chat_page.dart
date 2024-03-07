import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../widgets/logo_appbar.dart';
import '../interactor/blocs/chatpage/chat_page_bloc.dart';
import '../interactor/blocs/chatpage/chat_page_states.dart';
import 'widgets/chat_page_input.dart';
import 'widgets/messages_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _bloc = Modular.get<ChatPageBloc>();
  int lastIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppBar.generateLogoAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: BlocBuilder<ChatPageBloc, ChatPageState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is InitialChatPageState) {
                    return Text(
                      state.message,
                      style: AppTextStyles.mainTextStyle,
                    );
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
            decoration: const BoxDecoration(color: Colors.grey, boxShadow: [
              BoxShadow(
                  color: AppColors.mainColor,
                  offset: Offset(0, 0),
                  blurStyle: BlurStyle.solid,
                  blurRadius: 5)
            ]),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: const ChatPageInput(),
          )
        ],
      ),
    );
  }
}
