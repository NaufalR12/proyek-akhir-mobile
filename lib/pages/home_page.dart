import 'package:flutter/material.dart';
import '../api/rajaongkir_api.dart';
import '../models/province.dart';
import '../models/city.dart';
import '../models/cost_result.dart';
import '../widgets/dropdown_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Province> provinces = [];
  List<City> citiesFrom = [];
  List<City> citiesTo = [];

  Province? selectedProvinceFrom;
  City? selectedCityFrom;
  Province? selectedProvinceTo;
  City? selectedCityTo;

  String? selectedCourier;
  int weight = 1000;

  List<CostResult> costs = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    try {
      provinces = await fetchProvinces();
      setState(() {});
    } catch (e) {
      error = e.toString();
      setState(() {});
    }
  }

  Future<void> _loadCitiesFrom(Province province) async {
    try {
      citiesFrom = await fetchCities(province.provinceId);
      selectedCityFrom = null;
      setState(() {});
    } catch (e) {
      error = e.toString();
      setState(() {});
    }
  }

  Future<void> _loadCitiesTo(Province province) async {
    try {
      citiesTo = await fetchCities(province.provinceId);
      selectedCityTo = null;
      setState(() {});
    } catch (e) {
      error = e.toString();
      setState(() {});
    }
  }

  Future<void> _checkCost() async {
    if (selectedCityFrom == null || selectedCityTo == null || selectedCourier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih asal, tujuan, dan kurir terlebih dahulu')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      costs = [];
      error = null;
    });

    try {
      costs = await getCost(
        selectedCityFrom!.cityId,
        selectedCityTo!.cityId,
        weight,
        selectedCourier!,
      );
    } catch (e) {
      error = e.toString();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cek Ongkir')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
              DropdownWidget<Province>(
                label: 'Provinsi Asal',
                value: selectedProvinceFrom,
                items: provinces,
                itemLabel: (p) => p.province,
                onChanged: (p) {
                  if (p != null) {
                    selectedProvinceFrom = p;
                    citiesFrom = [];
                    selectedCityFrom = null;
                    _loadCitiesFrom(p);
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownWidget<City>(
                label: 'Kota/Kabupaten Asal',
                value: selectedCityFrom,
                items: citiesFrom,
                itemLabel: (c) => c.fullName,
                onChanged: (c) {
                  selectedCityFrom = c;
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              DropdownWidget<Province>(
                label: 'Provinsi Tujuan',
                value: selectedProvinceTo,
                items: provinces,
                itemLabel: (p) => p.province,
                onChanged: (p) {
                  if (p != null) {
                    selectedProvinceTo = p;
                    citiesTo = [];
                    selectedCityTo = null;
                    _loadCitiesTo(p);
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownWidget<City>(
                label: 'Kota/Kabupaten Tujuan',
                value: selectedCityTo,
                items: citiesTo,
                itemLabel: (c) => c.fullName,
                onChanged: (c) {
                  selectedCityTo = c;
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              DropdownWidget<String>(
                label: 'Kurir',
                value: selectedCourier,
                items: const ['jne', 'pos', 'tiki'],
                itemLabel: (c) => c.toUpperCase(),
                onChanged: (c) {
                  selectedCourier = c;
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: weight.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Berat (gram)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  final w = int.tryParse(val);
                  if (w != null && w > 0) {
                    weight = w;
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _checkCost,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Cek Ongkir'),
              ),
              const SizedBox(height: 24),
              costs.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: costs
                          .map(
                            (cost) => Card(
                              child: ListTile(
                                title: Text(cost.service),
                                subtitle: Text(cost.description),
                                trailing: Text('Rp ${cost.value}'),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
