import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../streams/general_stream.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../auth/interactor/bloc/auth_bloc.dart';
import '../../../manual/ui/widgets/manual_upload_widget_drawer.dart';
import 'vehicle_selection_dropdown_menu.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final _authBloc = Modular.get<AuthBloc>();

  @override
  void initState() {
    _getLanguage();
    super.initState();
  }

  Future<void> _getLanguage() async {
    final language = await _authBloc.getLanguage();

    setState(() {
      GeneralStream.languageStream.add(Locale(language ?? 'en'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      width: screenWidth * 0.75,
      backgroundColor: AppColors.backgroundColor,
      child: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Stack(
            children: [
              SizedBox(
                width: screenWidth * 0.72,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      context.localizations.filter,
                      style: AppTextStyles.drawerTitlesTextStyle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: screenWidth * 0.70,
                        child: const VehicleSelectionDropdownMenu()),
                    const SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 380,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localizations.options,
                      style: AppTextStyles.drawerTitlesTextStyle,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.file_upload_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: SizedBox(
                        width: screenWidth * 0.5,
                        child: Text(
                          context.localizations.exportChat,
                          style: AppTextStyles.drawerOptionsTextStyle,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const ManualUploadWidgetDrawer(),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: screenWidth * 0.75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.language_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: screenWidth * 0.22,
                                child: Text(
                                  context.localizations.language,
                                  style: AppTextStyles.drawerOptionsTextStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: screenWidth * 0.36,
                            child: StreamBuilder<Locale>(
                                stream: GeneralStream.languageStream.stream,
                                builder: (context, snapshot) {
                                  final data = snapshot.data;
                                  return DropdownButton(
                                    alignment: Alignment.centerRight,
                                    value: data?.languageCode,
                                    style: const TextStyle(color: Colors.white),
                                    dropdownColor: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(10),
                                    onChanged: (value) {
                                      if (value != null) {
                                        _authBloc.setLanguage(Locale(value));
                                        GeneralStream.languageStream
                                            .add(Locale(value.toString()));
                                      }
                                    },
                                    items: [
                                      DropdownMenuItem(
                                          value: 'en',
                                          child: Text(
                                              context.localizations.english)),
                                      DropdownMenuItem(
                                          value: 'pt',
                                          child: Text(
                                              context.localizations.portuguese))
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft),
                    onPressed: () => _authBloc.logout(),
                    child: Text(
                      context.localizations.logout,
                      style: AppTextStyles.logoutButtonTextStyle,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
