import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerService {
  Stream<AccelerometerEvent> get accelerometerStream => accelerometerEvents;
  
  bool isShaking(AccelerometerEvent event) {
    const double shakeThreshold = 10.0;
    return event.x.abs() > shakeThreshold ||
           event.y.abs() > shakeThreshold ||
           event.z.abs() > shakeThreshold;
  }

  String getOrientation(AccelerometerEvent event) {
    if (event.x.abs() > event.y.abs() && event.x.abs() > event.z.abs()) {
      return event.x > 0 ? 'Landscape Right' : 'Landscape Left';
    } else if (event.y.abs() > event.x.abs() && event.y.abs() > event.z.abs()) {
      return event.y > 0 ? 'Portrait Up' : 'Portrait Down';
    } else {
      return 'Unknown';
    }
  }

  void startListening() {
    // Accelerometer events are automatically started when accessed
  }

  void dispose() {
    // No need to dispose as the stream is managed by the sensors_plus package
  }
} 