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
}
