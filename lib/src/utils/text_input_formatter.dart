import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:vuitv/src/core/country_codes.dart';

/// A utility class for formatting currency input in different locales.
class CountryCurrencyInputFormatter extends TextInputFormatter {
  /// Creates a new [CountryCurrencyInputFormatter] with optional country code.
  ///
  /// If no country code is provided, the current locale will be used.
  ///
  CountryCurrencyInputFormatter({String? countryCode}) {
    final locale = countryCode ?? CountryCodes.current;
    switch (locale) {
      case 'US':
        _leadingSymbol = r'$';
        _decimalDigits = 2;
      case 'AU':
        _leadingSymbol = r'$';
        _decimalDigits = 2;
      case 'VN':
        _trailingSymbol = '₫';
        _decimalDigits = 0;
      default:
        _decimalDigits = 2;
    }
  }

  String _leadingSymbol = '';
  String _trailingSymbol = '';
  int _decimalDigits = 2;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters except decimal point
    final value = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    if (value.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Parse number and handle decimals based on locale
    double number;
    if (value.contains('.')) {
      final parts = value.split('.');
      if (_decimalDigits == 0) {
        // For VN: treat decimals as part of integer
        number = double.parse(parts[0] + parts[1]);
      } else {
        number = double.parse(value);
      }
    } else {
      number = double.parse(value);
    }

    // Format with appropriate pattern
    final formatter = NumberFormat.currency(
      symbol: _leadingSymbol,
      decimalDigits: _decimalDigits,
    );

    var formatted = formatter.format(number);

    // Add trailing symbol if needed
    if (_trailingSymbol.isNotEmpty) {
      formatted = formatted.trim() + _trailingSymbol;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// A [TextInputFormatter] that formats numeric input with thousands separators.
///
/// Strips all non-numeric characters and adds thousands separators.
/// Does not allow decimal places.
class NumberDigitsInputFormatter extends TextInputFormatter {
  /// Creates a new [NumberDigitsInputFormatter].
  NumberDigitsInputFormatter({
    this.decimalDigits = 0,
  });

  /// The number of decimal digits to allow in the input.
  final int decimalDigits;

  NumberFormat get _formater {
    return NumberFormat.currency(
      symbol: '',
      decimalDigits: decimalDigits,
      customPattern: '###,###',
    );
  }

  /// The number format used for formatting the input.
  ///
  /// Uses a custom pattern with thousands separators and no decimal places.
  String format(num value) {
    return _formater.format(value);
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final numericValue = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    final text = _formater.format(int.tryParse(numericValue) ?? 0);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// A [CountryPhoneInputFormatter] that formats phone numbers according
/// to locale patterns.
///
/// Supports US format: (XXX) XXX-XXXX
/// Australian format: XXXX XXX XXX
/// and Vietnamese format: XXXX XXX XXX
class CountryPhoneInputFormatter extends PhoneInputFormatter {
  /// Creates a new [CountryPhoneInputFormatter] with optional locale.
  ///
  /// If no locale is provided, US format will be used.
  factory CountryPhoneInputFormatter({
    bool allowEndlessPhone = true,
    String? defaultCountryCode,
  }) {
    return CountryPhoneInputFormatter._(
      allowEndlessPhone: allowEndlessPhone,
      defaultCountryCode: defaultCountryCode ?? CountryCodes.current,
    );
  }

  CountryPhoneInputFormatter._({
    super.defaultCountryCode,
    super.allowEndlessPhone,
  });

  /// Setup method to initialize phone masks for different countries.
  static void setPhoneMask() {
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'US',
      newMask: '+0 (000) 000-0000',
    );
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'AU',
      newMask: '+00 0000 000 000',
    );
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'VN',
      newMask: '+00 0000 000 000',
    );
  }

  /// Formats a phone number string according to the specified locale.
  ///
  /// Uses Vietnamese format for 'vi' locale, US format otherwise.
  String format(String text, [String? countryCode]) {
    return formatAsPhoneNumber(
          text,
          allowEndlessPhone: true,
          defaultCountryCode: countryCode ?? CountryCodes.current,
        ) ??
        '';
  }

  @override
  String get unmasked => toNumericString(
        masked,
        allowHyphen: false,
        allowAllZeroes: true,
      );
}

/// A [TextInputFormatter] that formats hex color input.
///
/// Ensures the input starts with '#' and converts to uppercase.
class HexColorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var s = newValue.text;
    s = s.replaceAll('#', '');
    s = '#$s'.toUpperCase();

    return TextEditingValue(
      text: s,
      selection: TextSelection.collapsed(offset: s.length),
    );
  }
}

/// A [TextInputFormatter] that converts text input to uppercase.
class UpperCaseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// A [TextInputFormatter] that applies text capitalization rules.
///
/// Supports capitalizing words, sentences, all characters, or none.
class TextCapitalizationFormatter extends TextInputFormatter {
  /// Creates a formatter with no capitalization.
  const TextCapitalizationFormatter() //
      : capitalization = TextCapitalization.none;

  /// Creates a formatter that capitalizes the first letter of each word.
  const TextCapitalizationFormatter.words() //
      : capitalization = TextCapitalization.words;

  /// Creates a formatter that capitalizes the first letter of each sentence.
  const TextCapitalizationFormatter.sentences() //
      : capitalization = TextCapitalization.sentences;

  /// Creates a formatter that capitalizes all characters.
  const TextCapitalizationFormatter.characters() //
      : capitalization = TextCapitalization.characters;

  /// The capitalization rule to apply.
  final TextCapitalization capitalization;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = '';

    switch (capitalization) {
      case TextCapitalization.words:
        text = newValue.text.split(' ').map(inCaps).join(' ');
      case TextCapitalization.sentences:
        final sentences = newValue.text.split('.');
        for (var i = 0; i < sentences.length; i++) {
          sentences[i] = inCaps(sentences[i]);
        }
        text = sentences.join('.');
      case TextCapitalization.characters:
        text = newValue.text.toUpperCase();
      case TextCapitalization.none:
        text = newValue.text;
    }
    return TextEditingValue(
      text: text,
      selection: newValue.selection,
    );
  }

  /// Capitalizes the first non-space character in the given text.
  static String inCaps(String text) {
    if (text.isEmpty) {
      return text;
    }
    var result = '';
    for (var i = 0; i < text.length; i++) {
      if (text[i] != ' ') {
        result += '${text[i].toUpperCase()}${text.substring(i + 1)}';
        break;
      } else {
        result += text[i];
      }
    }
    return result;
  }
}
