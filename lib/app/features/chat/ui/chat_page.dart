import 'dart:io';

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
  final _authRepo = Modular.get<AuthRepository>();
  int lastIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppBar.generateLogoAppBar(context, _authRepo.logout),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: BlocBuilder<ChatPageBloc, ChatPageState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is InitialChatPageState) {
                    return InkWell(
                        onTap: () => _bloc.pickImage(ImageSource.camera),
                        child: const PictureContainer());
                  } else if (state is ReceiveResponseState) {
                    return MessagesList(
                      state: state,
                    );
                  } else if (state is ImageSelectedState) {
                    return InkWell(
                        onTap: () => _bloc.pickImage(ImageSource.camera),
                        onLongPress: () => _bloc.add(RemoveImageEvent()),
                        child: PictureContainer(file: state.file));
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: const ChatPageInput(),
          )
        ],
      ),
    );
  }
}
