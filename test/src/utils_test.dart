import 'dart:ui';

import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vuitv/src/core/country_codes.dart';
import 'package:vuitv/src/utils/colors.dart';
import 'package:vuitv/src/utils/json_converter.dart';
import 'package:vuitv/src/utils/logs.dart';
import 'package:vuitv/src/utils/text_input_formatter.dart';

void main() {
  group('HexColor', () {
    group('fromJson', () {
      test('creates color from RGB hex with hash', () {
        expect(HexColor.fromJson('#FF0000'), equals(const Color(0xFFFF0000)));
      });

      test('creates color from RGB hex without hash', () {
        expect(HexColor.fromJson('FF0000'), equals(const Color(0xFFFF0000)));
      });

      test('creates color from ARGB hex with hash', () {
        expect(HexColor.fromJson('#80FF0000'), equals(const Color(0x80FF0000)));
      });

      test('creates color from ARGB hex without hash', () {
        expect(HexColor.fromJson('80FF0000'), equals(const Color(0x80FF0000)));
      });

      test('returns null for invalid hex', () {
        expect(HexColor.fromJson('invalid'), isNull);
      });

      test('returns null for empty string', () {
        expect(HexColor.fromJson(''), isNull);
      });

      test('returns null for null input', () {
        expect(HexColor.fromJson(null), isNull);
      });
    });
  });

  group('jsonConverter', () {
    test('BoolConverter', () {
      const converter = BoolConverter();
      expect(converter.fromJson(1), isTrue);
      expect(converter.fromJson(0), isFalse);
      expect(converter.toJson(true), equals(1));
      expect(converter.toJson(false), equals(0));
    });

    test('ColorConverter', () {
      const converter = ColorConverter();
      expect(converter.toJson(null), isNull);
      expect(converter.fromJson(null), isNull);
      expect(converter.fromJson('#FF0000'), equals(const Color(0xFFFF0000)));
      expect(converter.fromJson('FF0000'), equals(const Color(0xFFFF0000)));
      expect(converter.fromJson('FFFF0000'), equals(const Color(0xFFFF0000)));
      expect(converter.toJson(const Color(0xFFFF0000)), equals('ffff0000'));
    });

    test('DateTimeConverter', () {
      const converter = DateTimeConverter();
      final date = DateTime.now();
      expect(converter.fromJson(date.toIso8601String()), equals(date));
      expect(converter.toJson(date), equals(date.toIso8601String()));
    });
  });

  group('printLog', () {
    test('prints log with data', () {
      printLog('test');
    });

    test('prints log with data and start time', () {
      printLog('test', DateTime.now());
    });
  });

  group('CurrencyInputFormatter', () {
    const oldValue = TextEditingValue.empty;
    group('us formats', () {
      test('currency formatter handles edge cases', () {
        CountryCodes.current = 'US';
        final formatter = CountryCurrencyInputFormatter.auto();

        // Test with empty string
        expect(
          formatter
              .formatEditUpdate(
                TextEditingValue.empty,
                TextEditingValue.empty,
              )
              .text,
          isEmpty,
        );

        // Test with only digits
        expect(
          formatter
              .formatEditUpdate(
                TextEditingValue.empty,
                const TextEditingValue(text: '1234'),
              )
              .text,
          equals(r'$12.34'),
        );

        // Test with partial input
        expect(
          formatter
              .formatEditUpdate(
                const TextEditingValue(text: '12'),
                const TextEditingValue(text: '123'),
              )
              .text,
          equals(r'$1.23'),
        );
      });

      test('formatter preserves appropriate selection', () {
        CountryCodes.current = 'US';
        final formatter = CountryCurrencyInputFormatter.auto();

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: '123'),
          const TextEditingValue(
            text: '1234',
            selection: TextSelection.collapsed(offset: 4),
          ),
        );

        // Check both text and selection positioning
        expect(result.text, equals(r'$12.34'));
        expect(result.selection.baseOffset, isNot(equals(-1)));
      });

      test('formatter with mocked country code', () {
        CountryCodes.current = 'US'; // Set known state
        final formatter = CountryCurrencyInputFormatter.auto();
        final result = formatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '1234.56'),
        );

        expect(result.text, equals(r'$1,234.56'));
      });
    });

    group('vn formats', () {
      test('vn formats dong with 0 decimal places', () {
        CountryCodes.current = 'VN';
        final formatter = CountryCurrencyInputFormatter.auto();
        const newValue = TextEditingValue(text: '1234');
        final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
        expect(formattedValue.text, equals('1,234₫'));
      });

      test('vn formats dong with 2 decimal places', () {
        CountryCodes.current = 'VN';
        final formatter = CountryCurrencyInputFormatter.auto();
        const newValue = TextEditingValue(text: '1234.56');
        final formattedValue = formatter.formatEditUpdate(oldValue, newValue);
        expect(formattedValue.text, equals('123,456₫'));
      });
    });
  });

  group('NumberDigitsInputFormatter', () {
    test('removes non-numeric characters', () {
      final formatter = NumberDigitsInputFormatter();
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: 'abc123def'),
        const TextEditingValue(text: 'abc123def'),
      );
      expect(result.text, equals('123'));
    });

    test('formats with thousand separators', () {
      final formatter = NumberDigitsInputFormatter();
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '1234567'),
        const TextEditingValue(text: '1234567'),
      );
      expect(result.text, equals('1,234,567'));
    });

    test('formats with thousand separators and decimal places', () {
      final formatter = NumberDigitsInputFormatter();
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '1234567.89'),
        const TextEditingValue(text: '1234567.89'),
      );
      expect(result.text, equals('123,456,789'));
    });

    test('handles empty string', () {
      final formatter = NumberDigitsInputFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue.empty,
      );
      expect(result.text, equals('0'));
    });
  });

  group('PhoneInputFormatter', () {
    CountryPhoneInputFormatter.setPhoneMask();
    test('formats US phone number correctly', () {
      CountryCodes.current = 'US';
      final formater = CountryPhoneInputFormatter();
      final formattedValue = formater.formatEditUpdate(
        const TextEditingValue(text: '1234567890'),
        const TextEditingValue(text: '1234567890'),
      );
      expect(formattedValue.text, equals('(123) 456-7890'));
      expect(formater.masked, equals('(123) 456-7890'));
      expect(formater.unmasked, equals('1234567890'));
      expect(formater.format('1234567890'), equals('(123) 456-7890'));
      expect(formater.format('123456'), equals('(123) 456'));
      expect(formater.format('123'), equals('(123'));
    });

    test('formats AU phone number with country code', () {
      CountryCodes.current = 'AU';
      final formater = CountryPhoneInputFormatter();
      expect(formater.format('0123456789', 'AU'), equals('0123 456 789'));
      expect(formater.format('123456', 'AU'), equals('1234 56'));
      expect(formater.format('123', 'AU'), equals('123'));
    });

    test('formats VN phone number correctly', () {
      CountryCodes.current = 'VN';
      final formater = CountryPhoneInputFormatter();
      expect(formater.format('1234567890', 'VN'), equals('1234 567 890'));
      expect(formater.format('123456', 'VN'), equals('1234 56'));
      expect(formater.format('123', 'VN'), equals('123'));
    });
  });

  group('HexColorInputFormatter', () {
    final formatter = HexColorInputFormatter();

    test('adds hash prefix and uppercase', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: 'ff00ff'),
      );
      expect(result.text, equals('#FF00FF'));
    });

    test('handles existing hash', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '#ff00ff'),
      );
      expect(result.text, equals('#FF00FF'));
    });

    test('handles empty string', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue.empty,
      );
      expect(result.text, equals('#'));
    });
  });

  group('TextCapitalizationFormatter', () {
    test('capitalizes words correctly', () {
      const formatter = TextCapitalizationFormatter.words();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: 'hello world test'),
      );
      expect(result.text, equals('Hello World Test'));
    });

    test('capitalizes sentences correctly', () {
      const formatter = TextCapitalizationFormatter.sentences();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: 'hello. world. test.'),
      );
      expect(result.text, equals('Hello. World. Test.'));
    });

    test('handles empty string', () {
      const formatter = TextCapitalizationFormatter.words();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue.empty,
      );
      expect(result.text, equals(''));
    });

    test('handles multiple spaces between words', () {
      const formatter = TextCapitalizationFormatter.words();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: 'hello   world'),
      );
      expect(result.text, equals('Hello   World'));
    });

    test('capitalizes words correctly with emoji', () {
      const formatter = TextCapitalizationFormatter.words();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '😀hello world test'),
      );
      expect(result.text, equals('😀hello World Test'));
    });

    test('capitalizes characters correctly', () {
      const formatter = TextCapitalizationFormatter.characters();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: 'hello world test'),
      );
      expect(result.text, equals('HELLO WORLD TEST'));
    });

    test('capitalizes characters correctly with emoji', () {
      const formatter = TextCapitalizationFormatter.characters();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '😀hello world test'),
      );
      expect(result.text, equals('😀HELLO WORLD TEST'));
    });

    test('capitalizes first letter of a single word', () {
      expect(TextCapitalizationFormatter.inCaps('hello'), equals('Hello'));
    });

    test('capitalizes first letter of each word in a sentence', () {
      expect(
        TextCapitalizationFormatter.inCaps('hello world'),
        equals('Hello world'),
      );
    });

    test('returns empty string when input is empty', () {
      expect(TextCapitalizationFormatter.inCaps(''), equals(''));
    });

    test('handles multiple spaces correctly', () {
      expect(
        TextCapitalizationFormatter.inCaps('  hello  world  '),
        equals('  Hello  world  '),
      );
    });

    test('does not change already capitalized first letter', () {
      expect(TextCapitalizationFormatter.inCaps('Hello'), equals('Hello'));
    });

    test('handles string with only spaces', () {
      expect(TextCapitalizationFormatter.inCaps('     '), equals('     '));
    });

    test('handles first emoji correctly', () {
      expect(TextCapitalizationFormatter.inCaps('😀Test'), equals('😀Test'));
      expect(TextCapitalizationFormatter.inCaps('😀😊'), equals('😀😊'));
    });

    test('handles first character for unicode string', () {
      expect(TextCapitalizationFormatter.inCaps('नमस्ते'), equals('नमस्ते'));
    });

    test('handles first character for ascii string', () {
      expect(TextCapitalizationFormatter.inCaps('Test'), equals('Test'));
    });
  });
}
