import 'dart:math';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:vuitv/src/core/country_codes.dart';

/// A utility class for formatting currency input in different locales.
abstract class CountryCurrencyInputFormatter {
  CountryCurrencyInputFormatter._();

  /// Creates a new [CountryCurrencyInputFormatter] with optional country code.
  ///
  /// If no country code is provided, the current locale will be used.
  ///
  static CurrencyTextInputFormatter auto({String? countryCode}) {
    final locale = (countryCode ?? CountryCodes.current).toUpperCase();
    return locale == 'VN' ? vn() : us();
  }

  /// Creates a new [CountryCurrencyInputFormatter] with the specified locale.
  static CurrencyTextInputFormatter us() => CurrencyTextInputFormatter.currency(
        locale: 'en',
        symbol: r'$',
        decimalDigits: 2,
      );

  /// Creates a new [CountryCurrencyInputFormatter] with the specified locale.
  static CurrencyTextInputFormatter vn() => CurrencyTextInputFormatter.currency(
        symbol: '₫',
        decimalDigits: 0,
        customPattern: '###,###₫',
      );
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
    bool shouldCorrectNumber = false,
  }) {
    return CountryPhoneInputFormatter._(
      allowEndlessPhone: allowEndlessPhone,
      defaultCountryCode: defaultCountryCode ?? CountryCodes.current,
      shouldCorrectNumber: shouldCorrectNumber,
    );
  }

  CountryPhoneInputFormatter._({
    super.defaultCountryCode,
    super.allowEndlessPhone,
    super.shouldCorrectNumber,
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

/// A [TextInputFormatter] that capitalizes the first letter of each word.
///
/// This formatter is useful for ensuring that user input is properly capitalized
/// when entering names, titles, or other text where capitalization is important.
///
/// It splits the input text into words and capitalizes the first letter of each word,
/// while keeping the rest of the letters in lowercase.
///
/// Example:
/// ```dart
/// final formatter = WordsTextInputFormatter();
/// final formattedText = formatter.formatEditUpdate(
///  oldValue: TextEditingValue(text: 'hello world'),
///  newValue: TextEditingValue(text: 'hello world'),
/// );
/// print(formattedText.text); // Output: 'Hello World'
/// ```
/// This formatter can be used in a [TextField] or [TextFormField] to ensure that
/// the user input is properly capitalized.
/// Example:
/// ```dart
///  final TextField(
///   inputFormatters: [WordsTextInputFormatter()],
///   onChanged: (value) {
///    print(value); // Output: 'Hello World'
///   },
///  );
class WordsTextInputFormatter extends TextInputFormatter {
  /// Creates a new [WordsTextInputFormatter].
  const WordsTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // First handle words in parentheses
    var text = newValue.text;

    // Find all parentheses content and capitalize words inside them
    final parenRegex = RegExp(r'\(([^)]+)\)');
    text = text.replaceAllMapped(parenRegex, (match) {
      final inside = match.group(1)!;
      // Apply word capitalization to each word inside parentheses
      final parts = inside.split(' ');
      for (var i = 0; i < parts.length; i++) {
        if (parts[i].isNotEmpty) {
          parts[i] = '${parts[i][0].toUpperCase()}${parts[i].substring(1)}';
        }
      }
      return '(${parts.join(' ')})';
    });

    // Then handle the rest with regular splitting
    final sentences = text.split(' ');
    for (var i = 0; i < sentences.length; i++) {
      if (sentences[i].contains('&')) {
        // Special handling for ampersand
        final parts = sentences[i].split('&');
        for (var j = 0; j < parts.length; j++) {
          parts[j] = inCaps(parts[j]);
        }
        sentences[i] = parts.join('&');
      } else {
        sentences[i] = inCaps(sentences[i]);
      }
    }

    return TextEditingValue(
      text: sentences.join(' '),
      selection: newValue.selection,
    );
  }

  /// Capitalizes the first non-space character in the given text.
  String inCaps(String text) {
    if (text.isEmpty) {
      return text;
    }
    var leadingSpaces = '';
    // Find the first letter (not space, not emoji, not special character)
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (char == ' ') {
        // Keep spaces as is
        leadingSpaces += char;
        continue;
      }

      // Check if this character has distinct uppercase and lowercase forms
      if (char.toUpperCase() != char.toLowerCase()) {
        // It's a letter - capitalize it and lowercase the rest
        return leadingSpaces + char.toUpperCase() + text.substring(i + 1).toLowerCase();
      } else {
        // It's a non-letter character (number, emoji, etc)
        leadingSpaces += char;
      }
    }

    // If no capitalizable letters found, return original text
    return text;
  }
}

/// A specialized text formatter that implements string trimming functionalities.
/// This formatter automatically removes leading and trailing whitespace as the user types.
/// It also adjusts the cursor position accordingly.
///
/// This formatter is useful for ensuring that user input is clean and free of unnecessary spaces.
/// For example, it can be used in a [TextField] or [TextFormField] to ensure that
/// the user input is properly trimmed.
/// Example:
/// ```dart
/// final TextField(
///  inputFormatters: [StringTrimmingFormatter()],
///  onChanged: (value) {
///   print(value); // Output: 'Hello World'
///  },
/// );
class StringTrimmingFormatter extends TextInputFormatter {
  /// Creates a new [StringTrimmingFormatter].
  const StringTrimmingFormatter({this.trimBetween = false});

  /// Whether to trim spaces between words.
  final bool trimBetween;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Skip trimming if text is being deleted
    if (oldValue.text.length > newValue.text.length) {
      return newValue;
    }

    final originalText = newValue.text;

    // First trim leading and trailing whitespace
    var trimmed = originalText.trim();

    // If trimBetween is enabled, replace multiple spaces with single space
    if (trimBetween) {
      trimmed = trimmed.replaceAll(RegExp(r'\s+'), ' ');
    }

    // If nothing changed after trimming, return original value
    if (trimmed == originalText) {
      return newValue;
    }

    // Calculate new cursor position more accurately
    // Safely handle null or invalid selection
    final selectionIndex = newValue.selection.isValid && newValue.selection.end >= 0
        ? min(newValue.selection.end, originalText.length)
        : originalText.length;
    final textBeforeCursor = originalText.substring(0, selectionIndex);

    // Apply same trimming logic to text before cursor
    var trimmedBeforeCursor = textBeforeCursor.trimLeft();
    final leadingSpacesRemoved = textBeforeCursor.length - trimmedBeforeCursor.length;

    if (trimBetween) {
      trimmedBeforeCursor = trimmedBeforeCursor.replaceAll(RegExp(r'\s+'), ' ');
    }

    // If cursor was in trailing space, place it at the end of trimmed text
    if (selectionIndex >= originalText.trimRight().length) {
      return TextEditingValue(
        text: trimmed,
        selection: TextSelection.collapsed(offset: trimmed.length),
      );
    }

    // Calculate new cursor position
    var newCursorPosition = selectionIndex - leadingSpacesRemoved;

    // Additional adjustment for multiple spaces between words
    if (trimBetween) {
      final pattern = RegExp(r'\s+');
      final matches = pattern.allMatches(textBeforeCursor).toList();
      for (final match in matches) {
        if (match.start < selectionIndex) {
          // Only count extra spaces (beyond 1) that were removed
          newCursorPosition -= max(0, match.end - match.start - 1);
        }
      }
    }

    // Ensure cursor position is valid
    newCursorPosition = max(0, min(trimmed.length, newCursorPosition));

    return TextEditingValue(
      text: trimmed,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}
