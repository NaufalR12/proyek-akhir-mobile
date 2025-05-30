import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency.dart';

class CurrencyService {
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';

  Future<CurrencyResponse> getExchangeRates(String baseCurrency) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$baseCurrency'),
      );

      if (response.statusCode == 200) {
        return CurrencyResponse.fromJson(jsonDecode(response.body));
      }
      throw Exception('Failed to load exchange rates');
    } catch (e) {
      print('Error getting exchange rates: $e');
      rethrow;
    }
  }

  double convertCurrency({
    required double amount,
    required double fromRate,
    required double toRate,
  }) {
    // Convert to base currency first, then to target currency
    final inBaseCurrency = amount / fromRate;
    return inBaseCurrency * toRate;
  }
}
