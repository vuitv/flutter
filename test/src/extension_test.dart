import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:vuitv/src/extension/colors.dart';
import 'package:vuitv/src/extension/currency.dart';
import 'package:vuitv/src/extension/json_serializer.dart';
import 'package:vuitv/src/extension/string.dart';

void main() {
  group('ColorExt', () {
    test('converts black color to hex', () {
      const color = Color(0xFF000000);
      expect(color.toJson(), equals('ff000000'));
    });

    test('converts white color to hex', () {
      const color = Color(0xFFFFFFFF);
      expect(color.toJson(), equals('ffffffff'));
    });

    test('converts transparent color to hex', () {
      const color = Color(0x00FFFFFF);
      expect(color.toJson(), equals('00ffffff'));
    });

    test('converts color with alpha to hex', () {
      const color = Color(0x80FF0000);
      expect(color.toJson(), equals('80ff0000'));
    });
  });

  group('currency', () {
    group('toCurrencyUS', () {
      test('formats whole number with added zeros', () {
        expect(1234.toCurrencyUS(), equals(r'$1,234.00'));
      });

      test('formats with one decimal place', () {
        expect(1234.5.toCurrencyUS(), equals(r'$1,234.50'));
      });

      test('formats with two decimal places explicitly', () {
        expect(1234.50.toCurrencyUS(), equals(r'$1,234.50'));
      });

      test('handles negative values', () {
        expect((-1234.56).toCurrencyUS(), equals(r'-$1,234.56'));
      });

      test('handles zero value', () {
        expect(0.toCurrencyUS(), equals(r'$0.00'));
      });

      test('handles rounding of more than two decimals', () {
        expect(12.345.toCurrencyUS(), equals(r'$12.35'));
      });

      group('with trailingZero: false', () {
        test('removes trailing zeros from whole numbers', () {
          expect(12.toCurrencyUS(trailingZero: false), equals(r'$12'));
          expect(1234.toCurrencyUS(trailingZero: false), equals(r'$1,234'));
          expect(123.00.toCurrencyUS(trailingZero: false), equals(r'$123'));
          expect(1234.00.toCurrencyUS(trailingZero: false), equals(r'$1,234'));
        });

        test('preserves significant decimals', () {
          expect(12.34.toCurrencyUS(trailingZero: false), equals(r'$12.34'));
          expect(123.4.toCurrencyUS(trailingZero: false), equals(r'$123.4'));
          expect(1234.50.toCurrencyUS(trailingZero: false), equals(r'$1,234.5'));
          expect(1234.56.toCurrencyUS(trailingZero: false), equals(r'$1,234.56'));
          expect(1234.560.toCurrencyUS(trailingZero: false), equals(r'$1,234.56'));
        });

        test('rounds tiny decimals correctly', () {
          expect(1234.0001.toCurrencyUS(trailingZero: false), equals(r'$1,234'));
        });

        test('handles negative values', () {
          expect((-1234.56).toCurrencyUS(trailingZero: false), equals(r'-$1,234.56'));
        });
      });
    });

    group('toCurrencyVN', () {
      test('formats with rounding', () {
        expect(1234.56.toCurrencyVN(), equals('1,235₫'));
      });

      test('formats whole number', () {
        expect(1234.toCurrencyVN(), equals('1,234₫'));
      });

      test('formats with decimal rounding', () {
        expect(1234.5.toCurrencyVN(), equals('1,235₫'));
      });

      test('handles negative values', () {
        expect((-1234.56).toCurrencyVN(), equals('-1,235₫'));
      });

      test('handles zero value', () {
        expect(0.toCurrencyVN(), equals('0₫'));
      });
    });

    group('toNumberFormat', () {
      test('formats with thousands separators and rounding', () {
        expect(1234567.89.toNumberFormat(), equals('1,234,568'));
      });

      test('formats whole numbers with separators', () {
        expect(1234567.toNumberFormat(), equals('1,234,567'));
      });

      test('rounds single decimal places', () {
        expect(1234567.5.toNumberFormat(), equals('1,234,568'));
      });
    });
  });

  group('jsonSerial', () {
    group('getValue', () {
      test('returns value when key exists and type matches', () {
        final map = {'key': 'value'};
        expect(map.getValue<String>('key'), equals('value'));
      });

      test('returns null when key does not exist', () {
        final map = {'other': 'value'};
        expect(map.getValue<String>('key'), isNull);
      });

      test('returns null when type does not match', () {
        final map = {'key': 123};
        expect(map.getValue<String>('key'), isNull);
      });
    });

    group('getInt', () {
      test('returns int value from numeric field', () {
        final map = {'key': 123};
        expect(map.getInt('key'), equals(123));
      });

      test('returns int value from string field', () {
        final map = {'key': '123'};
        expect(map.getInt('key'), equals(123));
      });

      test('returns null for invalid string', () {
        final map = {'key': 'abc'};
        expect(map.getInt('key'), isNull);
      });
    });

    group('getDouble', () {
      test('returns double value from numeric field', () {
        final map = {'key': 123.45};
        expect(map.getDouble('key'), equals(123.45));
      });

      test('returns double value from string field', () {
        final map = {'key': '123.45'};
        expect(map.getDouble('key'), equals(123.45));
      });

      test('returns null for invalid string', () {
        final map = {'key': 'abc'};
        expect(map.getDouble('key'), isNull);
      });
    });

    group('getDateTime', () {
      test('returns DateTime from ISO string', () {
        final map = {'key': '2024-03-14T15:30:00Z'};
        expect(
          map.getDateTime('key'),
          equals(DateTime.parse('2024-03-14T15:30:00Z')),
        );
      });

      test('returns null for invalid date string', () {
        final map = {'key': 'not-a-date'};
        expect(map.getDateTime('key'), isNull);
      });
    });

    group('tryGetObject', () {
      test('creates object from nested map', () {
        final map = {
          'key': {'name': 'test'},
        };
        expect(map.tryGetObject('key', (m) => m['name']), equals('test'));
      });

      test('returns null when nested value is not a map', () {
        final map = {'key': 'not-a-map'};
        expect(map.tryGetObject('key', (m) => m['name']), isNull);
      });
    });

    group('tryGetList', () {
      test('creates list of objects from array', () {
        final map = {
          'key': [
            {'id': 1},
            {'id': 2},
          ],
        };
        expect(map.tryGetList('key', (m) => m['id']), equals([1, 2]));
      });

      test('returns empty list when key does not exist', () {
        final map = <String, dynamic>{};
        expect(map.tryGetList('key', (m) => m['id']), isEmpty);
      });

      test('skips invalid elements in list', () {
        final map = {
          'key': [
            {'id': 1},
            'invalid',
            {'id': 2},
          ],
        };
        expect(map.tryGetList('key', (m) => m['id']), equals([1, 2]));
      });
    });
  });

  group('StringExt', () {
    group('isUrl', () {
      test('valid http url returns true', () {
        expect('http://example.com'.isUrl, isTrue);
      });

      test('valid https url returns true', () {
        expect('https://example.com'.isUrl, isTrue);
      });

      test('valid url with subdomain returns true', () {
        expect('https://sub.example.com'.isUrl, isTrue);
      });

      test('valid url with path returns true', () {
        expect('https://example.com/path'.isUrl, isTrue);
      });

      test('valid url with query parameters returns true', () {
        expect('https://example.com?param=value'.isUrl, isTrue);
      });

      test('ftp url returns false', () {
        expect('ftp://example.com'.isUrl, isFalse);
      });

      test('plain text returns false', () {
        expect('not-a-url'.isUrl, isFalse);
      });

      test('empty string returns false', () {
        expect(''.isUrl, isFalse);
      });

      test('malformed url returns false', () {
        expect('http:/malformed'.isUrl, isFalse);
      });

      test('url with spaces returns false', () {
        expect('http://example. com'.isUrl, isFalse);
      });

      test('url with special characters returns true', () {
        expect('https://example.com/path?param=value&other=val#anchor'.isUrl, isTrue);
      });

      test('url with port number returns true', () {
        expect('https://example.com:8080'.isUrl, isTrue);
      });

      test('url with user info returns true', () {
        expect('https://user:pass@example.com'.isUrl, isTrue);
      });
    });
    group('toPhoneNumber()', () {
      test('formats phone number with country code', () {
        expect('1234567890'.toPhoneNumber('US'), equals('(123) 456 7890'));
      });

      test('formats phone number without country code', () {
        expect('1234567890'.toPhoneNumber(), equals('(123) 456 7890'));
      });

      test('returns empty string for invalid input', () {
        expect('invalid'.toPhoneNumber(), 'invalid');
      });
    });
    group('toRawPhoneNumber()', () {
      test('removes formatting from phone number', () {
        expect('(123) 456-7890'.toRawPhoneNumber(), equals('1234567890'));
      });

      test('handles empty string', () {
        expect(''.toRawPhoneNumber(), equals(''));
      });

      test('returns empty string for invalid input', () {
        expect('invalid'.toRawPhoneNumber(), '');
      });

      test('handles international format', () {
        expect('+1 (123) 456-7890'.toRawPhoneNumber(), equals('11234567890'));
      });

      test('handles phone number with spaces', () {
        expect('123 456 7890'.toRawPhoneNumber(), equals('1234567890'));
      });

      test('handles phone number with dashes', () {
        expect('123-456-7890'.toRawPhoneNumber(), equals('1234567890'));
      });
    });
  });
}
