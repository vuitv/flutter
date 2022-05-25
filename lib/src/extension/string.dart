///
extension StringExt on String {
  /// validate image url
  bool get isImageUrl {
    return startsWith('http');
  }
}
