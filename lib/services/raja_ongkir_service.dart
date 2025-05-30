import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ongkir.dart';

class RajaOngkirService {
  static const String _baseUrl = 'https://api.rajaongkir.com/starter';
  static const String _apiKey = 'Dxfzp7HXaff1610eb06a2cf1VnTndYh4'; // Ganti dengan API key Anda

  Future<List<dynamic>> getProvinces() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/province'),
        headers: {
          'key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['rajaongkir']['results'];
      }
      throw Exception('Failed to load provinces');
    } catch (e) {
      print('Error getting provinces: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getCities(String provinceId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/city?province=$provinceId'),
        headers: {
          'key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['rajaongkir']['results'];
      }
      throw Exception('Failed to load cities');
    } catch (e) {
      print('Error getting cities: $e');
      rethrow;
    }
  }

  Future<OngkirResponse> getCost({
    required String origin,
    required String destination,
    required int weight,
    required String courier,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/cost'),
        headers: {
          'key': _apiKey,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'origin': origin,
          'destination': destination,
          'weight': weight.toString(),
          'courier': courier,
        },
      );

      if (response.statusCode == 200) {
        return OngkirResponse.fromJson(jsonDecode(response.body));
      }
      throw Exception('Failed to get shipping cost');
    } catch (e) {
      print('Error getting cost: $e');
      rethrow;
    }
  }
}
