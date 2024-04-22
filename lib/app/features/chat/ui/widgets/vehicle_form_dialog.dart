import 'package:app_search/app/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../mixins/custom_dialogs.dart';
import 'custom_dropdown_menu.dart';

class VehicleFormDialog extends StatefulWidget {
  const VehicleFormDialog({super.key});

  @override
  State<VehicleFormDialog> createState() => _VehicleFormDialogState();
}

class _VehicleFormDialogState extends State<VehicleFormDialog>
    with CustomDialogs {
  List<String> _brandItems = [];
  List<String> _modelItems = [];
  List<String> _yearItems = [];
  final _vehicleFormKey = GlobalKey<FormState>();
  final Map<String, String?> _vehicleData = {};

  @override
  initState() {
    _brandItems = brands;
    super.initState();
  }

  List<String> brands = [
    'Volkswagen',
    'Fiat',
    'Ford',
    'Jeep',
    'Chevrolet',
    'Nissan',
    'Mitsubish'
  ];
  Map<String, List<String>> models = {
    'Volkswagen': ['Polo', 'Golf'],
    'Fiat': ['Toro'],
    'Ford': [
      'Focus',
    ],
  };

  Map<String, List<String>> years = {
    'Polo': ['2019', '2020', '2021'],
    'Golf': ['2020', '2021', '2022'],
    'Toro': ['2020', '2021', '2022'],
    'Focus': ['2022', '2023', '2024'],
  };

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Select Vehicle',
        content: _buildForm(),
        actions: ['Cancel', 'Done'],
        callBack: onTapActions);
  }

  void _updateModelItems(String? value) {
    setState(() {
      _vehicleData['brand'] = value;
      _modelItems = models[value] ?? [];
    });
  }

  void _updateYearItems(String? value) {
    setState(() {
      _vehicleData['model'] = value;
      _yearItems = years[value] ?? [];
    });
  }

  void _updateYearInfo(String? value) {
    setState(() {
      _vehicleData['year'] = value;
    });
  }

  Widget _buildForm() {
    return Form(
      key: _vehicleFormKey,
      child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          direction: Axis.vertical,
          children: [
            CustomDropdownMenu<String>(
              items: _brandItems
                  .map((brand) => DropdownMenuEntry(value: brand, label: brand))
                  .toList(),
              onChanged: _updateModelItems,
              label: 'Brand',
            ),
            CustomDropdownMenu<String>(
              items: _modelItems
                  .map((model) => DropdownMenuEntry(value: model, label: model))
                  .toList(),
              onChanged: _updateYearItems,
              label: 'Model',
            ),
            CustomDropdownMenu<String>(
              items: _yearItems
                  .map((year) => DropdownMenuEntry(value: year, label: year))
                  .toList(),
              onChanged: _updateYearInfo,
              label: 'Year',
            ),
          ]),
    );
  }

  void onTapActions(int index) {
    switch (index) {
      case 0:
        Modular.to.pop();
        break;
      case 1:
        print('validate form: $_vehicleData');
        Modular.to.pop();
        break;
      default:
    }
  }
}
