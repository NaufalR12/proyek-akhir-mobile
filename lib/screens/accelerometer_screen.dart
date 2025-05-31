import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../services/accelerometer_service.dart';

class AccelerometerScreen extends StatefulWidget {
  const AccelerometerScreen({Key? key}) : super(key: key);

  @override
  _AccelerometerScreenState createState() => _AccelerometerScreenState();
}

class _AccelerometerScreenState extends State<AccelerometerScreen> {
  final _accelerometerService = AccelerometerService();
  AccelerometerEvent? _lastEvent;
  bool _isShaking = false;
  String _orientation = 'Unknown';

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _accelerometerService.startListening();
    _accelerometerService.accelerometerStream.listen((event) {
      setState(() {
        _lastEvent = event;
        _isShaking = _accelerometerService.isShaking(event);
        _orientation = _accelerometerService.getOrientation(event);
      });
    });
  }

  @override
  void dispose() {
    _accelerometerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Accelerometer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Shake
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Status Shake',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      _isShaking ? Icons.vibration : Icons.vibration_outlined,
                      size: 48,
                      color: _isShaking ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isShaking
                          ? 'Perangkat sedang digoyang!'
                          : 'Perangkat stabil',
                      style: TextStyle(
                        color: _isShaking ? Colors.red : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Orientasi
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Orientasi Perangkat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      _getOrientationIcon(),
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _orientation,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Data Sensor
            if (_lastEvent != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data Sensor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDataRow('X', _lastEvent!.x),
                      const SizedBox(height: 8),
                      _buildDataRow('Y', _lastEvent!.y),
                      const SizedBox(height: 8),
                      _buildDataRow('Z', _lastEvent!.z),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, double value) {
    return Row(
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: (value.abs() / 10).clamp(0.0, 1.0),
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              value > 0 ? Colors.green : Colors.red,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  IconData _getOrientationIcon() {
    switch (_orientation) {
      case 'Portrait Up':
        return Icons.screen_rotation;
      case 'Portrait Down':
        return Icons.screen_rotation_alt;
      case 'Landscape Left':
        return Icons.screen_rotation_alt;
      case 'Landscape Right':
        return Icons.screen_rotation;
      default:
        return Icons.screen_rotation;
    }
  }
}
