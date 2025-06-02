import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/province.dart';
import '../models/city.dart';
import '../models/cost_result.dart';

const String apiKey = 'aff1002c5b65baf69b177eeb09f64a30'; // <-- Ganti API key kamu di sini
const String baseUrl = 'https://api.rajaongkir.com/starter';

Future<List<Province>> fetchProvinces() async {
  final response = await http.get(
    Uri.parse('$baseUrl/province'),
    headers: {'key': apiKey},
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load provinces');
  }

  final jsonBody = jsonDecode(response.body);
  final results = jsonBody['rajaongkir']?['results'];
  if (results != null && results is List) {
    return results.map((p) => Province.fromJson(p)).toList();
  }
  return [];
}

Future<List<City>> fetchCities(String provinceId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/city?province=$provinceId'),
    headers: {'key': apiKey},
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load cities');
  }

  final jsonBody = jsonDecode(response.body);
  final results = jsonBody['rajaongkir']?['results'];
  if (results != null && results is List) {
    return results.map((c) => City.fromJson(c)).toList();
  }
  return [];
}

Future<List<CostResult>> getCost(String origin, String destination, int weight, String courier) async {
  
  final response = await http.post(
    Uri.parse('$baseUrl/cost'),
    headers: {
      'key': apiKey,
      'content-type': 'application/x-www-form-urlencoded',
    },
    body: {
      'origin': origin,
      'destination': destination,
      'weight': weight.toString(),
      'courier': courier,
    },
  );

  if (response.statusCode != 200) {
    print('Response body (error): ${response.body}'); // << Tambahkan ini
    throw Exception('Failed to get cost');
  }

  final jsonBody = jsonDecode(response.body);
  print('Response body: $jsonBody'); // << Tambahkan untuk memastikan formatnya

  final results = jsonBody['rajaongkir']?['results'];
  if (results != null && results is List && results.isNotEmpty) {
    final costs = results[0]['costs'] as List?;
    if (costs != null) {
      return costs.map((e) => CostResult.fromJson(e)).toList();
    }
  }
  return [];
}
