import 'package:intl/intl.dart';
import '../models/timezone.dart';

class TimezoneService {
  DateTime convertTime({
    required DateTime time,
    required Timezone fromTimezone,
    required Timezone toTimezone,
  }) {
    // Convert to UTC first
    final utcTime = time.subtract(Duration(hours: fromTimezone.offset));
    // Then convert to target timezone
    return utcTime.add(Duration(hours: toTimezone.offset));
  }

  String formatTime(DateTime time, String format) {
    return DateFormat(format).format(time);
  }

  String getTimeDifference(Timezone fromTimezone, Timezone toTimezone) {
    final difference = toTimezone.offset - fromTimezone.offset;
    final sign = difference >= 0 ? '+' : '';
    return '$sign$difference jam';
  }
}
