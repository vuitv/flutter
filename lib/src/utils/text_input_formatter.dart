import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// A utility class for formatting currency input in different locales.
class CurrencyInputFormatter {
  /// Creates a US currency formatter with dollar symbol and 2 decimal places.
  ///
  /// Returns a [CurrencyTextInputFormatter] configured for US dollars ($)
  /// with English locale and 2 decimal digits.
  static CurrencyTextInputFormatter us() {
    return CurrencyTextInputFormatter.currency(
      locale: 'en',
      symbol: r'$',
      decimalDigits: 2,
    );
  }

  /// Creates a Vietnamese currency formatter with dong symbol and
  /// no decimal places.
  ///
  /// Returns a [CurrencyTextInputFormatter] configured for Vietnamese dong (₫)
  /// with custom pattern and no decimal digits.
  static CurrencyTextInputFormatter vn() {
    return CurrencyTextInputFormatter.currency(
      symbol: '₫',
      decimalDigits: 0,
      customPattern: '###,###₫',
    );
  }
}

/// A [TextInputFormatter] that formats numeric input with thousands separators.
///
/// Strips all non-numeric characters and adds thousands separators.
/// Does not allow decimal places.
class NumberDigitsInputFormatter extends TextInputFormatter {
  /// Creates a new [NumberDigitsInputFormatter].
  NumberDigitsInputFormatter();

  /// The number format used for formatting the input.
  ///
  /// Uses a custom pattern with thousands separators and no decimal places.
  NumberFormat get format {
    return NumberFormat.currency(
      symbol: '',
      decimalDigits: 0,
      customPattern: '###,###',
    );
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final numericValue = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    final text = format.format(int.tryParse(numericValue) ?? 0);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// A [TextInputFormatter] that formats phone numbers according
/// to locale patterns.
///
/// Supports US format: (XXX) XXX-XXXX
/// and Vietnamese format: XXX XXX XXXX
class PhoneInputFormatter extends TextInputFormatter {
  /// Creates a new [PhoneInputFormatter] with optional locale.
  ///
  /// If no locale is provided, US format will be used.
  PhoneInputFormatter([this.locale]);

  /// Formats a phone number string according to Vietnamese pattern.
  static String _vnFormat(String text) {
    var s = text;
    s = s.replaceAll(' ', '');
    if (s.length <= 3) {
      s = s.replaceAllMapped(
        RegExp(r'(\d{1,3})'),
        (m) => '${m[1]}',
      );
    } else if (s.length <= 6) {
      s = s.replaceAllMapped(
        RegExp(r'(\d{3})(\d{1,3})'),
        (m) => '${m[1]} ${m[2]}',
      );
    } else {
      s = s.replaceAllMapped(
        RegExp(r'(\d{3})(\d{3})(\d{1,4})'),
        (m) => '${m[1]} ${m[2]} ${m[3]}',
      );
    }
    return s;
  }

  /// Formats a phone number string according to US pattern.
  static String _usFormat(String text) {
    var s = text;
    s = s.replaceAll(' ', '');
    s = s.replaceAll('(', '');
    s = s.replaceAll(')', '');
    s = s.replaceAll('-', '');
    if (s.length <= 3) {
      s = s.replaceAllMapped(
        RegExp(r'(\d{1,3})'),
        (m) => '(${m[1]}',
      );
    } else if (s.length <= 6) {
      s = s.replaceAllMapped(
        RegExp(r'(\d{3})(\d{1,3})'),
        (m) => '(${m[1]}) ${m[2]}',
      );
    } else {
      s = s.replaceAllMapped(
        RegExp(r'(\d{3})(\d{3})(\d{1,4})'),
        (m) => '(${m[1]}) ${m[2]}-${m[3]}',
      );
    }
    return s;
  }

  /// Formats a phone number string according to the specified locale.
  ///
  /// Uses Vietnamese format for 'vi' locale, US format otherwise.
  static String format(String text, [Locale? locale]) {
    switch (locale?.languageCode) {
      case 'vi':
        return _vnFormat(text);
    }
    return _usFormat(text);
  }

  /// The locale used to determine the formatting pattern.
  final Locale? locale;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final s = format(newValue.text, locale);
    return TextEditingValue(
      text: s,
      selection: TextSelection.collapsed(offset: s.length),
    );
  }
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
