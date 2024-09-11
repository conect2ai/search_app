import 'dart:io';

import 'package:app_search/app/features/chat/interactor/blocs/chatpage_inputs/chat_page_input_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../blocs/loading_overlay_bloc.dart';
import '../../../../blocs/loading_overlay_state.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../mixins/custom_dialogs.dart';
import '../../../../widgets/custom_dialog.dart';
import '../../../../mixins/loading_overlay.dart';
import '../../../../mixins/logo_appbar.dart';
import '../../../auth/interactor/bloc/auth_bloc.dart';
import '../../interactor/blocs/chatpage/chat_page_bloc.dart';
import '../../interactor/blocs/chatpage/chat_page_states.dart';
import '../../interactor/blocs/chatpage_inputs/chat_page_input_bloc.dart';
import '../../interactor/blocs/vehicle_form/vehicle_form_bloc.dart';
import '../widgets/chat_page_input.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/messages_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with LoadingOverlay, LogoAppBar, CustomDialogs {
  final _bloc = Modular.get<ChatPageBloc>();
  final _authBloc = Modular.get<AuthBloc>();
  final _vehicleInfoBloc = Modular.get<VehicleFormBloc>();
  final _chatInputBloc = Modular.get<ChatPageInputBloc>();
  final _loadingOverlayBloc = Modular.get<LoadingOverlayBloc>();
  int lastIndex = 0;

  @override
  void initState() {
    _vehicleInfoBloc.getAvailableVehicles();
    _readVehicleData();
    super.initState();
  }

  void _readVehicleData() async {
    await _vehicleInfoBloc.readSecureVehicleData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        appBar: generateLogoAppBar(context)
        // generateLogoAppBar(context, [
        //   PopupMenuButton(
        //     icon: const Icon(
        //       Icons.more_vert,
        //       color: Colors.black,
        //     ),
        //     iconSize: 40,
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        //     onSelected: (option) async {
        //       if (option == 'Logout') {
        //         _authBloc.logout();
        //         // Modular.to.navigate('/');
        //       } else if (option == 'Api Key') {
        //         Modular.to.navigate('/home');
        //       } else if (option == 'Manual Upload') {
        //         dialog(context, ManualDialog());
        //       } else {
        //         dialog(context, const VehicleFormDialog());
        //       }
        //     },
        //     itemBuilder: (BuildContext context) {
        //       return {
        //         'Vehicle Settings',
        //         'Manual Upload',
        //         'Api Key',
        //         'Logout',
        //       }.map((String choice) {
        //         return PopupMenuItem<String>(
        //           value: choice,
        //           child: Text(choice),
        //         );
        //       }).toList();
        //     },
        //   )
        ,
        body: BlocListener<LoadingOverlayBloc, LoadingOverlayState>(
          bloc: _loadingOverlayBloc,
          listener: (context, state) async {
            if (state is ShowingLoadingOverlayState) {
              showOverlay(context);
            } else if (state is HidingLoadingOverlayState) {
              hideOverlay();
              _chatInputBloc.add(FocusTextEvent());
            } else if (state is OnErrorState) {
              hideOverlay();
              await showDialog(
                context: context,
                builder: (context) => CustomDialog(
                  message: state.message,
                  buttonMessage: 'Close',
                ),
              );
            }
          },
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: BlocBuilder<ChatPageBloc, ChatPageState>(
                      bloc: _bloc,
                      builder: (context, state) {
                        if (state is InitialChatPageState) {
                          return Text(
                            'Faça uma pergunta',
                            style: AppTextStyles.mainTextStyle,
                          );
                        } else if (state is ReceiveResponseState) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 0),
                            child: MessagesList(
                              state: state,
                            ),
                          );
                        } else {
                          return const SpinKitSpinningLines(
                            size: 100,
                            color: AppColors.mainColor,
                          );
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  child: const ChatPageInput(),
                ),
              ],
            ),
            Positioned(
              bottom: 60,
              right: 20,
              child: Stack(children: [
                StreamBuilder<File?>(
                    stream: _bloc.isImageSelectedStream,
                    builder: (context, snapshot) {
                      final selectedImage = snapshot.data;
                      return Visibility(
                        visible: selectedImage != null,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: AppColors.mainColor)),
                          height: 80,
                          width: 80,
                          child: selectedImage != null
                              ? Stack(children: [
                                  Image.file(
                                    selectedImage,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                      top: 2,
                                      right: 2,
                                      child: IconButton(
                                        iconSize: 20,
                                        onPressed: _bloc.removePicture,
                                        padding: EdgeInsets.zero,
                                        alignment: Alignment.topRight,
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                      )),
                                ])
                              : const SizedBox(),
                        ),
                      );
                    }),
              ]),
            ),
          ]),
        ),
        drawer: const CustomDrawer(),
      ),
    );
  }
}
