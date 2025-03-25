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
}
