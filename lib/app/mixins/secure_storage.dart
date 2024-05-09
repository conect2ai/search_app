import 'package:flutter_secure_storage/flutter_secure_storage.dart';

mixin SecureStorage {
  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  void writeSecureData(String key, String? value) async {
    await _flutterSecureStorage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) async {
    return await _flutterSecureStorage.read(key: key);
  }

  void deleteSecureData(String key) async {
    await _flutterSecureStorage.delete(key: key);
  }
}
