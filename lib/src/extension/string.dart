///
extension StringExt on String {
  /// validate image url
  bool get isUrl => startsWith('http');
}
