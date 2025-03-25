import 'package:flutter/widgets.dart';
import 'package:vuitv/src/utils/text_input_formatter.dart';

/// Extension methods for String to provide utility functions for URL and
/// string validation.
extension StringExt on String {
  /// Checks if the string is a valid URL by attempting pattern matching.
  ///
  /// Returns true if the string matches a basic URL pattern including http/https,
  /// false otherwise.
  ///
  /// Example:
  /// ```dart
  /// 'https://example.com'.isUrl         // Returns true
  /// 'http://sub.example.com'.isUrl      // Returns true
  /// 'not-a-url'.isUrl                   // Returns false
  /// 'ftp://example.com'.isUrl           // Returns false
  /// ```
  bool get isUrl {
    if (contains(' ')) return false;

    try {
      final uri = Uri.parse(this);
      if (!uri.hasAuthority || !uri.host.contains('.')) return false;
      return uri.scheme == 'http' || uri.scheme == 'https';
    } on FormatException {
      return false;
    }
  }

  /// Converts the string to a phone number format.
  ///
  /// Takes an optional country code parameter to format according to specific country rules.
  /// If no country code is provided, it will attempt to auto-detect the appropriate format.
  ///
  /// Example:
  /// ```dart
  /// '1234567890'.toPhoneNumber()          // May format to something like (123) 456-7890
  /// '1234567890'.toPhoneNumber('US')      // Formats using US rules: (123) 456-7890
  /// ```
  String toPhoneNumber([String? countryCode]) {
    return CountryPhoneInputFormatter().format(
      this,
      countryCode,
    );
  }

  /// Converts the string to a raw phone number format.
  /// Strips all formatting characters from a phone number string.
  ///
  /// Removes spaces, parentheses, and hyphens to produce a raw numeric string.
  ///
  /// Example:
  /// ```dart
  /// '(123) 456-7890'.toRawPhoneNumber()  // Returns '1234567890'
  /// '+1 (123) 456-7890'.toRawPhoneNumber()  // Returns '+11234567890'
  /// ```
  String toRawPhoneNumber() {
    return replaceAll(RegExp('[ ()-]'), '');
  }

  /// Returns the first character of the string as an initial.
  ///
  /// This getter extracts the first character from a string, useful for
  /// generating avatar placeholders, abbreviations, or initial-based identifiers.
  ///
  /// Returns an empty string if the original string is empty.
  ///
  /// Example:
  /// ```dart
  /// 'John Doe'.initials  // Returns 'J'
  /// ''.initials          // Returns ''
  /// ```
  String get initials {
    if (isEmpty) return '';

    final firstChar = Characters(this).firstOrNull;
    return firstChar ?? '';
  }

  /// Converts the first character of the string to uppercase.
  ///
  /// Uses the TextCapitalizationFormatter utility to capitalize the first letter
  /// of the string while preserving the rest of the string.
  ///
  /// Example:
  /// ```dart
  /// 'hello world'.toFirstUpperCase()  // Returns 'Hello world'
  /// 'dart'.toFirstUpperCase()         // Returns 'Dart'
  /// ```
  String toFirstUpperCase() {
    return TextCapitalizationFormatter.inCaps(this);
  }
}
