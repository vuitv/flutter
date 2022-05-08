// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:vuitv/src/utils/logs.dart';

void main() {
  group('LoggingTest', () {
    test('log info', () {
      final result = printLog('log info');
      expect(true, true);
    });

    test('log Slow duration', () async {
      final startTime = DateTime.now();
      await Future<dynamic>.delayed(Duration(milliseconds: 2001));
      final result = printLog('log Slow', startTime);
      expect(true, true);
    });

    test('log Medium duration', () async {
      final startTime = DateTime.now();
      await Future<dynamic>.delayed(Duration(milliseconds: 1001));
      final result = printLog('log Medium', startTime);
      expect(true, true);
    });
  });
}
