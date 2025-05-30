import 'package:flutter/material.dart';
import '../models/timezone.dart';
import '../services/timezone_service.dart';

class KonversiWaktuScreen extends StatefulWidget {
  const KonversiWaktuScreen({Key? key}) : super(key: key);

  @override
  _KonversiWaktuScreenState createState() => _KonversiWaktuScreenState();
}

class _KonversiWaktuScreenState extends State<KonversiWaktuScreen> {
  final _formKey = GlobalKey<FormState>();
  final _timezoneService = TimezoneService();

  Timezone? _fromTimezone;
  Timezone? _toTimezone;
  DateTime _selectedTime = DateTime.now();
  DateTime? _convertedTime;

  final List<Timezone> _timezones = Timezone.getTimezones();

  @override
  void initState() {
    super.initState();
    _fromTimezone = _timezones.firstWhere((t) => t.code == 'WIB');
    _toTimezone = _timezones.firstWhere((t) => t.code == 'GMT');
    _convertTime();
  }

  void _convertTime() {
    if (_fromTimezone != null && _toTimezone != null) {
      setState(() {
        _convertedTime = _timezoneService.convertTime(
          time: _selectedTime,
          fromTimezone: _fromTimezone!,
          toTimezone: _toTimezone!,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = DateTime(
          _selectedTime.year,
          _selectedTime.month,
          _selectedTime.day,
          picked.hour,
          picked.minute,
        );
      });
      _convertTime();
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
              // Time Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Waktu Saat Ini:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _timezoneService.formatTime(_selectedTime, 'HH:mm'),
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _selectTime(context),
                        icon: const Icon(Icons.access_time),
                        label: const Text('Pilih Waktu'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // From Timezone
              DropdownButtonFormField<Timezone>(
                value: _fromTimezone,
                decoration: const InputDecoration(
                  labelText: 'Dari Zona Waktu',
                  border: OutlineInputBorder(),
                ),
                items: _timezones.map((timezone) {
                  return DropdownMenuItem(
                    value: timezone,
                    child: Text('${timezone.name} (${timezone.code})'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _fromTimezone = value;
                    });
                    _convertTime();
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih zona waktu asal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // To Timezone
              DropdownButtonFormField<Timezone>(
                value: _toTimezone,
                decoration: const InputDecoration(
                  labelText: 'Ke Zona Waktu',
                  border: OutlineInputBorder(),
                ),
                items: _timezones.map((timezone) {
                  return DropdownMenuItem(
                    value: timezone,
                    child: Text('${timezone.name} (${timezone.code})'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _toTimezone = value;
                    });
                    _convertTime();
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih zona waktu tujuan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Result
              if (_convertedTime != null) ...[
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
                          '${_timezoneService.formatTime(_selectedTime, 'HH:mm')} ${_fromTimezone!.code} =',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_timezoneService.formatTime(_convertedTime!, 'HH:mm')} ${_toTimezone!.code}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Selisih waktu: ${_timezoneService.getTimeDifference(_fromTimezone!, _toTimezone!)}',
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
}
