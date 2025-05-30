import 'package:flutter/material.dart';
import '../services/raja_ongkir_service.dart';
import '../models/ongkir.dart';

class CekOngkirScreen extends StatefulWidget {
  const CekOngkirScreen({Key? key}) : super(key: key);

  @override
  _CekOngkirScreenState createState() => _CekOngkirScreenState();
}

class _CekOngkirScreenState extends State<CekOngkirScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rajaOngkirService = RajaOngkirService();

  String? _selectedOriginProvince;
  String? _selectedOriginCity;
  String? _selectedDestinationProvince;
  String? _selectedDestinationCity;
  String? _selectedCourier;
  final _weightController = TextEditingController();

  List<dynamic> _provinces = [];
  List<dynamic> _originCities = [];
  List<dynamic> _destinationCities = [];
  List<String> _couriers = ['jne', 'pos', 'tiki'];

  OngkirResponse? _ongkirResult;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    try {
      final provinces = await _rajaOngkirService.getProvinces();
      setState(() {
        _provinces = provinces;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _loadCities(String provinceId, bool isOrigin) async {
    try {
      final cities = await _rajaOngkirService.getCities(provinceId);
      setState(() {
        if (isOrigin) {
          _originCities = cities;
        } else {
          _destinationCities = cities;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _checkOngkir() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final result = await _rajaOngkirService.getCost(
          origin: _selectedOriginCity!,
          destination: _selectedDestinationCity!,
          weight: int.parse(_weightController.text),
          courier: _selectedCourier!,
        );

        setState(() {
          _ongkirResult = result;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
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
              // Origin Province
              DropdownButtonFormField<String>(
                value: _selectedOriginProvince,
                decoration: const InputDecoration(
                  labelText: 'Provinsi Asal',
                  border: OutlineInputBorder(),
                ),
                items: _provinces.map((province) {
                  return DropdownMenuItem(
                    value: province['province_id'].toString(),
                    child: Text(province['province']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOriginProvince = value;
                    _selectedOriginCity = null;
                    _originCities = [];
                  });
                  if (value != null) {
                    _loadCities(value, true);
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih provinsi asal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Origin City
              DropdownButtonFormField<String>(
                value: _selectedOriginCity,
                decoration: const InputDecoration(
                  labelText: 'Kota/Kabupaten Asal',
                  border: OutlineInputBorder(),
                ),
                items: _originCities.map((city) {
                  return DropdownMenuItem(
                    value: city['city_id'].toString(),
                    child: Text(city['type'] + ' ' + city['city_name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOriginCity = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih kota asal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Destination Province
              DropdownButtonFormField<String>(
                value: _selectedDestinationProvince,
                decoration: const InputDecoration(
                  labelText: 'Provinsi Tujuan',
                  border: OutlineInputBorder(),
                ),
                items: _provinces.map((province) {
                  return DropdownMenuItem(
                    value: province['province_id'].toString(),
                    child: Text(province['province']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDestinationProvince = value;
                    _selectedDestinationCity = null;
                    _destinationCities = [];
                  });
                  if (value != null) {
                    _loadCities(value, false);
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih provinsi tujuan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Destination City
              DropdownButtonFormField<String>(
                value: _selectedDestinationCity,
                decoration: const InputDecoration(
                  labelText: 'Kota/Kabupaten Tujuan',
                  border: OutlineInputBorder(),
                ),
                items: _destinationCities.map((city) {
                  return DropdownMenuItem(
                    value: city['city_id'].toString(),
                    child: Text(city['type'] + ' ' + city['city_name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDestinationCity = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih kota tujuan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Weight
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Berat (gram)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan berat';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Courier
              DropdownButtonFormField<String>(
                value: _selectedCourier,
                decoration: const InputDecoration(
                  labelText: 'Kurir',
                  border: OutlineInputBorder(),
                ),
                items: _couriers.map((courier) {
                  return DropdownMenuItem(
                    value: courier,
                    child: Text(courier.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCourier = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih kurir';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Check Button
              ElevatedButton(
                onPressed: _isLoading ? null : _checkOngkir,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Cek Ongkir'),
              ),
              const SizedBox(height: 24),

              // Result
              if (_ongkirResult != null) ...[
                const Text(
                  'Hasil Cek Ongkir:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._ongkirResult!.rajaongkir.results.map((result) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kurir: ${result.name.toUpperCase()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...result.costs.map((cost) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Layanan: ${cost.service}'),
                                Text('Deskripsi: ${cost.description}'),
                                ...cost.cost.map((detail) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Biaya: Rp ${detail.value}'),
                                      Text('Estimasi: ${detail.etd} hari'),
                                      if (detail.note.isNotEmpty)
                                        Text('Catatan: ${detail.note}'),
                                    ],
                                  );
                                }),
                                const Divider(),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }
}
