import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../mixins/custom_dialogs.dart';
import '../../interactor/blocs/vehicle_form/vehicle_form_bloc.dart';
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
  final _vehicleFormBloc = Modular.get<VehicleFormBloc>();

  @override
  initState() {
    _vehicleFormBloc.updateBrandsList();
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

  void _updateModelItems(String? value) {
    setState(() {
      _vehicleData['brand'] = value;
      _vehicleFormBloc.updateModelsList(value!);
    });
  }

  void _updateYearItems(String? value) {
    setState(() {
      _vehicleData['model'] = value;
      _vehicleFormBloc.updateYearsList(_vehicleData['brand']!, value!);
    });
  }

  void _updateYearInfo(String? value) {
    setState(() {
      _vehicleData['year'] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Select Vehicle',
        content: _buildForm(),
        actions: ['Cancel', 'Done'],
        callBack: onTapActions);
  }

  Widget _buildForm() {
    return Form(
      key: _vehicleFormKey,
      child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 20,
          runSpacing: 30,
          direction: Axis.vertical,
          children: [
            StreamBuilder<List<String>>(
                stream: _vehicleFormBloc.brandsStream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    if (snapshot.data!.isNotEmpty) {
                      _brandItems = snapshot.data!;
                    }
                  }
                  return CustomDropdownMenu<String>(
                    items: _brandItems
                        .map((brand) => DropdownMenuEntry(
                              value: brand,
                              label: brand,
                            ))
                        .toList(),
                    onChanged: _updateModelItems,
                    label: 'Select car brand',
                    hintText: 'Select car brand',
                  );
                }),
            StreamBuilder<List<String>>(
                stream: _vehicleFormBloc.modelsStream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    if (snapshot.data!.isNotEmpty) {
                      _modelItems = snapshot.data!;
                    }
                  }
                  return CustomDropdownMenu<String>(
                    items: _modelItems
                        .map((model) =>
                            DropdownMenuEntry(value: model, label: model))
                        .toList(),
                    onChanged: _updateYearItems,
                    label: 'Select car model',
                    hintText: 'Select car model',
                  );
                }),
            StreamBuilder<List<String>>(
                stream: _vehicleFormBloc.yearsStream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    if (snapshot.data!.isNotEmpty) {
                      _yearItems = snapshot.data!;
                    }
                  }
                  return CustomDropdownMenu<String>(
                    items: _yearItems
                        .map((year) =>
                            DropdownMenuEntry(value: year, label: year))
                        .toList(),
                    onChanged: _updateYearInfo,
                    label: 'Select car year',
                    hintText: 'Select car year',
                  );
                }),
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
