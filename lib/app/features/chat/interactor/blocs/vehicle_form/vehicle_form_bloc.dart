import '../../../../../mixins/secure_storage.dart';

class VehicleFormBloc with SecureStorage {
  void saveVehicleData(Map<String, String> vehicleInfo) {
    writeSecureData('brand', vehicleInfo['brand']);
    writeSecureData('model', vehicleInfo['model']);
    writeSecureData('year', vehicleInfo['year']);
  }
}
