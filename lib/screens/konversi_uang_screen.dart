import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/currency.dart';
import '../services/currency_service.dart';

class KonversiUangScreen extends StatefulWidget {
  const KonversiUangScreen({Key? key}) : super(key: key);

  @override
  _KonversiUangScreenState createState() => _KonversiUangScreenState();
}

class _KonversiUangScreenState extends State<KonversiUangScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currencyService = CurrencyService();
  final _amountController = TextEditingController();

  Currency? _fromCurrency;
  Currency? _toCurrency;
  CurrencyResponse? _exchangeRates;
  double? _convertedAmount;
  bool _isLoading = false;

  final List<Currency> _currencies = Currency.getCurrencies();

  @override
  void initState() {
    super.initState();
    _fromCurrency = _currencies.firstWhere((c) => c.code == 'IDR');
    _toCurrency = _currencies.firstWhere((c) => c.code == 'USD');
    _loadExchangeRates();
  }

  Future<void> _loadExchangeRates() async {
    try {
      setState(() => _isLoading = true);
      final rates =
          await _currencyService.getExchangeRates(_fromCurrency!.code);
      setState(() {
        _exchangeRates = rates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _convertCurrency() {
    if (_formKey.currentState!.validate() && _exchangeRates != null) {
      final amount = double.parse(_amountController.text);
      final fromRate = _exchangeRates!.rates[_fromCurrency!.code] ?? 1.0;
      final toRate = _exchangeRates!.rates[_toCurrency!.code] ?? 1.0;

      setState(() {
        _convertedAmount = _currencyService.convertCurrency(
          amount: amount,
          fromRate: fromRate,
          toRate: toRate,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Amount Input
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Jumlah',
                  border: const OutlineInputBorder(),
                  prefixText: _fromCurrency?.symbol,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // From Currency
              DropdownButtonFormField<Currency>(
                value: _fromCurrency,
                decoration: const InputDecoration(
                  labelText: 'Dari Mata Uang',
                  border: OutlineInputBorder(),
                ),
                items: _currencies.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text('${currency.code} - ${currency.name}'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _fromCurrency = value;
                      _convertedAmount = null;
                    });
                    _loadExchangeRates();
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih mata uang asal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // To Currency
              DropdownButtonFormField<Currency>(
                value: _toCurrency,
                decoration: const InputDecoration(
                  labelText: 'Ke Mata Uang',
                  border: OutlineInputBorder(),
                ),
                items: _currencies.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text('${currency.code} - ${currency.name}'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _toCurrency = value;
                      _convertedAmount = null;
                    });
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih mata uang tujuan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Convert Button
              ElevatedButton(
                onPressed: _isLoading ? null : _convertCurrency,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Konversi'),
              ),
              const SizedBox(height: 24),

              // Result
              if (_convertedAmount != null) ...[
                const Text(
                  'Hasil Konversi:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_amountController.text} ${_fromCurrency!.code} =',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_convertedAmount!.toStringAsFixed(2)} ${_toCurrency!.code}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kurs: 1 ${_fromCurrency!.code} = ${(_exchangeRates!.rates[_toCurrency!.code]! / _exchangeRates!.rates[_fromCurrency!.code]!).toStringAsFixed(4)} ${_toCurrency!.code}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
