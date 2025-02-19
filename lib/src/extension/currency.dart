import 'package:vuitv/src/utils/text_input_formatter.dart';

/// Extension methods on [num] to format numbers as currency strings.
extension CurrencyNumExt on num {
  /// Formats the number as a US currency string with '$'
  /// symbol and thousands separators.
  ///
  /// Example:
  /// ```dart
  /// 1234.56.toCurrencyUS // Returns '$1,234.56'
  /// ```
  String get toCurrencyUS => CurrencyInputFormatter.us().format.format(this);

  /// Formats the number as a Vietnamese currency string with 'đ'
  /// symbol and thousands separators.
  ///
  /// Example:
  /// ```dart
  /// 1234.56.toCurrencyVN // Returns '1,235đ'
  /// ```
  String get toCurrencyVN => CurrencyInputFormatter.vn().format.format(this);

  /// Formats the number with thousands separators.
  ///
  /// Example:
  /// ```dart
  /// abc1234.56.toNumberFormat // Returns '123,456'
  /// ```
  String get toNumberFormat => NumberDigitsInputFormatter().format.format(this);
}
