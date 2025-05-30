import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable()
class CurrencyResponse {
  final Map<String, double> rates;
  final String base;
  final String date;

  CurrencyResponse({
    required this.rates,
    required this.base,
    required this.date,
  });

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrencyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyResponseToJson(this);
}

class Currency {
  final String code;
  final String name;
  final String symbol;

  Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });

  static List<Currency> getCurrencies() {
    return [
      Currency(
        code: 'IDR',
        name: 'Indonesian Rupiah',
        symbol: 'Rp',
      ),
      Currency(
        code: 'USD',
        name: 'US Dollar',
        symbol: '\$',
      ),
      Currency(
        code: 'EUR',
        name: 'Euro',
        symbol: '€',
      ),
      Currency(
        code: 'GBP',
        name: 'British Pound',
        symbol: '£',
      ),
      Currency(
        code: 'JPY',
        name: 'Japanese Yen',
        symbol: '¥',
      ),
    ];
  }
}
