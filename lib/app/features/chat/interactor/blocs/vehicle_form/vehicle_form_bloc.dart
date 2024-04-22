import 'dart:async';

import 'package:rxdart/subjects.dart';

import '../../../../../mixins/secure_storage.dart';
import '../../../data/vehicle_info_repository.dart';

class VehicleFormBloc with SecureStorage {
  final VehicleInfoRepository _vehicleInfoRepository;

  VehicleFormBloc(this._vehicleInfoRepository);

  final StreamController<List<String>> _brandsController =
      BehaviorSubject.seeded([]);
  Stream<List<String>> get brandsStream => _brandsController.stream;
  Sink<List<String>> get brandsSink => _brandsController.sink;
  final StreamController<List<String>> _modelsController =
      BehaviorSubject.seeded([]);
  Stream<List<String>> get modelsStream => _modelsController.stream;
  Sink<List<String>> get modelsSink => _modelsController.sink;

  Map<String, dynamic> vehicles = {};
  List<String> _brands = [];
  List<String> _models = [];

  void getAvailableVehicles() async {
    _brands = [];
    _models = [];
    vehicles = await _vehicleInfoRepository.getVehicleInfo();
  }

  void updateBrandsList() {
    _brands = [];
    vehicles.forEach((key, value) {
      final brand = key;
      _brands.add(brand);
      brandsSink.add(_brands);
    });
  }

  void updateModelsList(String brand) {
    _models = [];
    final valueMap = vehicles[brand];
    print(valueMap);
    final modelList = valueMap.keys;
    for (var model in modelList) {
      _models.add(model);
    }
    modelsSink.add(_models);
  }

  void saveVehicleData(Map<String, String> vehicleInfo) {
    writeSecureData('brand', vehicleInfo['brand']);
    writeSecureData('model', vehicleInfo['model']);
    writeSecureData('year', vehicleInfo['year']);
  }
}
