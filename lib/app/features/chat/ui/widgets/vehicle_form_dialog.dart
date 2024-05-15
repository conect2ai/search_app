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
  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedYear;
  final _vehicleFormKey = GlobalKey<FormState>();
  final Map<String, String> _vehicleData = {};
  final _vehicleFormBloc = Modular.get<VehicleFormBloc>();

  @override
  initState() {
    _vehicleFormBloc.getAvailableVehicles();
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
    _vehicleFormBloc.modelsSink.add([]);
    _vehicleFormBloc.yearsSink.add([]);
    setState(() {
      _vehicleData['brand'] = value ?? '';
      _vehicleData['model'] = '';
      _vehicleData['year'] = '';
      _selectedBrand = value;
      _selectedModel = null;
      _selectedYear = null;
      _vehicleFormBloc.updateModelsList(value!);
    });
  }

  void _updateYearItems(String? value) {
    _vehicleFormBloc.yearsSink.add([]);
    setState(() {
      _vehicleData['model'] = value ?? '';
      _vehicleData['year'] = '';
      _selectedModel = value;
      _selectedYear = null;
      _vehicleFormBloc.updateYearsList(_vehicleData['brand']!, value!);
    });
  }

  void _updateYearInfo(String? value) {
    setState(() {
      _vehicleData['year'] = value ?? '';
      _selectedYear = value ?? '';
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
                    _brandItems = snapshot.data!;
                  }
                  return CustomDropdownMenu<String>(
                    items: _brandItems
                        .map((brand) => DropdownMenuItem(
                              value: brand,
                              child: Text(brand),
                            ))
                        .toList(),
                    onChanged: _updateModelItems,
                    label: 'Select car brand',
                    hintText: 'Select car brand',
                    value: _selectedBrand,
                  );
                }),
            StreamBuilder<List<String>>(
                stream: _vehicleFormBloc.modelsStream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    _modelItems = snapshot.data!;
                  }
                  return CustomDropdownMenu<String>(
                    items: _modelItems
                        .map((model) => DropdownMenuItem(
                              value: model,
                              child: Text(model),
                            ))
                        .toList(),
                    onChanged: _updateYearItems,
                    label: 'Select car model',
                    hintText: 'Select car model',
                    value: _selectedModel,
                  );
                }),
            StreamBuilder<List<String>>(
                stream: _vehicleFormBloc.yearsStream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    _yearItems = snapshot.data!;
                  }
                  return CustomDropdownMenu<String>(
                    items: _yearItems
                        .map((year) =>
                            DropdownMenuItem(value: year, child: Text(year)))
                        .toList(),
                    onChanged: _updateYearInfo,
                    label: 'Select car year',
                    hintText: 'Select car year',
                    value: _selectedYear,
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
        _vehicleFormBloc.saveVehicleData(_vehicleData);
        Modular.to.pop();
        break;
      default:
    }
  }
}
