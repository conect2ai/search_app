import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final _vehicleSelectionController = TextEditingController();

  @override
  void initState() {
    _vehicleSelectionController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: AppColors.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 200,
              ),
              Text(
                'Filtrar',
                style: AppTextStyles.drawerTitlesTextStyle,
              ),
              const SizedBox(
                height: 15,
              ),
              Theme(
                data: Theme.of(context).copyWith(canvasColor: Colors.blue),
                child: DropdownMenu(
                  menuHeight: 110,
                  trailingIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 20,
                  ),
                  hintText: 'Select Vehicle',
                  controller: _vehicleSelectionController,
                  requestFocusOnTap: true,
                  textStyle: AppTextStyles.textFieldTextStyle,
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    hintStyle: AppTextStyles.textFieldTextStyle,
                    constraints: const BoxConstraints(maxHeight: 40),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.white)),
                  ),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                      value: 'Honda civic 2021',
                      label: 'Honda Civic 2021',
                    ),
                    DropdownMenuEntry(
                      value: 'Toyota corolla 2023',
                      label: 'Toyota Corola 2023',
                    ),
                    DropdownMenuEntry(
                      value: 'Toyota hilux 2023',
                      label: 'Toyota Hilux 2023',
                    ),
                    DropdownMenuEntry(
                      value: 'Volkswagen Polo 2023',
                      label: 'Volkswagen Polo  2023',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Opções',
                style: AppTextStyles.drawerTitlesTextStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.file_upload_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'Exportar Chat',
                  style: AppTextStyles.drawerOptionsTextStyle,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.file_download_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'Importar Manual',
                  style: AppTextStyles.drawerOptionsTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
