import 'package:flutter/services.dart';
import 'package:vuitv/vuitv.dart';

/// A collection of commonly used `TextInputFormatter` lists for various input fields.
class InputFormatters {
  /// Formatters for phone number input.
  /// - `CountryPhoneInputFormatter`: Formats phone numbers based on country.
  /// - `FilteringTextInputFormatter.allow`: Allows only digits, spaces, parentheses, and hyphens.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 14 characters.
  static List<TextInputFormatter> phone = [
    CountryPhoneInputFormatter(),
    FilteringTextInputFormatter.allow(RegExp(r'[\d ()-]')),
    LengthLimitingTextInputFormatter(14),
  ];

  /// Formatters for email input.
  /// - `FilteringTextInputFormatter.allow`: Allows only alphanumeric characters, '@', '.', '_', and '-'.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 50 characters.
  static List<TextInputFormatter> email = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\d@._-]')),
    LengthLimitingTextInputFormatter(50),
  ];

  /// Formatters for name input.
  /// - `FilteringTextInputFormatter.singleLineFormatter`: Ensures single-line input.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 80 characters.
  static List<TextInputFormatter> name = [
    FilteringTextInputFormatter.singleLineFormatter,
    LengthLimitingTextInputFormatter(80),
  ];

  /// Formatters for service name input.
  /// - `FilteringTextInputFormatter.allow`: Allows alphanumeric characters and specific symbols.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 80 characters.
  /// - `WordsTextInputFormatter`: Custom formatter for word-based input.
  static List<TextInputFormatter> serviceName = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\d +*&().!,\-:;]')),
    LengthLimitingTextInputFormatter(80),
    const WordsTextInputFormatter(),
  ];

  /// Formatters for name input with word capitalization.
  /// - `FilteringTextInputFormatter.singleLineFormatter`: Ensures single-line input.
  /// - `TextCapitalizationFormatter.words`: Capitalizes each word.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 80 characters.
  static List<TextInputFormatter> nameWords = [
    FilteringTextInputFormatter.singleLineFormatter,
    const TextCapitalizationFormatter.words(),
    LengthLimitingTextInputFormatter(80),
  ];

  /// Formatters for price input.
  /// - `CountryCurrencyInputFormatter.auto`: Automatically formats currency based on country.
  /// - `FilteringTextInputFormatter.allow`: Allows digits, '.', '$', ',', and '₫'.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 10 characters.
  static List<TextInputFormatter> price = [
    CountryCurrencyInputFormatter.auto(),
    FilteringTextInputFormatter.allow(RegExp(r'[\d.$,₫]')),
    LengthLimitingTextInputFormatter(10),
  ];

  /// Formatters for quantity input.
  /// - `FilteringTextInputFormatter.digitsOnly`: Allows only digits.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 10 characters.
  static List<TextInputFormatter> quantity = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];

  /// Formatters for duration input.
  /// - `FilteringTextInputFormatter.digitsOnly`: Allows only digits.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 6 characters.
  static List<TextInputFormatter> duration = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(6),
  ];

  /// Formatters for address input.
  /// - `FilteringTextInputFormatter.singleLineFormatter`: Ensures single-line input.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 500 characters.
  static List<TextInputFormatter> address = [
    FilteringTextInputFormatter.singleLineFormatter,
    LengthLimitingTextInputFormatter(500),
  ];

  /// Formatters for description input.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 2000 characters.
  static List<TextInputFormatter> description = [
    LengthLimitingTextInputFormatter(2000),
  ];

  /// Formatters for percent input.
  /// - `FilteringTextInputFormatter.allow`: Allows only digits and '.'.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 6 characters.
  static List<TextInputFormatter> percent = [
    FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
    LengthLimitingTextInputFormatter(6),
  ];

  /// Formatters for gift code input.
  /// - `FilteringTextInputFormatter.singleLineFormatter`: Ensures single-line input.
  /// - `FilteringTextInputFormatter.deny`: Denies spaces.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 50 characters.
  static List<TextInputFormatter> giftCode = [
    FilteringTextInputFormatter.singleLineFormatter,
    FilteringTextInputFormatter.deny(RegExp('[ ]')),
    LengthLimitingTextInputFormatter(50),
  ];

  /// Formatters for passcode input.
  /// - `FilteringTextInputFormatter.digitsOnly`: Allows only digits.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 5 characters.
  static List<TextInputFormatter> passcode = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(5),
  ];

  /// Formatters for password input.
  /// - `FilteringTextInputFormatter.singleLineFormatter`: Ensures single-line input.
  /// - `FilteringTextInputFormatter.deny`: Denies spaces.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 50 characters.
  static List<TextInputFormatter> password = [
    FilteringTextInputFormatter.singleLineFormatter,
    FilteringTextInputFormatter.deny(RegExp('[ ]')),
    LengthLimitingTextInputFormatter(50),
  ];

  /// Formatters for card note input.
  /// - `FilteringTextInputFormatter.singleLineFormatter`: Ensures single-line input.
  /// - `LengthLimitingTextInputFormatter`: Limits the input length to 125 characters.
  static List<TextInputFormatter> cardNote = [
    FilteringTextInputFormatter.singleLineFormatter,
    LengthLimitingTextInputFormatter(125),
  ];
}
