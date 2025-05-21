import 'dart:ui';

import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vuitv/vuitv.dart';

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
        const TextEditingValue(text: '123456789'),
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
      final result = formater.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '0423456789'),
      );
      expect(result.text, equals('0423 456 789'));

      expect(formater.format('0423456789', 'AU'), equals('0423 456 789'));
      expect(formater.format('123456', 'AU'), equals('1234 56'));
      expect(formater.format('123', 'AU'), equals('123'));
      expect(formater.format('04', 'AU'), equals('04'));
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

  group('WordsTextInputFormatter', () {
    test('capitalizes words correctly', () {
      const formatter = WordsTextInputFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: 'hello world test'),
      );
      expect(result.text, equals('Hello World Test'));
    });

    test('handles empty string', () {
      const formatter = WordsTextInputFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue.empty,
      );
      expect(result.text, equals(''));
    });

    test('handles multiple spaces between words', () {
      const formatter = WordsTextInputFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: 'hello   world'),
      );
      expect(result.text, equals('Hello   World'));
    });

    test('capitalizes words correctly with emoji', () {
      const formatter = WordsTextInputFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '😀hello world test'),
      );
      expect(result.text, equals('😀Hello World Test'));
    });

    test('capitalizes words correctly with special characters', () {
      const formatter = WordsTextInputFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: 'hello! world? test.'),
      );
      expect(result.text, equals('Hello! World? Test.'));
    });

    test('capitalizes words correctly with special characters', () {
      const formatter = WordsTextInputFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: 'service name (test)'),
      );
      expect(result.text, equals('Service Name (Test)'));
    });

    test('handles string with only spaces', () {
      const formatter = WordsTextInputFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '  '),
      );
      expect(result.text, equals('  '));
    });
  });

  group('StringTrimmingFormatter', () {
    test('trims leading and trailing spaces', () {
      const formatter = StringTrimmingFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '   hello world   '),
      );
      expect(result.text, equals('hello world'));
    });

    test('trims leading and trailing spaces with multiple spaces', () {
      const formatter = StringTrimmingFormatter(trimBetween: true);
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '   hello   world   '),
      );
      expect(result.text, equals('hello world'));
    });

    test('trims leading and trailing spaces with emoji', () {
      const formatter = StringTrimmingFormatter(trimBetween: true);
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '   😀hello  world   '),
      );
      expect(result.text, equals('😀hello world'));
    });

    test('handles empty string', () {
      const formatter = StringTrimmingFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: ' '),
      );
      expect(result.text, equals(''));
    });

    test('handles string with only spaces', () {
      const formatter = StringTrimmingFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '     '),
      );
      expect(result.text, equals(''));
    });

    test('handles string with only spaces and emoji', () {
      const formatter = StringTrimmingFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '😀     '),
      );
      expect(result.text, equals('😀'));
    });
  });

  /// Test for formatters that are not covered above.
  group('InputFormatters', () {
    group('phone formatters', () {
      test('should contain 3 formatters', () {
        CountryCodes.current = 'US';
        expect(InputFormatters.phone.length, 3);
      });

      test('should allow valid phone characters', () {
        final formatters = InputFormatters.phone;

        const validInput = '1234567890';
        var formattedValue = const TextEditingValue(text: validInput);
        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, '(123) 456-7890');
      });

      test('should filter invalid phone characters', () {
        final formatters = InputFormatters.phone;

        const invalidInput = '123456';
        var formattedValue = const TextEditingValue(text: invalidInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, '(123) 456');
      });

      test('should limit phone input length to 10 characters digital', () {
        final formatters = InputFormatters.phone;

        const longInput = '12345678901234567890';
        var formattedValue = const TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            const TextEditingValue(text: '1234567890'),
            formattedValue,
          );
        }
        expect(formattedValue.text, '(123) 456-7890');
        expect(formattedValue.text.length, equals(14));
        final digitsOnly = formattedValue.text.toRawPhoneNumber();
        expect(digitsOnly.length, equals(10));
      });

      test('should limit phone input length to 14 characters with mask', () {
        final formatters = InputFormatters.phone;

        const longInput = '12345678901234567890';
        var formattedValue = const TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            const TextEditingValue(text: '1234567890'),
            formattedValue,
          );
        }
        expect(formattedValue.text, '(123) 456-7890');
        expect(formattedValue.text.length, equals(14));
      });
    });

    group('email formatters', () {
      test('should contain 2 formatters', () {
        expect(InputFormatters.email.length, 2);
      });

      test('should allow valid email characters', () {
        final formatters = InputFormatters.email;

        const validInput = 'user.name@example.com';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, validInput);
      });

      test('should filter invalid email characters', () {
        final formatters = InputFormatters.email;

        const invalidInput = 'user*name@example.com';
        var formattedValue = const TextEditingValue(text: invalidInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, 'username@example.com');
      });

      test('should limit email input length to 50 characters', () {
        final formatters = InputFormatters.email;

        const longInput = 'verylongusernamethatshouldbetruncated@veryverylongdomain.com';
        var formattedValue = const TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, lessThanOrEqualTo(50));
      });
    });

    group('nameWords formatters', () {
      test('should contain 3 formatters', () {
        expect(InputFormatters.nameWords.length, 3);
      });

      test('should allow valid name characters', () {
        final formatters = InputFormatters.nameWords;

        const validInput = 'John Doe';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, validInput);
      });

      test('capitalizes each word correctly', () {
        final formatters = InputFormatters.nameWords;

        const input = 'john doe';
        var formattedValue = const TextEditingValue(text: input);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, 'John Doe');
      });

      test('should limit name input length to 80 characters', () {
        final formatters = InputFormatters.nameWords;

        final longInput = 'a' * 100;
        var formattedValue = TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, lessThanOrEqualTo(80));
      });
    });

    group('price formatters', () {
      test('should contain 3 formatters', () {
        expect(InputFormatters.price.length, 3);
      });

      test('should allow valid price characters', () {
        final formatters = InputFormatters.price;

        const validInput = '1,234.56';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.contains(RegExp('[1234.,]+')), isTrue);
      });

      test('should filter invalid price characters', () {
        final formatters = InputFormatters.price;

        const invalidInput = '1234.56abc';
        var formattedValue = const TextEditingValue(text: invalidInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.contains(RegExp(r'[^0-9.,$₫]')), isFalse);
        expect(formattedValue.text, r'$1,234.56');
      });
    });

    group('serviceName formatters', () {
      test('should filter invalid service name characters', () {
        final formatters = InputFormatters.serviceName;

        const invalidInput = 'Service @ Name #1';
        var formattedValue = const TextEditingValue(text: invalidInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, 'Service Name 1');
      });

      test('should allow Vietnamese characters in service names', () {
        final formatters = InputFormatters.serviceName;

        const validInput = 'Dịch vụ số 1';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, 'Dịch Vụ Số 1');
      });

      test('should limit service name length to 80 characters', () {
        final formatters = InputFormatters.serviceName;

        final longInput = 'a' * 100;
        var formattedValue = TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, lessThanOrEqualTo(80));
      });

      test('should allow special characters in service names', () {
        final formatters = InputFormatters.serviceName;

        const validInput = 'Service Name (test)';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, 'Service Name (Test)');
      });

      test('should allow special characters in service names with emoji', () {
        final formatters = InputFormatters.serviceName;

        const validInput = 'Service Name (test) 😀';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, 'Service Name (Test)');
      });

      test('should allow special characters in service names with emoji and numbers', () {
        final formatters = InputFormatters.serviceName;

        const validInput = 'Service Name (test) 123 😀';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, 'Service Name (Test) 123');
      });

      test('should allow special characters in service names with emoji and numbers and symbols', () {
        final formatters = InputFormatters.serviceName;

        const validInput = 'Service Name (test) 123 😀 !@#';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, 'Service Name (Test) 123');
      });

      test('should allow characters in service names with  space', () {
        final formatters = InputFormatters.serviceName;

        const validInput = 'Service Name ';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            const TextEditingValue(text: 'Service Name'),
            formattedValue,
          );
        }

        expect(formattedValue.text, validInput);
      });

      test('should allow characters in service names with  space and emoji', () {
        final formatters = InputFormatters.serviceName;

        const validInput = 'Service Name 😀 ';
        const result = 'Service Name';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            const TextEditingValue(text: result),
            formattedValue,
          );
        }

        expect(formattedValue.text, result);
      });
    });

    group('password formatters', () {
      test('should contain 3 formatters', () {
        expect(InputFormatters.password.length, 3);
      });

      test('should deny spaces in passwords', () {
        final formatters = InputFormatters.password;

        const inputWithSpaces = 'password with spaces';
        var formattedValue = const TextEditingValue(text: inputWithSpaces);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, 'passwordwithspaces');
      });

      test('should limit password length to 50 characters', () {
        final formatters = InputFormatters.password;

        final longPassword = 'a' * 60;
        var formattedValue = TextEditingValue(text: longPassword);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, 50);
      });
    });

    group('name formatters', () {
      test('should contain 2 formatters', () {
        expect(InputFormatters.name.length, 2);
      });

      test('should allow valid name characters', () {
        final formatters = InputFormatters.name;

        const validInput = 'John Doe';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, validInput);
      });

      test('should limit name input length to 80 characters', () {
        final formatters = InputFormatters.name;

        final longInput = 'a' * 100;
        var formattedValue = TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, lessThanOrEqualTo(80));
      });
    });

    group('quantity formatters', () {
      test('should contain 2 formatters', () {
        expect(InputFormatters.quantity.length, 2);
      });

      test('should allow valid quantity characters', () {
        final formatters = InputFormatters.quantity;

        const validInput = '123456';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, validInput);
      });

      test('should filter invalid quantity characters', () {
        final formatters = InputFormatters.quantity;

        const invalidInput = '123abc';
        var formattedValue = const TextEditingValue(text: invalidInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, '123');
      });

      test('should limit quantity input length to 10 characters', () {
        final formatters = InputFormatters.quantity;

        const longInput = '12345678901234567890';
        var formattedValue = const TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, lessThanOrEqualTo(10));
      });
    });

    group('duration formatters', () {
      test('should contain 2 formatters', () {
        expect(InputFormatters.duration.length, 2);
      });

      test('should allow valid duration characters', () {
        final formatters = InputFormatters.duration;

        const validInput = '123456';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, validInput);
      });

      test('should filter invalid duration characters', () {
        final formatters = InputFormatters.duration;

        const invalidInput = '123abc';
        var formattedValue = const TextEditingValue(text: invalidInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, '123');
      });

      test('should limit duration input length to 6 characters', () {
        final formatters = InputFormatters.duration;

        const longInput = '12345678901234567890';
        var formattedValue = const TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, lessThanOrEqualTo(6));
      });
    });

    group('address formatters', () {
      test('should contain 2 formatters', () {
        expect(InputFormatters.address.length, 2);
      });

      test('should allow valid address characters', () {
        final formatters = InputFormatters.address;

        const validInput = '123 Main St.';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, validInput);
      });

      test('should limit address input length to 500 characters', () {
        final formatters = InputFormatters.address;

        final longInput = 'a' * 600;
        var formattedValue = TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, lessThanOrEqualTo(500));
      });
    });

    group('description formatters', () {
      test('should contain 1 formatter', () {
        expect(InputFormatters.description.length, 1);
      });

      test('should allow valid description characters', () {
        final formatters = InputFormatters.description;

        const validInput = 'This is a description.';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, validInput);
      });

      test('should limit description input length to 2000 characters', () {
        final formatters = InputFormatters.description;

        final longInput = 'a' * 2500;
        var formattedValue = TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, lessThanOrEqualTo(2000));
      });
    });

    group('percent formatters', () {
      test('should contain 2 formatters', () {
        expect(InputFormatters.percent.length, 2);
      });

      test('should allow valid percent characters', () {
        final formatters = InputFormatters.percent;

        const validInput = '12.34%';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, '12.34');
      });

      test('should filter invalid percent characters', () {
        final formatters = InputFormatters.percent;

        const invalidInput = '12.34abc%';
        var formattedValue = const TextEditingValue(text: invalidInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, '12.34');
      });

      test('should limit percent input length to 6 characters', () {
        final formatters = InputFormatters.percent;

        const longInput = '12345678901234567890';
        var formattedValue = const TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, lessThanOrEqualTo(6));
      });
    });

    group('giftCode formatters', () {
      test('should contain 3 formatters', () {
        expect(InputFormatters.giftCode.length, 3);
      });

      test('should allow valid gift code characters', () {
        final formatters = InputFormatters.giftCode;

        const validInput = 'GIFT123';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, validInput);
      });

      test('should filter invalid gift code characters', () {
        final formatters = InputFormatters.giftCode;

        const invalidInput = 'GIFT 123';
        var formattedValue = const TextEditingValue(text: invalidInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, 'GIFT123');
      });

      test('should limit gift code input length to 50 characters', () {
        final formatters = InputFormatters.giftCode;

        final longInput = 'a' * 60;
        var formattedValue = TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, lessThanOrEqualTo(50));
      });
    });

    group('passcode formatters', () {
      test('should contain 2 formatters', () {
        expect(InputFormatters.passcode.length, 2);
      });

      test('should allow valid passcode characters', () {
        final formatters = InputFormatters.passcode;

        const validInput = '12345';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, validInput);
      });

      test('should filter invalid passcode characters', () {
        final formatters = InputFormatters.passcode;

        const invalidInput = '1234abc';
        var formattedValue = const TextEditingValue(text: invalidInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, '1234');
      });

      test('should limit passcode input length to 5 characters', () {
        final formatters = InputFormatters.passcode;

        const longInput = '12345678901234567890';
        var formattedValue = const TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, lessThanOrEqualTo(5));
      });
    });

    group('cardNote formatters', () {
      test('should contain 2 formatters', () {
        expect(InputFormatters.cardNote.length, 2);
      });

      test('should allow valid card note characters', () {
        final formatters = InputFormatters.cardNote;

        const validInput = 'This is a card note.';
        var formattedValue = const TextEditingValue(text: validInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, validInput);
      });

      test('should filter invalid card note characters', () {
        final formatters = InputFormatters.cardNote;

        const invalidInput = 'This is a card note';
        var formattedValue = const TextEditingValue(text: invalidInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text, 'This is a card note');
      });

      test('should limit card note input length to 125 characters', () {
        final formatters = InputFormatters.cardNote;

        final longInput = 'a' * 150;
        var formattedValue = TextEditingValue(text: longInput);

        for (final formatter in formatters) {
          formattedValue = formatter.formatEditUpdate(
            TextEditingValue.empty,
            formattedValue,
          );
        }

        expect(formattedValue.text.length, lessThanOrEqualTo(125));
      });
    });
  });
}
