import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:vuitv/src/extension/colors.dart';
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
  });
}
