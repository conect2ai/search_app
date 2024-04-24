import 'dart:async';

import 'package:rxdart/subjects.dart';

import '../../../../../core/entities/car_info.dart';
import '../../../../../mixins/secure_storage.dart';
import '../../../data/vehicle_info_repository.dart';

class VehicleFormBloc with SecureStorage {
  final VehicleInfoRepository _vehicleInfoRepository;
  final CarInfo _carInfo;

  VehicleFormBloc(this._vehicleInfoRepository, this._carInfo);

  final StreamController<List<String>> _brandsController =
      BehaviorSubject.seeded([]);
  Stream<List<String>> get brandsStream => _brandsController.stream;
  Sink<List<String>> get brandsSink => _brandsController.sink;

  final StreamController<List<String>> _modelsController =
      BehaviorSubject.seeded([]);
  Stream<List<String>> get modelsStream => _modelsController.stream;
  Sink<List<String>> get modelsSink => _modelsController.sink;

  final StreamController<List<String>> _yearsController =
      BehaviorSubject.seeded([]);
  Stream<List<String>> get yearsStream => _yearsController.stream;
  Sink<List<String>> get yearsSink => _yearsController.sink;

  Map<String, dynamic> vehicles = {};
  List<String> _brands = [];
  List<String> _models = [];
  List<String> _years = [];

  void getAvailableVehicles() async {
    _brands = [];
    _models = [];
    _years = [];
    vehicles = await _vehicleInfoRepository.getVehicleInfo();
  }

  void updateBrandsList() {
    _brands = [];
    _models = [];
    _years = [];
    modelsSink.add(_models);
    yearsSink.add(_years);
    vehicles.forEach((key, value) {
      final brand = key;
      _brands.add(brand);
      brandsSink.add(_brands);
    });
  }

  void updateModelsList(String brand) {
    _models = [];
    _years = [];
    yearsSink.add(_years);
    final valueMap = vehicles[brand];
    final modelList = valueMap.keys;
    for (var model in modelList) {
      _models.add(model);
    }
    modelsSink.add(_models);
  }

  void updateYearsList(String brand, String model) {
    _years = [];
    final modelsMap = vehicles[brand];
    final yearsList = modelsMap[model] as List<dynamic>;
    for (var year in yearsList) {
      _years.add(year.toString());
    }
    yearsSink.add(_years);
  }

  void saveVehicleData(Map<String, String> vehicleInfo) {
    writeSecureData('brand', vehicleInfo['brand']);
    writeSecureData('model', vehicleInfo['model']);
    writeSecureData('year', vehicleInfo['year']);
    _carInfo.updateCarInfo(vehicleInfo);
  }
}
