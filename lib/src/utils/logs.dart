import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

///Custom log
void printLog([dynamic data, DateTime? startTime]) {
  if (kDebugMode) {
    var time = '';

    String icon(int duration) {
      if (duration > 2000) return '⌛️Slow-';
      if (duration > 1000) return '⏰Medium-';
      return '⚡️Fast-';
    }

    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      final milliseconds = duration.inMilliseconds;
      time = '[${icon(milliseconds)}${milliseconds}ms]';
    }

    try {
      final now = DateFormat('h:mm:ss-ms').format(DateTime.now());
      debugPrint('ℹ️[${now}ms]$time ${data.toString()}');

      if (data.toString().contains('is not a subtype of type')) {
        throw Exception();
      }
    } catch (e, trace) {
      debugPrint('🔴 ${data.toString()}');
      debugPrint(trace.toString());
    }
  }
}
