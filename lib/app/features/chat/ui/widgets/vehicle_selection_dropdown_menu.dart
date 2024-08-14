import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../interactor/blocs/vehicle_form/vehicle_form_bloc.dart';

class VehicleSelectionDropdownMenu extends StatefulWidget {
  const VehicleSelectionDropdownMenu({super.key});

  @override
  State<VehicleSelectionDropdownMenu> createState() =>
      _VehicleSelectionDropdownMenuState();
}

class _VehicleSelectionDropdownMenuState
    extends State<VehicleSelectionDropdownMenu> {
  final _vehicleFormBloc = Modular.get<VehicleFormBloc>();

  final _brandSelectionController = TextEditingController();
  final _modelSelectionController = TextEditingController();
  final _yearSelectionController = TextEditingController();

  var _brandborderColor = Colors.white;
  var _modelborderColor = Colors.white;
  var _yearborderColor = Colors.white;

  // List<String> _brandItems = [];
  // List<String> _modelItems = [];
  // List<String> _yearItems = [];

  // String? _selectedBrand;
  // String? _selectedModel;
  // String? _selectedYear;

  final Map<String, String> _vehicleData = {};

  @override
  void initState() {
    _vehicleFormBloc.getAvailableVehicles();
    _vehicleFormBloc.updateBrandsList();
    super.initState();
  }

  void _updateModelItems(String? value) {
    _vehicleFormBloc.modelsSink.add([]);
    _vehicleFormBloc.yearsSink.add([]);
    setState(() {
      _vehicleData['brand'] = value ?? '';
      _vehicleData['model'] = '';
      _vehicleData['year'] = '';
      _vehicleFormBloc.updateModelsList(value!);
      _modelSelectionController.clear();
      _yearSelectionController.clear();
    });
  }

  void _updateYearItems(String? value) {
    _vehicleFormBloc.yearsSink.add([]);
    setState(() {
      _vehicleData['model'] = value ?? '';
      _vehicleData['year'] = '';
      _vehicleFormBloc.updateYearsList(_vehicleData['brand']!, value!);
      _yearSelectionController.clear();
    });
  }

  void _updateYearInfo(String? value) {
    setState(() {
      _vehicleData['year'] = value ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
          StreamBuilder<List<String>>(
              stream: _vehicleFormBloc.brandsStream,
              builder: (context, snapshot) {
                final brands = snapshot.data ?? [];
                return DropdownMenu(
                  width: screenWidth * 0.62,
                  enabled: brands.isNotEmpty,
                  onSelected: (value) {
                    FocusScope.of(context).unfocus();
                    if (value != null) {
                      _updateModelItems(value);
                      setState(() {
                        _brandborderColor = AppColors.mainColor;
                      });
                    }
                  },
                  menuHeight: 110,
                  trailingIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 20,
                  ),
                  hintText: 'Selecione a marca',
                  controller: _brandSelectionController,
                  requestFocusOnTap: true,
                  textStyle: AppTextStyles.textFieldTextStyle,
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    hintStyle: AppTextStyles.textFieldTextStyle,
                    constraints: const BoxConstraints(maxHeight: 40),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: _brandborderColor)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: _brandborderColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: _brandborderColor)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: _yearborderColor)),
                  ),
                  dropdownMenuEntries: brands
                      .map((brand) => DropdownMenuEntry(
                            value: brand,
                            label: brand,
                          ))
                      .toList(),
                  // const [
                  //   DropdownMenuEntry(
                  //     value: 'Honda civic 2021',
                  //     label: 'Honda Civic 2021',
                  //   ),
                  //   DropdownMenuEntry(
                  //     value: 'Toyota corolla 2023',
                  //     label: 'Toyota Corola 2023',
                  //   ),
                  //   DropdownMenuEntry(
                  //     value: 'Toyota hilux 2023',
                  //     label: 'Toyota Hilux 2023',
                  //   ),
                  //   DropdownMenuEntry(
                  //     value: 'Volkswagen Polo 2023',
                  //     label: 'Volkswagen Polo  2023',
                  //   ),
                  // ],
                );
              }),
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
          StreamBuilder<List<String>>(
              stream: _vehicleFormBloc.modelsStream,
              builder: (context, snapshot) {
                final models = snapshot.data ?? [];
                return DropdownMenu(
                  enabled: models.isNotEmpty,
                  width: screenWidth * 0.62,
                  menuHeight: 110,
                  trailingIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 20,
                  ),
                  onSelected: (value) {
                    FocusScope.of(context).unfocus();
                    if (value != null) {
                      _updateYearItems(value);
                      setState(() {
                        _modelborderColor = AppColors.mainColor;
                      });
                    }
                  },
                  hintText: 'Selecione o modelo',
                  controller: _modelSelectionController,
                  requestFocusOnTap: true,
                  textStyle: AppTextStyles.textFieldTextStyle,
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    hintStyle: AppTextStyles.textFieldTextStyle,
                    constraints: const BoxConstraints(maxHeight: 40),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: _modelborderColor)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: _modelborderColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: _modelborderColor)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: _yearborderColor)),
                  ),
                  dropdownMenuEntries: models
                      .map((model) => DropdownMenuEntry(
                            value: model,
                            label: model,
                          ))
                      .toList(),
                  // const [
                  //   DropdownMenuEntry(
                  //     value: 'Honda civic 2021',
                  //     label: 'Honda Civic 2021',
                  //   ),
                  //   DropdownMenuEntry(
                  //     value: 'Toyota corolla 2023',
                  //     label: 'Toyota Corola 2023',
                  //   ),
                  //   DropdownMenuEntry(
                  //     value: 'Toyota hilux 2023',
                  //     label: 'Toyota Hilux 2023',
                  //   ),
                  //   DropdownMenuEntry(
                  //     value: 'Volkswagen Polo 2023',
                  //     label: 'Volkswagen Polo  2023',
                  //   ),
                  // ],
                );
              }),
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
          StreamBuilder<List<String>>(
              stream: _vehicleFormBloc.yearsStream,
              builder: (context, snapshot) {
                final years = snapshot.data ?? [];
                return DropdownMenu(
                  enabled: years.isNotEmpty,
                  width: screenWidth * 0.62,
                  menuHeight: 110,
                  trailingIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 20,
                  ),
                  onSelected: (value) {
                    FocusScope.of(context).unfocus();
                    if (value != null) {
                      _updateYearInfo(value);
                      _vehicleFormBloc.saveVehicleData(_vehicleData);
                      setState(() {
                        _yearborderColor = AppColors.mainColor;
                      });
                    }
                  },
                  hintText: 'Selecione o ano',
                  controller: _yearSelectionController,
                  requestFocusOnTap: true,
                  textStyle: AppTextStyles.textFieldTextStyle,
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    hintStyle: AppTextStyles.textFieldTextStyle,
                    constraints: const BoxConstraints(maxHeight: 40),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: _yearborderColor)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: _yearborderColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: _yearborderColor)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: _yearborderColor)),
                  ),
                  dropdownMenuEntries: years
                      .map((year) => DropdownMenuEntry(
                            value: year,
                            label: year,
                          ))
                      .toList(),
                  // const [
                  //   DropdownMenuEntry(
                  //     value: 'Honda civic 2021',
                  //     label: 'Honda Civic 2021',
                  //   ),
                  //   DropdownMenuEntry(
                  //     value: 'Toyota corolla 2023',
                  //     label: 'Toyota Corola 2023',
                  //   ),
                  //   DropdownMenuEntry(
                  //     value: 'Toyota hilux 2023',
                  //     label: 'Toyota Hilux 2023',
                  //   ),
                  //   DropdownMenuEntry(
                  //     value: 'Volkswagen Polo 2023',
                  //     label: 'Volkswagen Polo  2023',
                  //   ),
                  // ],
                );
              }),
        ],
      ),
    );
  }
}
