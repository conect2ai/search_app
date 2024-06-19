import 'dart:convert';
import 'dart:io';

import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

import '../../../core/entities/auth_user.dart';
import 'vehicle_info_repository.dart';

class VehicleInfoRepositoryImpl implements VehicleInfoRepository {
  final _apiBaseUrl = FlutterConfig.get('API_SEARCH_URL');
  final _vehicleInfoEndpoint = FlutterConfig.get('API_CARS_ENDPOINT');
  final _user = AuthUser();

  @override
  Future<Map<String, dynamic>> getVehicleInfo() async {
    final apiUri = Uri.http(_apiBaseUrl, _vehicleInfoEndpoint);

    final response = await http.get(apiUri, headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_user.token}',
    }).timeout(
      const Duration(seconds: 120),
      onTimeout: () {
        throw Exception("Failed to communicate with server");
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['message'];
    } else {
      throw const HttpException('Failed to retrieve cars data. Try again.');
    }
  }
}
