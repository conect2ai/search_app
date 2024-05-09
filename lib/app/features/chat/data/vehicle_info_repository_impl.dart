import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'vehicle_info_repository.dart';

class VehicleInfoRepositoryImpl implements VehicleInfoRepository {
  final apiBaseUrl = dotenv.get('API_SEARCH_URL');
  final vehicleInfoEndpoint = dotenv.get('API_CARS_ENDPOINT');

  @override
  Future<Map<String, dynamic>> getVehicleInfo() async {
    final apiUri = Uri.http(apiBaseUrl, vehicleInfoEndpoint);

    final response = await http.get(apiUri).timeout(
      const Duration(seconds: 120),
      onTimeout: () {
        throw Exception("Failed to communicate with server");
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['message'];
    } else {
      final responseErrorJson = jsonDecode(response.body);
      throw HttpException(responseErrorJson['detail']['msg']);
    }
  }
}
