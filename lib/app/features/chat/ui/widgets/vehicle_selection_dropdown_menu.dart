import 'package:flutter/material.dart';

import '../../../../core/themes/app_text_styles.dart';

class VehicleSelectionDropdownMenu extends StatefulWidget {
  const VehicleSelectionDropdownMenu({super.key});

  @override
  State<VehicleSelectionDropdownMenu> createState() =>
      _VehicleSelectionDropdownMenuState();
}

class _VehicleSelectionDropdownMenuState
    extends State<VehicleSelectionDropdownMenu> {
  final _vehicleSelectionController = TextEditingController();

  @override
  void initState() {
    _vehicleSelectionController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.blue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Marca',
            style: AppTextStyles.dropdownMenuTitleTextStyle,
          ),
          const SizedBox(
            height: 8,
          ),
          DropdownMenu(
            menuHeight: 110,
            trailingIcon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 20,
            ),
            hintText: 'Selecione a marca',
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
          const SizedBox(
            height: 8,
          ),
          Text(
            'Modelo',
            style: AppTextStyles.dropdownMenuTitleTextStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          DropdownMenu(
            menuHeight: 110,
            trailingIcon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 20,
            ),
            hintText: 'Selecione o modelo',
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
          const SizedBox(
            height: 8,
          ),
          Text(
            'Ano',
            style: AppTextStyles.dropdownMenuTitleTextStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          DropdownMenu(
            menuHeight: 110,
            trailingIcon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 20,
            ),
            hintText: 'Selecione o ano',
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
        ],
      ),
    );
  }
}
