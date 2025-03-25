import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
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
  String get toCurrencyUS => toCurrencyString(
        NumberDigitsInputFormatter(decimalDigits: 2).format(this),
        leadingSymbol: r'$',
      );

  /// Formats the number as a Vietnamese currency string with 'đ'
  /// symbol and thousands separators.
  ///
  /// Example:
  /// ```dart
  /// 1234.toCurrencyVN // Returns '1,234đ'
  /// ```
  String get toCurrencyVN => toCurrencyString(
        toNumberFormat,
        mantissaLength: 0,
        trailingSymbol: '₫',
      );

  /// Formats the number with thousands separators.
  ///
  /// Example:
  /// ```dart
  /// abc1234.56.toNumberFormat // Returns '123,456'
  /// ```
  String get toNumberFormat => NumberDigitsInputFormatter().format(this);
}
