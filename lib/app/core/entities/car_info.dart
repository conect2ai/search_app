class CarInfo {
  String _brand;
  String _model;
  String _year;

  CarInfo({brand = '', model = '', year = ''})
      : _brand = brand,
        _model = model,
        _year = year;

  void updateCarInfo(Map<String, String> carInfoMap) {
    _brand = carInfoMap['brand'] ?? '';
    _model = carInfoMap['model'] ?? '';
    _year = carInfoMap['year'] ?? '';
    print('brand: $_brand');
    print('model: $_model');
    print('year: $_year');
  }

  String get brand => _brand;
  String get model => _model;
  String get year => _year;
}
