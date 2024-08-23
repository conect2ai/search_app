import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Filtrar',
                    style: AppTextStyles.drawerTitlesTextStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const VehicleSelectionDropdownMenu(),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
              Positioned(
                top: 380,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Opções',
                      style: AppTextStyles.drawerTitlesTextStyle,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.file_upload_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        'Exportar Chat',
                        style: AppTextStyles.drawerOptionsTextStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const ManualUploadWidgetDrawer(),
                    // TextButton.icon(
                    //   style: TextButton.styleFrom(
                    //       padding: EdgeInsets.zero,
                    //       alignment: Alignment.centerLeft),
                    //   onPressed: () {},
                    //   icon: const Icon(
                    //     Icons.file_download_outlined,
                    //     color: Colors.white,
                    //     size: 20,
                    //   ),
                    //   label: Text(
                    //     'Importar Manual',
                    //     style: AppTextStyles.drawerOptionsTextStyle,
                    //   ),
                    // ),
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
                      'Sair',
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
